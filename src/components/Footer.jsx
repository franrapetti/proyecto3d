import React from 'react';
import { Send, MapPin, Package, Heart } from 'lucide-react';
import InstagramIcon from './InstagramIcon';
import './Footer.css';

const Footer = () => {
  const currentYear = new Date().getFullYear();
  
  return (
    <footer className="footer">
      <div className="footer-grid">
        {/* Brand Section */}
        <div className="footer-brand">
          <img src="/logo.png" alt="Punto Base" className="footer-logo-img" />
          <p className="footer-tagline">
            Todo lo que necesitas, en un solo lugar. Hogar, autopartes, mate, perfumeria y mas.
          </p>
          <div className="social-links">
            <a href="https://www.instagram.com/puntobase.disenos/" target="_blank" rel="noopener noreferrer" className="social-icon-btn" title="Instagram">
              <InstagramIcon size={20} />
              <span>@puntobase.disenos</span>
            </a>
            <a href={`https://wa.me/${import.meta.env.VITE_WHATSAPP_NUMBER || '543572595756'}`} target="_blank" rel="noopener noreferrer" className="social-icon-btn" title="WhatsApp">
              <Send size={20} />
              <span>WhatsApp</span>
            </a>
          </div>
        </div>

        {/* Quick Links */}
        <div className="footer-links-group">
          <h4>Navegación</h4>
          <a href="/#catalog-section" className="footer-link">Catálogo</a>
          <a href="/favoritos" className="footer-link">Mis Favoritos</a>
          <a href="/empresas" className="footer-link">Ventas Corporativas</a>
          <a href="/devoluciones" className="footer-link">Devoluciones y Garantía</a>
        </div>

        {/* Contact/Info */}
        <div className="footer-links-group">
          <h4>Punto Base</h4>
          <div className="footer-link">
            <MapPin size={16} /> Buenos Aires, Argentina
          </div>
          <div className="footer-link">
            <Package size={16} /> Envíos a todo el país
          </div>
          <div className="footer-link">
            <Heart size={16} /> 100% Calidad Asegurada
          </div>
        </div>
      </div>

      <div className="footer-bottom">
        <p className="footer-copy">
          © {currentYear} Punto Base. Todos los derechos reservados.
        </p>
        <p className="dev-by" style={{ display: 'flex', alignItems: 'center', gap: '0.25rem', justifyContent: 'center' }}>
          Hecho con <Heart size={14} /> por{' '}
          <a 
            href={`https://wa.me/543572595756?text=${encodeURIComponent("Hola Francisco, me gustó mucho la web de Punto Base!")}`} 
            target="_blank" 
            rel="noopener noreferrer"
            className="dev-link"
          >
            Francisco Rapetti
          </a>
        </p>
      </div>
    </footer>
  );
};

export default Footer;
