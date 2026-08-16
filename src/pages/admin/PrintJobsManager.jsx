import React, { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabaseClient';
import { Plus, Trash2, CheckCircle, Circle, AlertTriangle, Inbox as InboxIcon } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import './AdminProducts.css';
import '../admin/LeadsCRM.css';

const PrintJobsManager = () => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [adding, setAdding] = useState(false);
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    job_name: '',
    filament_used: '',
    energy_used: '',
    savings_amount: '',
    emergency_amount: ''
  });

  useEffect(() => {
    fetchJobs();
  }, []);

  const fetchJobs = async () => {
    try {
      const { data, error } = await supabase
        .from('print_jobs')
        .select('*')
        .order('created_at', { ascending: false });
      
      if (error) {
        if (error.code === '42P01') console.error('La tabla print_jobs no existe.');
        else throw error;
      }
      setJobs(data || []);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleAdd = async (e) => {
    e.preventDefault();
    if (!formData.job_name.trim()) return;

    setAdding(true);
    try {
      const payload = {
        ...formData,
        filament_used: Number(formData.filament_used) || 0,
        energy_used: Number(formData.energy_used) || 0,
        savings_amount: Number(formData.savings_amount) || 0,
        emergency_amount: Number(formData.emergency_amount) || 0,
      };

      const { data, error } = await supabase
        .from('print_jobs')
        .insert([payload])
        .select();

      if (error) throw error;
      setJobs([data[0], ...jobs]);
      setFormData({
        job_name: '',
        filament_used: '',
        energy_used: '',
        savings_amount: '',
        emergency_amount: ''
      });
    } catch (error) {
      console.error(error);
      alert('Error al guardar. ¿Ejecutaste el SQL?');
    } finally {
      setAdding(false);
    }
  };

  const toggleStatus = async (id, field, currentValue) => {
    try {
      const { error } = await supabase
        .from('print_jobs')
        .update({ [field]: !currentValue })
        .eq('id', id);
      if (error) throw error;
      
      setJobs(jobs.map(j => j.id === id ? { ...j, [field]: !currentValue } : j));
    } catch (error) {
      console.error(error);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('¿Seguro que deseas eliminar este registro?')) return;
    try {
      const { error } = await supabase.from('print_jobs').delete().eq('id', id);
      if (error) throw error;
      setJobs(jobs.filter(j => j.id !== id));
    } catch (error) {
      console.error(error);
    }
  };

  const setField = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  // KPIs
  const pendingSavings = jobs.filter(j => !j.savings_transferred).reduce((acc, j) => acc + Number(j.savings_amount), 0);
  const pendingEmergency = jobs.filter(j => !j.emergency_transferred).reduce((acc, j) => acc + Number(j.emergency_amount), 0);
  const totalFilament = jobs.reduce((acc, j) => acc + Number(j.filament_used), 0);

  return (
    <div className="admin-page">
      <div className="adm-page-header sticky-header">
        <div className="adm-page-title">
          <h1>🖨️ Producción (Registro de Impresiones)</h1>
        </div>
      </div>

      <div className="leads-stats-row" style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1rem', marginTop: '1rem', marginBottom: '2rem' }}>
        <div className="form-section-card" style={{ background: '#f0fdf4', borderColor: '#bbf7d0', padding: '1.25rem' }}>
          <h4 style={{ margin: 0, color: '#166534', fontSize: '0.85rem', textTransform: 'uppercase' }}>Ahorro (Savings) Pendiente</h4>
          <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#15803d', marginTop: '0.5rem' }}>${pendingSavings.toLocaleString()}</div>
        </div>
        <div className="form-section-card" style={{ background: '#fef2f2', borderColor: '#fecaca', padding: '1.25rem' }}>
          <h4 style={{ margin: 0, color: '#991b1b', fontSize: '0.85rem', textTransform: 'uppercase' }}>Emergencia Pendiente</h4>
          <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#b91c1c', marginTop: '0.5rem' }}>${pendingEmergency.toLocaleString()}</div>
        </div>
        <div className="form-section-card" style={{ background: '#eff6ff', borderColor: '#bfdbfe', padding: '1.25rem' }}>
          <h4 style={{ margin: 0, color: '#1e40af', fontSize: '0.85rem', textTransform: 'uppercase' }}>Filamento Total Usado</h4>
          <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#1d4ed8', marginTop: '0.5rem' }}>{totalFilament}g</div>
        </div>
      </div>

      <div className="form-sections-grid" style={{ marginBottom: '2rem' }}>
        <div className="form-section-card full-width">
          <h3 className="section-title">Añadir Nueva Impresión</h3>
          
          <form onSubmit={handleAdd}>
            <div className="form-row" style={{ marginBottom: '1rem' }}>
              <div className="form-group">
                <label>Nombre del Trabajo / Pieza</label>
                <input
                  type="text"
                  required
                  placeholder="Ej: Lote 10 Mates Imperiales"
                  value={formData.job_name}
                  onChange={e => setField('job_name', e.target.value)}
                />
              </div>
            </div>

            <div className="form-row" style={{ marginBottom: '1rem' }}>
              <div className="form-group">
                <label>Filamento Usado (g)</label>
                <input
                  type="number"
                  placeholder="Ej: 350"
                  value={formData.filament_used}
                  onChange={e => setField('filament_used', e.target.value)}
                />
              </div>
              <div className="form-group">
                <label>Energía (Horas o kWh)</label>
                <input
                  type="number"
                  step="0.1"
                  placeholder="Ej: 12.5"
                  value={formData.energy_used}
                  onChange={e => setField('energy_used', e.target.value)}
                />
              </div>
            </div>

            <div className="form-row" style={{ marginBottom: '1rem' }}>
              <div className="form-group">
                <label>Fondo de Reemplazo (Savings) $</label>
                <input
                  type="number"
                  required
                  placeholder="Ej: 5000"
                  value={formData.savings_amount}
                  onChange={e => setField('savings_amount', e.target.value)}
                />
              </div>
              <div className="form-group">
                <label>Fondo de Emergencia $</label>
                <input
                  type="number"
                  required
                  placeholder="Ej: 2000"
                  value={formData.emergency_amount}
                  onChange={e => setField('emergency_amount', e.target.value)}
                />
              </div>
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '1.5rem' }}>
              <button type="submit" className="btn-primary" disabled={adding || !formData.job_name}>
                <Plus size={18} /> {adding ? 'Guardando...' : 'Registrar Impresión'}
              </button>
            </div>
          </form>
        </div>
      </div>

      <div className="table-container">
        {loading ? (
          <p style={{ padding: '2rem', textAlign: 'center' }}>Cargando...</p>
        ) : jobs.length === 0 ? (
          <div className="crm-empty-state">
            <InboxIcon size={48} strokeWidth={1} />
            <p><strong>No hay impresiones registradas.</strong></p>
            <p style={{ fontSize: '0.85rem', color: 'var(--text-light)' }}>
              Las impresiones también se crean automáticamente cuando un pedido pasa a "Aceptado".
            </p>
          </div>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Fecha</th>
                <th>Trabajo</th>
                <th>Origen</th>
                <th>Filamento</th>
                <th>Energía</th>
                <th>Savings ($)</th>
                <th>Emergencia ($)</th>
                <th>Transferencias</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {jobs.map(job => (
                <tr key={job.id}>
                  <td>{new Date(job.created_at).toLocaleDateString()}</td>
                  <td style={{ fontWeight: 600 }}>{job.job_name}</td>
                  <td>
                    {job.lead_id ? (
                      <span
                        className="crm-lead-badge"
                        onClick={() => navigate('/admin/leads-crm')}
                        title="Creado desde un pedido personalizado"
                      >
                        📋 Pedido
                      </span>
                    ) : (
                      <span className="badge-outline">Manual</span>
                    )}
                  </td>
                  <td>{job.filament_used}g</td>
                  <td>{job.energy_used}</td>
                  <td>${job.savings_amount?.toLocaleString()}</td>
                  <td>${job.emergency_amount?.toLocaleString()}</td>
                  <td>
                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                      <button 
                        onClick={() => toggleStatus(job.id, 'savings_transferred', job.savings_transferred)}
                        className={`btn-icon ${job.savings_transferred ? '' : 'text-danger'}`}
                        title="Marcar Savings"
                        style={{ borderColor: job.savings_transferred ? '#16a34a' : '', color: job.savings_transferred ? '#16a34a' : '' }}
                      >
                        {job.savings_transferred ? <CheckCircle size={16} /> : <Circle size={16} />}
                        <span style={{ marginLeft: 4 }}>Sav</span>
                      </button>
                      <button 
                        onClick={() => toggleStatus(job.id, 'emergency_transferred', job.emergency_transferred)}
                        className={`btn-icon ${job.emergency_transferred ? '' : 'text-danger'}`}
                        title="Marcar Emergencia"
                        style={{ borderColor: job.emergency_transferred ? '#ea580c' : '', color: job.emergency_transferred ? '#ea580c' : '' }}
                      >
                        {job.emergency_transferred ? <CheckCircle size={16} /> : <AlertTriangle size={16} />}
                        <span style={{ marginLeft: 4 }}>Emg</span>
                      </button>
                    </div>
                  </td>
                  <td style={{ textAlign: 'right' }}>
                    <button onClick={() => handleDelete(job.id)} className="btn-icon text-danger" style={{ padding: '6px' }}>
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

export default PrintJobsManager;
