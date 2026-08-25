import React, { useState, useMemo, useEffect, useRef } from 'react';
import { supabase } from '../../lib/supabaseClient';
import {
  Save, Download, Trash2, RotateCcw, ChevronDown, ChevronUp,
  Upload, Printer, Zap, Package, TrendingUp, CreditCard
} from 'lucide-react';
import html2canvas from 'html2canvas';
import './CostCalculator.css';
import './AdminProducts.css';

// ── Comisiones de Mercado Pago Argentina (2025/2026) ──
const COMMISSION_PRESETS = [
  { id: 'checkout_35d',       label: 'Checkout Online — 35 días',     rate: 0.0179 },
  { id: 'checkout_18d',       label: 'Checkout Online — 18 días',     rate: 0.0360 },
  { id: 'checkout_10d',       label: 'Checkout Online — 10 días',     rate: 0.0450 },
  { id: 'checkout_instant',   label: 'Checkout Online — Inmediato',   rate: 0.0660 },
  { id: 'point_debit_2d',     label: 'Point Débito — 2 días',         rate: 0.0299 },
  { id: 'point_debit_instant',label: 'Point Débito — Inmediato',      rate: 0.0341 },
  { id: 'point_credit_30d',   label: 'Point Crédito — 30 días',       rate: 0.0179 },
  { id: 'point_credit_instant',label:'Point Crédito — Inmediato',     rate: 0.0660 },
  { id: 'qr_wallet',          label: 'QR Débito / Cuenta MP',         rate: 0.0135 },
  { id: 'qr_credit',          label: 'QR Crédito',                    rate: 0.0660 },
  { id: 'custom',             label: 'Personalizado',                 rate: 0 },
];

const INSTALLMENT_OPTIONS = [
  { id: 'none', label: 'Sin cuotas',              rate: 0 },
  { id: '3',    label: '3 cuotas sin interés',     rate: 0.10 },
  { id: '6',    label: '6 cuotas sin interés',     rate: 0.18 },
  { id: '9',    label: '9 cuotas sin interés',     rate: 0.225 },
  { id: '12',   label: '12 cuotas sin interés',    rate: 0.29 },
];

const LIFETIME_OPTIONS = [4000, 4500, 5000];
const IVA_RATE = 0.21;

const DEFAULT_VALUES = {
  budgetName: '',
  printerCost: 1500000,
  sparePartsCost: 150000,
  lifetimeHours: 5000,
  filamentCostPerKg: 20000,
  filamentUsedGrams: '',
  electricityCostKwh: 250,
  printerWatts: 150,
  printHours: '',
  extraSupplies: 0,
  packaging: 0,
  profitMargin: 30,
  commissionPreset: 'checkout_35d',
  installments: 'none',
  customCommission: 5,
};

const fmt = (n) => `$${Number(n || 0).toLocaleString('es-AR', { minimumFractionDigits: 0, maximumFractionDigits: 2 })}`;
const pct = (n) => `${(Number(n || 0) * 100).toFixed(2)}%`;

