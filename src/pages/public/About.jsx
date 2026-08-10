import React, { useEffect } from 'react';
import { MapPin, ShieldCheck } from 'lucide-react';

const About = () => {
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="page-section fade-in modern-layout" style={{ margin: '0 auto', marginTop: '2rem' }}>
      <div className="capsule-hero">
        <span className="badge-modern">Sobre nosotros</span>
        <h2 className="title-modern" style={{ fontWeight: 900 }}>Conoce a <br/><span className="text-gradient" style={{ fontWeight: 900 }}>Punto Base</span></h2>
      </div>
      <div className="capsule-grid">
        <div className="capsule green-dark" style={{ gridColumn: '1 / -1', display: 'flex', flexDirection: 'column', gap: '1.5rem', alignItems: 'center', textAlign: 'center' }}>
          <div>
            <h3 style={{ marginBottom: '0.5rem', fontWeight: 800 }}>Conoce a Punto Base</h3>
            <p style={{ fontSize: '1.1rem', lineHeight: '1.6' }}>
              Somos Punto Base, una tienda online que nace con la mision de ofrecer productos de calidad en categorias como hogar, autopartes, mate, perfumeria y mas. Desde Argentina, seleccionamos cada producto con dedicacion para que encuentres todo lo que necesitas en un solo lugar.
            </p>
          </div>
        </div>
        <div className="capsule green-light">
          <MapPin size={48} className="icon-huge" style={{ margin: '0 auto', display: 'block', marginBottom: '1rem' }} />
          <h3 style={{ textAlign: 'center' }}>Origen Argentino</h3>
          <p style={{ textAlign: 'center' }}>De Argentina para todo el pais con la mejor atencion.</p>
        </div>
        <div className="capsule green-accent">
          <ShieldCheck size={48} className="icon-huge" style={{ margin: '0 auto', display: 'block', marginBottom: '1rem' }} />
          <h3 style={{ textAlign: 'center' }}>Calidad</h3>
          <p style={{ textAlign: 'center' }}>Seleccion rigurosa en cada producto que ofrecemos.</p>
        </div>
      </div>
    </div>
  );
};

export default About;
