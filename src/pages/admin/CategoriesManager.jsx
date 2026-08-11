import React, { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabaseClient';
import { Trash2, Plus, AlertCircle } from 'lucide-react';
import './AdminProducts.css'; // Reusing admin form styles

const CategoriesManager = () => {
  const [categories, setCategories] = useState([]);
  const [newCategoryName, setNewCategoryName] = useState('');
  const [loading, setLoading] = useState(true);
  const [adding, setAdding] = useState(false);

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    try {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('name');
      
      if (error) {
        // If table doesn't exist, this will error
        if (error.code === '42P01') {
          console.error('La tabla categories no existe. Por favor crea la tabla en Supabase.');
        }
        throw error;
      }
      setCategories(data || []);
    } catch (error) {
      console.error('Error fetching categories:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleAddCategory = async (e) => {
    e.preventDefault();
    if (!newCategoryName.trim()) return;

    setAdding(true);
    try {
      const { data, error } = await supabase
        .from('categories')
        .insert([{ name: newCategoryName.trim() }])
        .select();

      if (error) throw error;
      
      setCategories([...categories, data[0]].sort((a, b) => a.name.localeCompare(b.name)));
      setNewCategoryName('');
    } catch (error) {
      alert('Error al agregar categoría (puede que ya exista).');
      console.error(error);
    } finally {
      setAdding(false);
    }
  };

  const handleDeleteCategory = async (id, name) => {
    if (!window.confirm(`¿Seguro que deseas eliminar la categoría "${name}"?\n(Asegúrate de que no haya productos usándola, de lo contrario quedarán sin categoría)`)) {
      return;
    }

    try {
      const { error } = await supabase
        .from('categories')
        .delete()
        .eq('id', id);

      if (error) throw error;
      
      setCategories(categories.filter(cat => cat.id !== id));
    } catch (error) {
      alert('Error al eliminar categoría.');
      console.error(error);
    }
  };

  return (
    <div className="admin-page">
      <header className="adm-page-header sticky-header">
        <div className="adm-page-title">
          <h1>Gestión de Categorías</h1>
        </div>
      </header>

      <div className="form-sections-grid" style={{ maxWidth: '600px', margin: '2rem auto' }}>
        <div className="form-section-card">
          <h3 className="section-title">Añadir Nueva Categoría</h3>
          <form onSubmit={handleAddCategory} className="form-row" style={{ alignItems: 'flex-end', marginBottom: '2rem' }}>
            <div className="form-group" style={{ flex: 1, marginBottom: 0 }}>
              <label>Nombre de Categoría</label>
              <input
                type="text"
                value={newCategoryName}
                onChange={(e) => setNewCategoryName(e.target.value)}
                placeholder="Ej: Accesorios Mates"
                required
              />
            </div>
            <button type="submit" className="btn-primary" disabled={adding || !newCategoryName.trim()} style={{ height: '42px' }}>
              <Plus size={18} /> {adding ? 'Añadiendo...' : 'Añadir'}
            </button>
          </form>

          <h3 className="section-title">Categorías Actuales</h3>
          {loading ? (
            <p>Cargando categorías...</p>
          ) : categories.length === 0 ? (
            <div style={{ padding: '2rem', textAlign: 'center', background: 'var(--background)', borderRadius: '8px', border: '1px solid var(--border)' }}>
              <AlertCircle size={24} color="var(--text-light)" style={{ margin: '0 auto 0.5rem' }} />
              <p style={{ margin: 0, color: 'var(--text-light)' }}>No hay categorías. <br/>¿Corriste el código SQL en Supabase?</p>
            </div>
          ) : (
            <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
              {categories.map((cat) => (
                <li key={cat.id} style={{ 
                  display: 'flex', 
                  justifyContent: 'space-between', 
                  alignItems: 'center', 
                  padding: '1rem', 
                  borderBottom: '1px solid var(--border)',
                  background: 'var(--background)'
                }}>
                  <span style={{ fontWeight: 500 }}>{cat.name}</span>
                  <button 
                    onClick={() => handleDeleteCategory(cat.id, cat.name)}
                    className="btn-danger"
                    style={{ background: 'transparent', color: '#ef4444', border: 'none', padding: '4px', cursor: 'pointer' }}
                    title="Eliminar categoría"
                  >
                    <Trash2 size={18} />
                  </button>
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </div>
  );
};

export default CategoriesManager;
