import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { Moon, Sun, Heart, ShoppingBag, Menu, X } from 'lucide-react';
import { useTheme } from '../context/ThemeContext';
import { useLaunchTimer } from '../hooks/useLaunchTimer';
import InstagramIcon from './InstagramIcon';
import './Header.css';

const categoryTree = [
  { name: 'Todos los Productos', value: 'All' },
  { name: 'Figuras', value: 'Figuras', subs: ['Torpedo', 'Imperial', 'Varios'] },
  { name: 'Filamentos', value: 'Filamentos' },
  { name: 'Accesorios', value: 'Accesorios', subs: ['Accesorios Acero', 'Accesorios Alpaca', 'Bombillones de Alpaca', 'Bombillones de Acero'] },
  { name: 'Repuestos', value: 'Repuestos' },
  { name: 'Accesorios', value: 'Accesorios' },
  { name: 'Impresoras', value: 'Impresoras', subs: ['Termolar', 'Media Manija Cebador', 'Stanley Figura Sistem', 'Houdson'] }
];

const Header = ({ cartCount, onCartClick, onNavClick, currentCategory }) => {
  const { isDark, toggleTheme } = useTheme();
  const { isLaunched } = useLaunchTimer();
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const isProductActive = ['All', 'Figuras', 'Filamentos', 'Accesorios', 'Repuestos', 'Accesorios', 'Impresoras'].includes(currentCategory);

  const handleNavClick = (cat, subCat) => {
    onNavClick(cat, subCat);
    setIsMenuOpen(false);
  };

  return (
    <header className="header sticky">
      <div className="container header-content">
        {isLaunched && (
          <button className="mobile-menu-btn" onClick={() => setIsMenuOpen(!isMenuOpen)}>
            {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        )}
        <Link to="/" className="header-logo" onClick={() => onNavClick('All')}>
          <img src={isDark ? "/logo-noche.png" : "/logo.png"} alt="Proyecto 3D" className="logo-img" />
        </Link>

        {isLaunched && (
          <>
            <nav className={`desktop-nav ${isMenuOpen ? 'mobile-open' : ''}`}>
              <ul className="nav-links">
                <li className="dropdown-parent">
                  <button 
                    className={isProductActive ? 'active' : ''} 
                    onClick={() => handleNavClick('All', 'All')}
                  >
                    Productos ▾
                  </button>
                  <div className="dropdown-menu fade-in">
                    {categoryTree.map(cat => (
                      <div key={cat.value} className="dropdown-group">
                        <button 
                          onClick={() => handleNavClick(cat.value, 'All')} 
                          className="dropdown-main-btn"
                        >
                          {cat.name}
                        </button>
                        {cat.subs && (
                          <div className="dropdown-sub-links">
                            {cat.subs.map(sub => (
                               <button 
                                 key={sub} 
                                 onClick={(e) => {
                                   e.stopPropagation();
                                   handleNavClick(cat.value, sub);
                                 }} 
                                 className="dropdown-sub-btn"
                               >
                                 {sub}
                               </button>
                            ))}
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                </li>
                <li><Link to="/nosotros" onClick={() => setIsMenuOpen(false)} className={`header-nav-link ${currentCategory === 'Nosotros' ? 'active' : ''}`}>Quiénes somos</Link></li>
                <li><Link to="/envios" onClick={() => setIsMenuOpen(false)} className={`header-nav-link ${currentCategory === 'Envios' ? 'active' : ''}`}>Envíos</Link></li>
                <li><Link to="/empresas" onClick={() => setIsMenuOpen(false)} className={`header-nav-link ${currentCategory === 'Empresas' ? 'active' : ''}`}>Empresas 🏢</Link></li>
              </ul>
            </nav>
            <div className="header-actions">
              <button className="theme-toggle" onClick={toggleTheme} title="Cambiar Tema" style={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
                {isDark ? <Sun size={20} strokeWidth={1.5} /> : <Moon size={20} strokeWidth={1.5} />}
              </button>
              <Link to="/favoritos" className="wishlist-header-btn" title="Mis Favoritos" style={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
                <Heart size={20} strokeWidth={1.5} />
              </Link>
              <a 
                href="https://www.instagram.com/proyecto3d" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="wishlist-header-btn" 
                title="Instagram"
                style={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}
              >
                <InstagramIcon size={20} strokeWidth={1.5} />
              </a>
              <button className="cart-btn" onClick={onCartClick} style={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
                <ShoppingBag size={20} strokeWidth={1.5} />
                {cartCount > 0 && <span className="cart-badge">{cartCount}</span>}
              </button>
            </div>
          </>
        )}
      </div>
    </header>
  );
};

export default Header;
