import React from 'react';
import { Home, Car, Box, Coffee, Sparkles, Palette } from 'lucide-react';
import './CategoryShowcase.css';

const categories = [
  {
    name: 'Hogar',
    icon: Home,
    description: 'Deco, organizadores y mas',
    image: '/categories/cat_hogar_1786400195235.jpg'
  },
  {
    name: 'Autopartes',
    icon: Car,
    description: 'Repuestos y accesorios',
    image: '/categories/cat_autopartes_1786400208468.jpg'
  },
  {
    name: 'Cajas de Municion',
    icon: Box,
    description: 'Almacenamiento seguro',
    image: '/categories/cat_municion_1786400221107.jpg'
  },
  {
    name: 'Mate',
    icon: Coffee,
    description: 'Mates, bombillas y termos',
    image: '/categories/cat_mate_1786400233503.jpg'
  },
  {
    name: 'Perfumeria',
    icon: Sparkles,
    description: 'Fragancias y cuidado personal',
    image: '/categories/cat_perfumeria_1786400253295.jpg'
  },
  {
    name: 'Personalizados',
    icon: Palette,
    description: 'Disenos a tu medida',
    image: '/categories/cat_personalizados_1786400301655.jpg'
  },
];

const CategoryShowcase = ({ onCategoryClick }) => {
  return (
    <section className="category-showcase">
      <div className="category-showcase-container">
        <h2 className="category-showcase-title">Explora nuestras categorias</h2>
        <div className="category-grid">
          {categories.map((category) => {
            const Icon = category.icon;
            return (
              <button
                key={category.name}
                className="category-card has-bg-image"
                onClick={() => onCategoryClick?.(category.name)}
                aria-label={`Explorar categoria ${category.name}`}
                style={{ backgroundImage: `url(${category.image})` }}
              >
                <div className="category-overlay"></div>
                <div className="category-content">
                  <div className="category-icon-container">
                    <Icon size={24} className="category-icon" />
                  </div>
                  <h3 className="category-name">{category.name}</h3>
                  <p className="category-description">{category.description}</p>
                </div>
              </button>
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default CategoryShowcase;