// ═══════════════════════════════════════════
// COMPONENTE PRINCIPAL
// ═══════════════════════════════════════════
const CostCalculator = () => {
  const [inputs, setInputs] = useState(DEFAULT_VALUES);
  const [budgets, setBudgets] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [showHistory, setShowHistory] = useState(false);
  const exportRef = useRef(null);

  // ── Fetch presupuestos guardados ──
  useEffect(() => {
    (async () => {
      try {
        const { data, error } = await supabase
          .from('print_budgets')
          .select('*')
          .order('created_at', { ascending: false });
        if (error) {
          if (error.code === '42P01') console.warn('Tabla print_budgets no existe. Ejecutá el SQL.');
          else throw error;
        }
        setBudgets(data || []);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    })();
  }, []);

  // ── Cálculos en tiempo real ──
  const results = useMemo(() => {
    const pc   = Number(inputs.printerCost) || 0;
    const sp   = Number(inputs.sparePartsCost) || 0;
    const lh   = Number(inputs.lifetimeHours) || 5000;
    const fckg = Number(inputs.filamentCostPerKg) || 0;
    const fug  = Number(inputs.filamentUsedGrams) || 0;
    const eckwh= Number(inputs.electricityCostKwh) || 0;
    const pw   = Number(inputs.printerWatts) || 0;
    const ph   = Number(inputs.printHours) || 0;
    const es   = Number(inputs.extraSupplies) || 0;
    const pkg  = Number(inputs.packaging) || 0;
    const pm   = Number(inputs.profitMargin) || 0;

    // Depreciación
    const depreciationPerHour = lh > 0 ? (pc + sp) / lh : 0;
    const depreciationCost = depreciationPerHour * ph;

    // Filamento
    const filamentTotalCost = fckg > 0 ? (fckg / 1000) * fug : 0;

    // Electricidad
    const electricityCost = (pw / 1000) * ph * eckwh;

    // Costo total
    const totalCost = depreciationCost + filamentTotalCost + electricityCost + es + pkg;

    // Precio sin comisión
    const priceNoCommission = totalCost * (1 + pm / 100);

    // Comisión efectiva
    const preset = COMMISSION_PRESETS.find(p => p.id === inputs.commissionPreset);
    const baseRate = inputs.commissionPreset === 'custom'
      ? (Number(inputs.customCommission) || 0) / 100
      : (preset?.rate || 0);
    const installmentOpt = INSTALLMENT_OPTIONS.find(i => i.id === inputs.installments);
    const installmentRate = installmentOpt?.rate || 0;

    // IVA se aplica sobre la comisión, no sobre la venta
    const totalCommissionRate = (baseRate + installmentRate) * (1 + IVA_RATE);

    // Precio con comisión: cobrar más para que después del descuento de MP quede el precio deseado
    const priceWithCommission = totalCommissionRate < 1
      ? priceNoCommission / (1 - totalCommissionRate)
      : priceNoCommission;

    const commissionAmount = priceWithCommission - priceNoCommission;

    return {
      depreciationPerHour,
      depreciationCost,
      filamentTotalCost,
      electricityCost,
      totalCost,
      priceNoCommission,
      priceWithCommission,
      totalCommissionRate,
      commissionAmount,
      baseRate,
      installmentRate,
    };
  }, [inputs]);

  // ── Helpers ──
  const setField = (field, value) => setInputs(prev => ({ ...prev, [field]: value }));

  const handleSave = async () => {
    setSaving(true);
    try {
      const preset = COMMISSION_PRESETS.find(p => p.id === inputs.commissionPreset);
      const payload = {
        budget_name: inputs.budgetName || `Presupuesto ${new Date().toLocaleDateString('es-AR')}`,
        printer_cost: Number(inputs.printerCost) || 0,
        spare_parts_cost: Number(inputs.sparePartsCost) || 0,
        printer_lifetime_hours: Number(inputs.lifetimeHours) || 5000,
        filament_cost: Number(inputs.filamentCostPerKg) || 0,
        filament_used: Number(inputs.filamentUsedGrams) || 0,
        electricity_cost_kwh: Number(inputs.electricityCostKwh) || 0,
        printer_watts: Number(inputs.printerWatts) || 0,
        print_hours: Number(inputs.printHours) || 0,
        extra_supplies: Number(inputs.extraSupplies) || 0,
        packaging: Number(inputs.packaging) || 0,
        profit_margin: Number(inputs.profitMargin) || 0,
        depreciation_cost: results.depreciationCost,
        filament_total_cost: results.filamentTotalCost,
        electricity_cost: results.electricityCost,
        total_cost: results.totalCost,
        price_without_commission: results.priceNoCommission,
        price_with_commission: results.priceWithCommission,
        commission_type: inputs.commissionPreset === 'custom'
          ? `Personalizado (${inputs.customCommission}%)`
          : (preset?.label || ''),
        installments: inputs.installments,
      };

      const { data, error } = await supabase
        .from('print_budgets')
        .insert([payload])
        .select();

      if (error) throw error;
      setBudgets(prev => [data[0], ...prev]);
      alert('✅ Presupuesto guardado');
    } catch (err) {
      console.error(err);
      alert('Error al guardar. ¿Ejecutaste setup_calculator.sql en Supabase?');
    } finally {
      setSaving(false);
    }
  };

  const handleExport = async () => {
    if (!exportRef.current) return;
    try {
      const el = exportRef.current;
      el.style.display = 'block';
      el.style.position = 'fixed';
      el.style.left = '-9999px';
      el.style.top = '0';

      const canvas = await html2canvas(el, {
        backgroundColor: '#0a0a0a',
        scale: 2,
        useCORS: true,
        logging: false,
      });

      el.style.display = 'none';
      el.style.position = '';
      el.style.left = '';
      el.style.top = '';

      const link = document.createElement('a');
      const safeName = (inputs.budgetName || 'impresion-3d').replace(/[^a-zA-Z0-9áéíóúñ ]/gi, '').replace(/\s+/g, '-').toLowerCase();
      link.download = `presupuesto-${safeName}-${new Date().toISOString().slice(0, 10)}.png`;
      link.href = canvas.toDataURL('image/png');
      link.click();
    } catch (err) {
      console.error(err);
      alert('Error al exportar imagen');
    }
  };

  const loadBudget = (b) => {
    setInputs({
      budgetName: b.budget_name || '',
      printerCost: b.printer_cost ?? 1500000,
      sparePartsCost: b.spare_parts_cost ?? 150000,
      lifetimeHours: b.printer_lifetime_hours ?? 5000,
      filamentCostPerKg: b.filament_cost ?? 20000,
      filamentUsedGrams: b.filament_used ?? 0,
      electricityCostKwh: b.electricity_cost_kwh ?? 250,
      printerWatts: b.printer_watts ?? 150,
      printHours: b.print_hours ?? 0,
      extraSupplies: b.extra_supplies ?? 0,
      packaging: b.packaging ?? 0,
      profitMargin: b.profit_margin ?? 30,
      commissionPreset: 'checkout_35d',
      installments: b.installments || 'none',
      customCommission: 5,
    });
    setShowHistory(false);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const deleteBudget = async (id, e) => {
    e.stopPropagation();
    if (!window.confirm('¿Eliminar este presupuesto?')) return;
    try {
      const { error } = await supabase.from('print_budgets').delete().eq('id', id);
      if (error) throw error;
      setBudgets(prev => prev.filter(b => b.id !== id));
    } catch (err) { console.error(err); }
  };

  const resetForm = () => setInputs(DEFAULT_VALUES);

  // ═══════════════════════════════════════
  // RENDER
  // ═══════════════════════════════════════
  return (
    <div className="admin-page">
      {/* Header */}
      <div className="adm-page-header">
        <div className="adm-page-title">
          <h1>🧮 Calculadora de Costos 3D</h1>
        </div>
      </div>

      {/* Budget Name */}
      <div className="calc-name-input">
        <input
          type="text"
          placeholder="Nombre del presupuesto (ej: Soporte celular x5 — Cliente Pedro)"
          value={inputs.budgetName}
          onChange={e => setField('budgetName', e.target.value)}
        />
      </div>

      <div className="calc-layout">
        {/* ═══ COLUMNA IZQUIERDA: INPUTS ═══ */}
        <div className="calc-inputs">

          {/* ── Impresora ── */}
          <div className="calc-section accent-blue">
            <div className="calc-section-header">
              <span className="calc-section-icon"><Printer size={18} /></span>
              <h3>Impresora</h3>
            </div>
            <div className="calc-fields-grid cols-3">
              <div className="calc-field">
                <label>Costo impresora ($)</label>
                <input
                  type="number"
                  value={inputs.printerCost}
                  onChange={e => setField('printerCost', e.target.value)}
                  placeholder="Ej: 1500000"
                />
              </div>
              <div className="calc-field">
                <label>Costo repuestos ($) <span className="field-hint">(vida útil)</span></label>
                <input
                  type="number"
                  value={inputs.sparePartsCost}
                  onChange={e => setField('sparePartsCost', e.target.value)}
                  placeholder="Ej: 150000"
                />
              </div>
              <div className="calc-field">
                <label>Vida útil (horas)</label>
                <select
                  value={inputs.lifetimeHours}
                  onChange={e => setField('lifetimeHours', e.target.value)}
                >
                  {LIFETIME_OPTIONS.map(h => (
                    <option key={h} value={h}>{h.toLocaleString()} hs</option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          {/* ── Material ── */}
          <div className="calc-section accent-green">
            <div className="calc-section-header">
              <span className="calc-section-icon">🧵</span>
              <h3>Material</h3>
            </div>
            <div className="calc-fields-grid">
              <div className="calc-field">
                <label>Costo filamento ($/kg)</label>
                <input
                  type="number"
                  value={inputs.filamentCostPerKg}
                  onChange={e => setField('filamentCostPerKg', e.target.value)}
                  placeholder="Ej: 20000"
                />
              </div>
              <div className="calc-field">
                <label>Filamento utilizado (gramos)</label>
                <input
                  type="number"
                  value={inputs.filamentUsedGrams}
                  onChange={e => setField('filamentUsedGrams', e.target.value)}
                  placeholder="Ej: 85"
                />
              </div>
            </div>
          </div>

          {/* ── Energía ── */}
          <div className="calc-section accent-amber">
            <div className="calc-section-header">
              <span className="calc-section-icon"><Zap size={18} /></span>
              <h3>Energía</h3>
            </div>
            <div className="calc-fields-grid cols-3">
              <div className="calc-field">
                <label>Costo kWh ($)</label>
                <input
                  type="number"
                  value={inputs.electricityCostKwh}
                  onChange={e => setField('electricityCostKwh', e.target.value)}
                  placeholder="Ej: 250"
                />
              </div>
              <div className="calc-field">
                <label>Consumo impresora (W)</label>
                <input
                  type="number"
                  value={inputs.printerWatts}
                  onChange={e => setField('printerWatts', e.target.value)}
                  placeholder="Ej: 150"
                />
              </div>
              <div className="calc-field">
                <label>Horas de impresión</label>
                <input
                  type="number"
                  step="0.5"
                  value={inputs.printHours}
                  onChange={e => setField('printHours', e.target.value)}
                  placeholder="Ej: 8"
                />
              </div>
            </div>
          </div>

          {/* ── Extras ── */}
          <div className="calc-section accent-purple">
            <div className="calc-section-header">
              <span className="calc-section-icon"><Package size={18} /></span>
              <h3>Extras</h3>
            </div>
            <div className="calc-fields-grid">
              <div className="calc-field">
                <label>Insumos extra ($)</label>
                <input
                  type="number"
                  value={inputs.extraSupplies}
                  onChange={e => setField('extraSupplies', e.target.value)}
                  placeholder="0"
                />
              </div>
              <div className="calc-field">
                <label>Packaging ($)</label>
                <input
                  type="number"
                  value={inputs.packaging}
                  onChange={e => setField('packaging', e.target.value)}
                  placeholder="0"
                />
              </div>
            </div>
          </div>

          {/* ── Rentabilidad & Comisiones ── */}
          <div className="calc-section accent-rose">
            <div className="calc-section-header">
              <span className="calc-section-icon"><TrendingUp size={18} /></span>
              <h3>Rentabilidad & Comisiones</h3>
            </div>
            <div className="calc-fields-grid">
              <div className="calc-field">
                <label>Rentabilidad esperada (%)</label>
                <div className="input-with-unit">
                  <input
                    type="number"
                    step="1"
                    value={inputs.profitMargin}
                    onChange={e => setField('profitMargin', e.target.value)}
                    placeholder="30"
                  />
                  <span className="input-unit">%</span>
                </div>
              </div>
              <div className="calc-field">
                <label>Cuotas sin interés</label>
                <select
                  value={inputs.installments}
                  onChange={e => setField('installments', e.target.value)}
                >
                  {INSTALLMENT_OPTIONS.map(opt => (
                    <option key={opt.id} value={opt.id}>{opt.label}</option>
                  ))}
                </select>
              </div>
              <div className="calc-field full-width">
                <label><CreditCard size={14} style={{ verticalAlign: 'middle', marginRight: 4 }} /> Tipo de cobro Mercado Pago</label>
                <select
                  value={inputs.commissionPreset}
                  onChange={e => setField('commissionPreset', e.target.value)}
                >
                  {COMMISSION_PRESETS.map(p => (
                    <option key={p.id} value={p.id}>
                      {p.label}{p.id !== 'custom' ? ` (${(p.rate * 100).toFixed(2)}% + IVA)` : ''}
                    </option>
                  ))}
                </select>
              </div>
              {inputs.commissionPreset === 'custom' && (
                <div className="calc-field full-width">
                  <label>Comisión personalizada (%)</label>
                  <div className="input-with-unit">
                    <input
                      type="number"
                      step="0.1"
                      value={inputs.customCommission}
                      onChange={e => setField('customCommission', e.target.value)}
                      placeholder="5"
                    />
                    <span className="input-unit">%</span>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* ═══ COLUMNA DERECHA: RESULTADOS ═══ */}
        <div className="calc-results">
          <div className="calc-results-card">
            <div className="calc-results-title">Desglose de costos</div>

            {/* Breakdown */}
            <div className="calc-breakdown">
              <div className="calc-breakdown-row">
                <span className="calc-breakdown-label">Depreciación ({fmt(results.depreciationPerHour)}/h)</span>
                <span className="calc-breakdown-value">{fmt(results.depreciationCost)}</span>
              </div>
              <div className="calc-breakdown-row">
                <span className="calc-breakdown-label">Filamento ({inputs.filamentUsedGrams || 0}g)</span>
                <span className="calc-breakdown-value">{fmt(results.filamentTotalCost)}</span>
              </div>
              <div className="calc-breakdown-row">
                <span className="calc-breakdown-label">Electricidad ({inputs.printHours || 0}h × {inputs.printerWatts}W)</span>
                <span className="calc-breakdown-value">{fmt(results.electricityCost)}</span>
              </div>
              {Number(inputs.extraSupplies) > 0 && (
                <div className="calc-breakdown-row">
                  <span className="calc-breakdown-label">Insumos extra</span>
                  <span className="calc-breakdown-value">{fmt(inputs.extraSupplies)}</span>
                </div>
              )}
              {Number(inputs.packaging) > 0 && (
                <div className="calc-breakdown-row">
                  <span className="calc-breakdown-label">Packaging</span>
                  <span className="calc-breakdown-value">{fmt(inputs.packaging)}</span>
                </div>
              )}
            </div>

            {/* Total */}
            <div className="calc-total-row">
              <span className="calc-total-label">Costo Total</span>
              <span className="calc-total-value">{fmt(results.totalCost)}</span>
            </div>

            {/* Prices */}
            <div className="calc-price-cards">
              <div className="calc-price-card green">
                <div className="calc-price-card-label">Precio sin comisión</div>
                <div className="calc-price-card-value">{fmt(results.priceNoCommission)}</div>
                <div className="calc-price-card-sub">Rentabilidad: {inputs.profitMargin}%</div>
              </div>
              <div className="calc-price-card blue">
                <div className="calc-price-card-label">Precio con Mercado Pago</div>
                <div className="calc-price-card-value">{fmt(results.priceWithCommission)}</div>
                <div className="calc-price-card-sub">
                  Comisión efectiva: {pct(results.totalCommissionRate)} · Recargo: {fmt(results.commissionAmount)}
                </div>
              </div>
            </div>

            {/* Commission info */}
            <div className="calc-commission-info">
              Base: <span>{pct(results.baseRate)}</span>
              {results.installmentRate > 0 && <> + Cuotas: <span>{pct(results.installmentRate)}</span></>}
              {' '}+ IVA 21% = <span>{pct(results.totalCommissionRate)}</span>
            </div>

            {/* Actions */}
            <div className="calc-actions">
              <button className="calc-btn calc-btn-save" onClick={handleSave} disabled={saving}>
                <Save size={16} /> {saving ? 'Guardando...' : 'Guardar'}
              </button>
              <button className="calc-btn calc-btn-export" onClick={handleExport}>
                <Download size={16} /> Exportar
              </button>
              <button className="calc-btn calc-btn-reset" onClick={resetForm} title="Resetear valores">
                <RotateCcw size={16} />
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* ═══ HISTORIAL ═══ */}
      <div className="calc-history-section">
        <button
          className="calc-history-toggle"
          onClick={() => setShowHistory(!showHistory)}
        >
          <h3>📋 Presupuestos Guardados</h3>
          <span className="badge-count">{budgets.length}</span>
          {showHistory ? <ChevronUp size={18} /> : <ChevronDown size={18} />}
        </button>

        {showHistory && (
          <div className="calc-history-content">
            {loading ? (
              <div className="calc-history-empty">Cargando...</div>
            ) : budgets.length === 0 ? (
              <div className="calc-history-empty">
                No hay presupuestos guardados aún. Completá la calculadora y hacé click en <strong>Guardar</strong>.
              </div>
            ) : (
              <div className="calc-history-grid">
                {budgets.map(b => (
                  <div key={b.id} className="calc-history-card" onClick={() => loadBudget(b)}>
                    <div className="calc-history-card-header">
                      <span className="calc-history-card-name">{b.budget_name}</span>
                      <span className="calc-history-card-date">
                        {new Date(b.created_at).toLocaleDateString('es-AR')}
                      </span>
                    </div>
                    <div className="calc-history-card-prices">
                      <div className="calc-history-price">
                        <div className="calc-history-price-label">Costo</div>
                        <div className="calc-history-price-value">{fmt(b.total_cost)}</div>
                      </div>
                      <div className="calc-history-price">
                        <div className="calc-history-price-label">Precio c/ MP</div>
                        <div className="calc-history-price-value">{fmt(b.price_with_commission)}</div>
                      </div>
                    </div>
                    <div className="calc-history-card-actions">
                      <button className="calc-history-btn" onClick={(e) => { e.stopPropagation(); loadBudget(b); }}>
                        <Upload size={13} /> Cargar
                      </button>
                      <button className="calc-history-btn danger" onClick={(e) => deleteBudget(b.id, e)}>
                        <Trash2 size={13} /> Eliminar
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>

      {/* ═══ EXPORT TEMPLATE (hidden, capturado por html2canvas) ═══ */}
      <div ref={exportRef} className="calc-export-template">
        <div className="calc-export-header">
          <div>
            <div className="calc-export-brand">Punto Base</div>
            <div className="calc-export-subtitle">Presupuesto de Impresión 3D</div>
          </div>
          <div className="calc-export-meta">
            <div>{new Date().toLocaleDateString('es-AR', { day: '2-digit', month: 'long', year: 'numeric' })}</div>
          </div>
        </div>

        {inputs.budgetName && (
          <div className="calc-export-name">{inputs.budgetName}</div>
        )}

        <table className="calc-export-table">
          <thead>
            <tr>
              <th>Concepto</th>
              <th>Monto</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Depreciación impresora ({fmt(results.depreciationPerHour)}/h × {inputs.printHours || 0}h)</td>
              <td>{fmt(results.depreciationCost)}</td>
            </tr>
            <tr>
              <td>Filamento ({inputs.filamentUsedGrams || 0}g a {fmt(inputs.filamentCostPerKg)}/kg)</td>
              <td>{fmt(results.filamentTotalCost)}</td>
            </tr>
            <tr>
              <td>Electricidad ({inputs.printerWatts}W × {inputs.printHours || 0}h a {fmt(inputs.electricityCostKwh)}/kWh)</td>
              <td>{fmt(results.electricityCost)}</td>
            </tr>
            {Number(inputs.extraSupplies) > 0 && (
              <tr>
                <td>Insumos extra</td>
                <td>{fmt(inputs.extraSupplies)}</td>
              </tr>
            )}
            {Number(inputs.packaging) > 0 && (
              <tr>
                <td>Packaging</td>
                <td>{fmt(inputs.packaging)}</td>
              </tr>
            )}
            <tr className="total-row">
              <td>COSTO TOTAL</td>
              <td>{fmt(results.totalCost)}</td>
            </tr>
          </tbody>
        </table>

        <div className="calc-export-prices">
          <div className="calc-export-price-box green">
            <div className="calc-export-price-box-label">Precio sin comisión</div>
            <div className="calc-export-price-box-value">{fmt(results.priceNoCommission)}</div>
            <div className="calc-export-price-box-sub">Rentabilidad: {inputs.profitMargin}%</div>
          </div>
          <div className="calc-export-price-box blue">
            <div className="calc-export-price-box-label">Precio con Mercado Pago</div>
            <div className="calc-export-price-box-value">{fmt(results.priceWithCommission)}</div>
            <div className="calc-export-price-box-sub">Comisión: {pct(results.totalCommissionRate)}</div>
          </div>
        </div>

        <div className="calc-export-footer">
          Generado con Punto Base · {new Date().toLocaleDateString('es-AR')}
        </div>
      </div>
    </div>
  );
};

export default CostCalculator;
