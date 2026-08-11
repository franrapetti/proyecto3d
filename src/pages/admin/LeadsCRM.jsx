import React, { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabaseClient';
import { Plus, Trash2, Check, Clock, Package } from 'lucide-react';
import './AdminProducts.css'; // Reusing form styles

const LeadsCRM = () => {
  const [leads, setLeads] = useState([]);
  const [loading, setLoading] = useState(true);
  const [adding, setAdding] = useState(false);

  const [formData, setFormData] = useState({
    client_name: '',
    request_type: 'ofrecido',
    details: '',
    material_cost: '',
    hours: '',
    unit_cost: '',
    quantity: 1,
    status: 'Pendiente'
  });

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
          console.error('La tabla custom_leads no existe.');
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

  const handleAdd = async (e) => {
    e.preventDefault();
    if (!formData.client_name.trim()) return;

    setAdding(true);
    try {
      const payload = {
        ...formData,
        material_cost: Number(formData.material_cost) || 0,
        hours: Number(formData.hours) || 0,
        unit_cost: Number(formData.unit_cost) || 0,
        quantity: Number(formData.quantity) || 1,
      };

      const { data, error } = await supabase
        .from('custom_leads')
        .insert([payload])
        .select();

      if (error) throw error;
      setLeads([data[0], ...leads]);
      setFormData({
        client_name: '',
        request_type: 'ofrecido',
        details: '',
        material_cost: '',
        hours: '',
        unit_cost: '',
        quantity: 1,
        status: 'Pendiente'
      });
    } catch (error) {
      console.error(error);
      alert('Error al guardar el pedido. ¿Ejecutaste el SQL?');
    } finally {
      setAdding(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('¿Seguro que deseas eliminar este pedido?')) return;
    try {
      const { error } = await supabase.from('custom_leads').delete().eq('id', id);
      if (error) throw error;
      setLeads(leads.filter(l => l.id !== id));
    } catch (error) {
      console.error(error);
    }
  };

  const setField = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const totalCalculated = (Number(formData.unit_cost) || 0) * (Number(formData.quantity) || 1);

  return (
    <div className="admin-page">
      <div className="adm-page-header sticky-header">
        <div className="adm-page-title">
          <h1>📦 Pedidos Personalizados (CRM)</h1>
        </div>
      </div>

      <div className="form-sections-grid" style={{ marginBottom: '2rem' }}>
        <div className="form-section-card full-width">
          <h3 className="section-title">Añadir Nuevo Pedido</h3>
          
          <form onSubmit={handleAdd}>
            <div className="form-row" style={{ marginBottom: '1rem' }}>
              <div className="form-group">
                <label>Cliente / Contacto</label>
                <input
                  type="text"
                  required
                  placeholder="Ej: Juan Pérez - IG @juan"
                  value={formData.client_name}
                  onChange={e => setField('client_name', e.target.value)}
                />
              </div>
              <div className="form-group">
                <label>Tipo de Pedido</label>
                <select value={formData.request_type} onChange={e => setField('request_type', e.target.value)}>
                  <option value="ofrecido">Le Ofrecimos</option>
                  <option value="modelo_especifico">Modelo Específico Solicitado</option>
                </select>
              </div>
            </div>

            <div className="form-group" style={{ marginBottom: '1rem' }}>
              <label>Detalles del Pedido</label>
              <textarea
                placeholder="Ej: Quiere un mate imperial con el escudo de Boca..."
                value={formData.details}
                onChange={e => setField('details', e.target.value)}
                rows={2}
              />
            </div>

            <div className="form-row" style={{ marginBottom: '1rem' }}>
              <div className="form-group">
                <label>Costo de Material ($)</label>
                <input
                  type="number"
                  placeholder="Ej: 2500"
                  value={formData.material_cost}
                  onChange={e => setField('material_cost', e.target.value)}
                />
              </div>
              <div className="form-group">
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

            <div className="form-row" style={{ marginBottom: '1rem' }}>
              <div className="form-group">
                <label>Costo Unitario ($)</label>
                <input
                  type="number"
                  required
                  placeholder="Ej: 15000"
                  value={formData.unit_cost}
                  onChange={e => setField('unit_cost', e.target.value)}
                />
              </div>
              <div className="form-group">
                <label>Cantidad</label>
                <input
                  type="number"
                  min="1"
                  required
                  value={formData.quantity}
                  onChange={e => setField('quantity', e.target.value)}
                />
              </div>
            </div>

            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '1.5rem', paddingTop: '1rem', borderTop: '1px solid var(--border)' }}>
              <div style={{ fontSize: '1.1rem', fontWeight: 700 }}>
                Costo Total: <span style={{ color: 'var(--accent)' }}>${totalCalculated.toLocaleString()}</span>
              </div>
              <button type="submit" className="btn-primary" disabled={adding || !formData.client_name}>
                <Plus size={18} /> {adding ? 'Guardando...' : 'Guardar Pedido'}
              </button>
            </div>
          </form>
        </div>
      </div>

      <div className="table-container">
        {loading ? (
          <p style={{ padding: '2rem', textAlign: 'center' }}>Cargando...</p>
        ) : leads.length === 0 ? (
          <p style={{ padding: '2rem', textAlign: 'center' }}>No hay pedidos registrados.</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Fecha</th>
                <th>Cliente</th>
                <th>Tipo</th>
                <th>Costo Mat.</th>
                <th>Costo Unit.</th>
                <th>Cant.</th>
                <th>Total</th>
                <th>Estado</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {leads.map(lead => (
                <tr key={lead.id}>
                  <td>{new Date(lead.created_at).toLocaleDateString()}</td>
                  <td style={{ fontWeight: 600 }}>{lead.client_name}</td>
                  <td>{lead.request_type === 'ofrecido' ? 'Ofrecido' : 'Específico'}</td>
                  <td>${lead.material_cost?.toLocaleString()}</td>
                  <td>${lead.unit_cost?.toLocaleString()}</td>
                  <td style={{ fontWeight: 700 }}>x{lead.quantity}</td>
                  <td style={{ fontWeight: 700, color: 'var(--accent)' }}>
                    ${(lead.unit_cost * lead.quantity).toLocaleString()}
                  </td>
                  <td>
                    <span className={`badge ${lead.status === 'Pendiente' ? 'badge-outline' : ''}`}>
                      {lead.status}
                    </span>
                  </td>
                  <td style={{ textAlign: 'right' }}>
                    <button onClick={() => handleDelete(lead.id)} className="btn-icon text-danger">
                      <Trash2 size={16} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
};

export default LeadsCRM;
