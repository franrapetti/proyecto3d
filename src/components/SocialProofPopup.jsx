import React, { useState, useEffect } from 'react';
import { Package, X } from 'lucide-react';
import './SocialProofPopup.css';

const NOTIFICATIONS = [
  { name: 'Matías', location: 'Córdoba', action: 'compró', product: 'Mate Imperial' },
  { name: 'Lucía', location: 'Mendoza', action: 'compró', product: 'Caja de Munición 9mm' },
  { name: 'Juan', location: 'CABA', action: 'compró', product: 'Repuesto Tapa' },
  { name: 'Camila', location: 'Rosario', action: 'compró', product: 'Perfume Esencia' },
  { name: 'Tomás', location: 'Mar del Plata', action: 'compró', product: 'Llavero Personalizado' },
  { name: 'Sofía', location: 'Neuquén', action: 'compró', product: 'Soporte Celular Auto' },
  { name: 'Gastón', location: 'Tucumán', action: 'compró', product: 'Mate Torpedo' },
];

const SocialProofPopup = () => {
  const [currentNotif, setCurrentNotif] = useState(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    // Start after 5 seconds
    const initialTimer = setTimeout(() => {
      showNextNotification();
    }, 5000);

    return () => clearTimeout(initialTimer);
  }, []);

  const showNextNotification = () => {
    // Pick random notification
    const random = NOTIFICATIONS[Math.floor(Math.random() * NOTIFICATIONS.length)];
    const timeAgo = Math.floor(Math.random() * 59) + 1; // 1 to 59 minutes
    
    setCurrentNotif({ ...random, timeAgo });
    setIsVisible(true);

    // Hide after 5 seconds
    setTimeout(() => {
      setIsVisible(false);
      
      // Schedule next notification (between 15s and 45s)
      const nextDelay = Math.floor(Math.random() * 30000) + 15000;
      setTimeout(() => {
        showNextNotification();
      }, nextDelay);
      
    }, 5000);
  };

  if (!currentNotif) return null;

  return (
    <div className={`social-proof-popup ${isVisible ? 'visible' : ''}`}>
      <div className="social-proof-icon">
        <Package size={20} color="#ffffff" />
      </div>
      <div className="social-proof-content">
        <p className="social-proof-text">
          <strong>{currentNotif.name}</strong> de <strong>{currentNotif.location}</strong>
          <br/>
          {currentNotif.action} <span>{currentNotif.product}</span>
        </p>
        <span className="social-proof-time">Hace {currentNotif.timeAgo} minuto{currentNotif.timeAgo > 1 ? 's' : ''}</span>
      </div>
      <button className="social-proof-close" onClick={() => setIsVisible(false)}>
        <X size={14} />
      </button>
    </div>
  );
};

export default SocialProofPopup;
