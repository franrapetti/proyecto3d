import React, { useEffect } from 'react';
import { Package, Clock } from 'lucide-react';

const Shipping = () => {
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="page-section fade-in modern-layout" style={{ margin: '0 auto', marginTop: '2rem' }}>
      <div className="capsule-hero">
        <span className="badge-modern">Logistica</span>
        <h2 className="title-modern" style={{ fontWeight: 900 }}><strong>Tus productos,</strong><br/><span className="text-gradient" style={{ fontWeight: 900 }}>a tu puerta</span></h2>
      </div>
      <div className="capsule-grid-2">
        <div className="capsule green-dark full-width">
          <h3>Envios a Todo el Pais</h3>
          <p>Tu pedido sera preparado y despachado con maxima prioridad dentro de las 24 horas habiles luego de confirmado tu pago.</p>
        </div>
        <div className="capsule border-style">
          <Package size={48} className="icon-huge" style={{ margin: '0 auto', display: 'block', marginBottom: '1rem' }} />
          <h3 style={{ textAlign: 'center' }}>Packaging Seguro</h3>
          <p style={{ textAlign: 'center' }}>Todos nuestros productos son embalados con materiales de proteccion para garantizar que lleguen en perfecto estado.</p>
        </div>
        <div className="capsule border-style">
          <Clock size={48} className="icon-huge" style={{ margin: '0 auto', display: 'block', marginBottom: '1rem' }} />
          <h3 style={{ textAlign: 'center' }}>Seguimiento en Tiempo Real</h3>
          <p style={{ textAlign: 'center' }}>Te enviamos el codigo de rastreo al instante de despachar tu pedido para que puedas seguirlo.</p>
        </div>
      </div>
    </div>
  );
};

export default Shipping;
