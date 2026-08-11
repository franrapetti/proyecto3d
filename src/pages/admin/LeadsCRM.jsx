import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '../../lib/supabaseClient';
import { Plus, Trash2, X, Pencil, Calendar, ChevronDown, Search, Inbox } from 'lucide-react';
import './AdminProducts.css';
import './LeadsCRM.css';

const STATUS_OPTIONS = [
  { value: 'Pendiente', label: 'Pendiente' },
  { value: 'Presupuestado', label: 'Presupuestado' },
  { value: 'Aceptado', label: 'Aceptado' },
  { value: 'En Producción', label: 'En Producción' },
  { value: 'Finalizado', label: 'Finalizado' },
  { value: 'Cancelado', label: 'Cancelado' },
];

const EMPTY_FORM = {
  client_name: '',
  request_type: 'ofrecido',
  details: '',
  material_cost: '',
  hours: '',
  unit_cost: '',
  quantity: 1,
  status: 'Pendiente',
  deadline_type: 'asap',
  deadline_date: '',
};

const LeadsCRM = () => {
  const [leads, setLeads] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  // Form panel
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [formData, setFormData] = useState({ ...EMPTY_FORM });

  // Expanded row (detail view)
  const [expandedId, setExpandedId] = useState(null);

  useEffect(() => {
    fetchLeads();
  }, []);

  const fetchLeads = async () => {
    try {
      const { data, error } = await supabase
        .from('custom_leads')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) {
        if (error.code === '42P01') {
          console.error('La tabla custom_leads no existe. Ejecutá el SQL.');
        } else {
          throw error;
        }
      }
      setLeads(data || []);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const filteredLeads = useMemo(() => {
    let result = leads;
    if (statusFilter !== 'all') {
      result = result.filter(l => l.status === statusFilter);
    }
    if (search.trim()) {
      const q = search.toLowerCase();
      result = result.filter(l =>
        l.client_name.toLowerCase().includes(q) ||
        (l.details || '').toLowerCase().includes(q)
      );
    }
    return result;
  }, [leads, search, statusFilter]);

  const openNewForm = () => {
    setEditingId(null);
    setFormData({ ...EMPTY_FORM });
    setShowForm(true);
  };

  const openEditForm = (lead) => {
    setEditingId(lead.id);
    setFormData({
      client_name: lead.client_name || '',
      request_type: lead.request_type || 'ofrecido',
      details: lead.details || '',
      material_cost: lead.material_cost ?? '',
      hours: lead.hours ?? '',
      unit_cost: lead.unit_cost ?? '',
      quantity: lead.quantity ?? 1,
      status: lead.status || 'Pendiente',
      deadline_type: lead.deadline_type || 'asap',
      deadline_date: lead.deadline_date || '',
    });
    setShowForm(true);
  };

  const closeForm = () => {
    setShowForm(false);
    setEditingId(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.client_name.trim()) return;

    setSaving(true);
    try {
      const payload = {
        client_name: formData.client_name,
        request_type: formData.request_type,
        details: formData.details,
        material_cost: Number(formData.material_cost) || 0,
        hours: Number(formData.hours) || 0,
        unit_cost: Number(formData.unit_cost) || 0,
        quantity: Number(formData.quantity) || 1,
        status: formData.status,
        deadline_type: formData.deadline_type,
        deadline_date: formData.deadline_type === 'fecha' && formData.deadline_date
          ? formData.deadline_date
          : null,
      };

      if (editingId) {
        // UPDATE
        const { error } = await supabase
          .from('custom_leads')
          .update(payload)
          .eq('id', editingId);
        if (error) throw error;
        setLeads(prev => prev.map(l => l.id === editingId ? { ...l, ...payload } : l));
      } else {
        // INSERT
        const { data, error } = await supabase
          .from('custom_leads')
          .insert([payload])
          .select();
        if (error) throw error;
        setLeads(prev => [data[0], ...prev]);
      }

      closeForm();
    } catch (error) {
      console.error(error);
      alert('Error al guardar. ¿Ejecutaste el SQL de setup?');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('¿Eliminar este pedido?')) return;
    try {
      const { error } = await supabase.from('custom_leads').delete().eq('id', id);
      if (error) throw error;
      setLeads(prev => prev.filter(l => l.id !== id));
      if (expandedId === id) setExpandedId(null);
    } catch (error) {
      console.error(error);
    }
  };

  const quickStatusChange = async (id, newStatus) => {
    try {
      const { error } = await supabase
        .from('custom_leads')
        .update({ status: newStatus })
        .eq('id', id);
      if (error) throw error;
      setLeads(prev => prev.map(l => l.id === id ? { ...l, status: newStatus } : l));
    } catch (error) {
      console.error(error);
    }
  };

  const setField = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const totalCalculated = (Number(formData.unit_cost) || 0) * (Number(formData.quantity) || 1);

  // KPIs
  const pendingCount = leads.filter(l => l.status === 'Pendiente').length;
  const inProgressCount = leads.filter(l => ['Presupuestado', 'Aceptado', 'En Producción'].includes(l.status)).length;
  const doneCount = leads.filter(l => l.status === 'Finalizado').length;

  const getStatusColor = (status) => {
    switch (status) {
      case 'Pendiente': return '#f59e0b';
      case 'Presupuestado': return '#3b82f6';
      case 'Aceptado': return '#8b5cf6';
      case 'En Producción': return '#f97316';
      case 'Finalizado': return '#22c55e';
      case 'Cancelado': return '#ef4444';
      default: return '#6b7280';
    }
  };

  const formatDeadline = (lead) => {
    if (lead.deadline_type === 'asap' || !lead.deadline_type) return 'Lo antes posible';
    if (lead.deadline_type === 'sin_apuro') return 'Sin apuro';
    if (lead.deadline_type === 'fecha' && lead.deadline_date) {
      return new Date(lead.deadline_date + 'T12:00:00').toLocaleDateString('es-AR', {
        day: '2-digit', month: 'short', year: 'numeric'
      });
    }
    return '—';
  };

  return (
    <div className="admin-page">
      {/* ── HEADER ── */}
      <div className="adm-page-header sticky-header">
        <div className="adm-page-title">
          <h1>Pedidos Personalizados</h1>
          <span className="adm-count-pill">{leads.length} pedidos</span>
        </div>
        <button className="btn-primary" onClick={openNewForm}>
          <Plus size={18} /> Nuevo Pedido
        </button>
      </div>

      {/* ── KPI CARDS ── */}
      <div className="crm-kpi-row">
        <div className="crm-kpi-card">
          <div className="crm-kpi-value" style={{ color: '#f59e0b' }}>{pendingCount}</div>
          <div className="crm-kpi-label">Pendientes</div>
        </div>
        <div className="crm-kpi-card">
          <div className="crm-kpi-value" style={{ color: '#3b82f6' }}>{inProgressCount}</div>
          <div className="crm-kpi-label">En Curso</div>
        </div>
        <div className="crm-kpi-card">
          <div className="crm-kpi-value" style={{ color: '#22c55e' }}>{doneCount}</div>
          <div className="crm-kpi-label">Finalizados</div>
        </div>
        <div className="crm-kpi-card">
          <div className="crm-kpi-value">{leads.length}</div>
          <div className="crm-kpi-label">Total</div>
        </div>
      </div>

      {/* ── FILTERS ── */}
      <div className="crm-filters-row">
        <div className="crm-search-wrap">
          <Search size={16} />
          <input
            type="search"
            placeholder="Buscar por cliente o detalle..."
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
        <div className="crm-status-filters">
          <button
            className={`filter-btn ${statusFilter === 'all' ? 'active' : ''}`}
            onClick={() => setStatusFilter('all')}
          >Todos</button>
          {STATUS_OPTIONS.map(s => (
            <button
              key={s.value}
              className={`filter-btn ${statusFilter === s.value ? 'active' : ''}`}
              onClick={() => setStatusFilter(s.value)}
            >{s.label}</button>
          ))}
        </div>
      </div>

      {/* ── LEADS TABLE ── */}
      <div className="table-container">
        {loading ? (
          <p style={{ padding: '2rem', textAlign: 'center', color: 'var(--text-light)' }}>Cargando pedidos...</p>
        ) : filteredLeads.length === 0 ? (
          <div className="crm-empty-state">
            <Inbox size={48} strokeWidth={1} />
            <p><strong>{leads.length === 0 ? 'No hay pedidos registrados.' : 'Sin resultados para este filtro.'}</strong></p>
            {leads.length === 0 && (
              <button className="btn-primary" onClick={openNewForm} style={{ marginTop: '1rem' }}>
                <Plus size={18} /> Cargar tu primer pedido
              </button>
            )}
          </div>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Fecha</th>
                <th>Cliente</th>
                <th>Tipo</th>
                <th>Entrega</th>
                <th>Precio Unit.</th>
                <th>Cant.</th>
                <th>Total</th>
                <th>Estado</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {filteredLeads.map(lead => (
                <React.Fragment key={lead.id}>
                  <tr
                    className={`crm-row ${expandedId === lead.id ? 'expanded' : ''}`}
                    onClick={() => setExpandedId(expandedId === lead.id ? null : lead.id)}
                    style={{ cursor: 'pointer' }}
                  >
                    <td style={{ fontSize: '0.82rem', color: 'var(--text-light)' }}>
                      {new Date(lead.created_at).toLocaleDateString('es-AR', { day: '2-digit', month: 'short' })}
                    </td>
                    <td style={{ fontWeight: 600 }}>{lead.client_name}</td>
                    <td>
                      <span className="badge-outline">
                        {lead.request_type === 'ofrecido' ? 'Ofrecido' : 'Específico'}
                      </span>
                    </td>
                    <td style={{ fontSize: '0.82rem' }}>
                      <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4 }}>
                        <Calendar size={13} /> {formatDeadline(lead)}
                      </span>
                    </td>
                    <td>{lead.unit_cost ? `$${Number(lead.unit_cost).toLocaleString()}` : '—'}</td>
                    <td style={{ fontWeight: 700 }}>x{lead.quantity || 1}</td>
                    <td style={{ fontWeight: 700, color: 'var(--accent)' }}>
                      {lead.unit_cost
                        ? `$${(lead.unit_cost * (lead.quantity || 1)).toLocaleString()}`
                        : '—'}
                    </td>
                    <td>
                      <select
                        className="crm-status-select"
                        value={lead.status || 'Pendiente'}
                        style={{ color: getStatusColor(lead.status), borderColor: getStatusColor(lead.status) }}
                        onChange={e => { e.stopPropagation(); quickStatusChange(lead.id, e.target.value); }}
                        onClick={e => e.stopPropagation()}
                      >
                        {STATUS_OPTIONS.map(s => (
                          <option key={s.value} value={s.value}>{s.label}</option>
                        ))}
                      </select>
                    </td>
                    <td>
                      <div className="action-buttons" onClick={e => e.stopPropagation()}>
                        <button className="btn-icon" onClick={() => openEditForm(lead)} title="Editar">
                          <Pencil size={15} />
                        </button>
                        <button className="btn-icon text-danger" onClick={() => handleDelete(lead.id)} title="Eliminar">
                          <Trash2 size={15} />
                        </button>
                      </div>
                    </td>
                  </tr>
                  {/* Expanded detail row */}
                  {expandedId === lead.id && (
                    <tr className="crm-detail-row">
                      <td colSpan={9}>
                        <div className="crm-detail-content">
                          <div className="crm-detail-grid">
                            <div>
                              <span className="crm-detail-label">Detalles del Pedido</span>
                              <p>{lead.details || 'Sin detalles cargados.'}</p>
                            </div>
                            <div className="crm-detail-numbers">
                              <div>
                                <span className="crm-detail-label">Costo Material</span>
                                <span>${Number(lead.material_cost || 0).toLocaleString()}</span>
                              </div>
                              <div>
                                <span className="crm-detail-label">Horas Est.</span>
                                <span>{lead.hours || 0}h</span>
                              </div>
                            </div>
                          </div>
                        </div>
                      </td>
                    </tr>
                  )}
                </React.Fragment>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* ── SLIDE-IN FORM PANEL ── */}
      {showForm && (
        <div className="crm-overlay" onClick={closeForm}>
          <div className="crm-panel" onClick={e => e.stopPropagation()}>
            <div className="crm-panel-header">
              <h2>{editingId ? 'Editar Pedido' : 'Nuevo Pedido'}</h2>
              <button className="crm-panel-close" onClick={closeForm}>
                <X size={22} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="admin-form crm-panel-body">
              {/* Client + Type */}
              <div className="crm-form-group">
                <label>Cliente / Contacto</label>
                <input
                  type="text"
                  required
                  placeholder="Ej: Juan Pérez - IG @juan"
                  value={formData.client_name}
                  onChange={e => setField('client_name', e.target.value)}
                  autoFocus
                />
              </div>

              <div className="crm-form-group">
                <label>Tipo de Pedido</label>
                <select value={formData.request_type} onChange={e => setField('request_type', e.target.value)}>
                  <option value="ofrecido">Le Ofrecimos</option>
                  <option value="modelo_especifico">Modelo Específico Solicitado</option>
                </select>
              </div>

              <div className="crm-form-group">
                <label>Detalles del Pedido</label>
                <textarea
                  placeholder="Ej: Quiere un mate imperial con el escudo de Boca..."
                  value={formData.details}
                  onChange={e => setField('details', e.target.value)}
                  rows={3}
                />
              </div>

              {/* Deadline */}
              <div className="crm-form-group">
                <label>Plazo de Entrega</label>
                <div className="crm-deadline-options">
                  {[
                    { value: 'asap', label: 'Lo antes posible' },
                    { value: 'sin_apuro', label: 'Sin apuro' },
                    { value: 'fecha', label: 'Fecha específica' },
                  ].map(opt => (
                    <button
                      key={opt.value}
                      type="button"
                      className={`crm-deadline-btn ${formData.deadline_type === opt.value ? 'active' : ''}`}
                      onClick={() => setField('deadline_type', opt.value)}
                    >
                      {opt.label}
                    </button>
                  ))}
                </div>
                {formData.deadline_type === 'fecha' && (
                  <input
                    type="date"
                    value={formData.deadline_date}
                    onChange={e => setField('deadline_date', e.target.value)}
                    style={{ marginTop: '0.5rem' }}
                  />
                )}
              </div>

              <div className="crm-form-divider" />

              {/* Costs */}
              <div className="crm-form-row">
                <div className="crm-form-group">
                  <label>Costo de Material ($)</label>
                  <input
                    type="number"
                    placeholder="Ej: 2500"
                    value={formData.material_cost}
                    onChange={e => setField('material_cost', e.target.value)}
                  />
                </div>
                <div className="crm-form-group">
                  <label>Horas Estimadas</label>
                  <input
                    type="number"
                    step="0.5"
                    placeholder="Ej: 4"
                    value={formData.hours}
                    onChange={e => setField('hours', e.target.value)}
                  />
                </div>
              </div>

              <div className="crm-form-row">
                <div className="crm-form-group">
                  <label>Precio Unitario ($)</label>
                  <input
                    type="number"
                    placeholder="Opcional"
                    value={formData.unit_cost}
                    onChange={e => setField('unit_cost', e.target.value)}
                  />
                </div>
                <div className="crm-form-group">
                  <label>Cantidad</label>
                  <input
                    type="number"
                    min="1"
                    value={formData.quantity}
                    onChange={e => setField('quantity', e.target.value)}
                  />
                </div>
              </div>

              {totalCalculated > 0 && (
                <div className="crm-total-preview">
                  Total estimado: <strong>${totalCalculated.toLocaleString()}</strong>
                </div>
              )}

              <div className="crm-form-group">
                <label>Estado</label>
                <select value={formData.status} onChange={e => setField('status', e.target.value)}>
                  {STATUS_OPTIONS.map(s => (
                    <option key={s.value} value={s.value}>{s.label}</option>
                  ))}
                </select>
              </div>

              <button type="submit" className="btn-primary btn-submit" disabled={saving || !formData.client_name}>
                {saving
                  ? 'Guardando...'
                  : editingId
                    ? 'Guardar Cambios'
                    : 'Crear Pedido'}
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default LeadsCRM;
