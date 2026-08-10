import React, { useState, useEffect, useRef } from 'react';
import { supabase } from '../../lib/supabaseClient';
import { useQuery } from '@tanstack/react-query';
import Header from '../../components/Header';
import ProductCard from '../../components/ProductCard';
import ProductCardSkeleton from '../../components/ProductSkeleton';
import CountdownTimer from '../../components/CountdownTimer';
import { useLaunchTimer } from '../../hooks/useLaunchTimer';
import { useCart } from '../../context/CartContext';
import { Helmet } from 'react-helmet-async';
import { useLocation } from 'react-router-dom';
import { getImgUrl } from '../../lib/imageUtils';
import { trackPixelEvent, logAnalyticsEvent } from '../../lib/analytics';
import { ShieldCheck, Star, Truck, CreditCard, BadgeCheck } from 'lucide-react';
import { FRIENDS_WEEK_ACTIVE } from '../../data/friendsWeekData';
import FriendsWeekPromoSection from '../../components/FriendsWeekPromoSection';
import CategoryShowcase from '../../components/CategoryShowcase';

function PublicCatalog() {
  const { cartCount, setIsCartOpen, addToCart } = useCart();
  
  const location = useLocation();
  
  const [currentCategory, setCurrentCategory] = useState(location.state?.category || 'All');
  const [mateSubCategory, setMateSubCategory] = useState(location.state?.subCategory || 'All');
  
  // Search & Filters
  const [searchTerm, setSearchTerm] = useState('');
  const [sortOrder, setSortOrder] = useState('newest'); // newest, price_asc, price_desc
  const { isLaunched } = useLaunchTimer();
  const searchDebounceRef = useRef(null);
  
  // Track catalog view on mount
  useEffect(() => {
    logAnalyticsEvent('view_catalog');
  }, []);
  
  // Theme Management now handled by ThemeContext

  useEffect(() => {
    if (location.state?.category) {
      setCurrentCategory(location.state.category);
    }
    if (location.state?.subCategory) {
      setMateSubCategory(location.state.subCategory);
    }
  }, [location.state]);



  // ...

  const { data: products = [], isLoading: loading } = useQuery({
    queryKey: ['products'],
    queryFn: async () => {
      const { data, error } = await supabase.from('products').select('*').order('created_at', { ascending: false });
      if (error) throw error;
      return data || [];
    }
  });
  
  let visibleProducts = [...products];
  
  if (currentCategory !== 'All') {
    visibleProducts = visibleProducts.filter(p => p.category === currentCategory);
    if (mateSubCategory !== 'All') {
      visibleProducts = visibleProducts.filter(p => p.sub_category === mateSubCategory);
    }
  }

  if (searchTerm) {
    visibleProducts = visibleProducts.filter(p => p.name.toLowerCase().includes(searchTerm.toLowerCase()));
  }

  if (sortOrder === 'price_asc') {
    visibleProducts.sort((a, b) => a.price - b.price);
  } else if (sortOrder === 'price_desc') {
    visibleProducts.sort((a, b) => b.price - a.price);
  } else {
    // Advanced Default Sorting Logic
    // 1. Separate priority items
    let priorities = [];
    let others = [];
    
    visibleProducts.forEach(p => {
      if (p.is_priority) {
        priorities.push(p);
      } else {
        others.push(p);
      }
    });

    // Shuffle priorities to keep top section fresh
    priorities.sort(() => 0.5 - Math.random());
    
    // Sort others by sold_count (desc), fallback to newest
    others.sort((a, b) => {
      const countA = a.sold_count || 0;
      const countB = b.sold_count || 0;
      if (countA !== countB) return countB - countA;
      return new Date(b.created_at) - new Date(a.created_at);
    });
    
    visibleProducts = [...priorities, ...others];
  }

  // Push out-of-stock products to the end (all sort modes)
  const inStock = visibleProducts.filter(p => p.stock !== 0);
  const outOfStock = visibleProducts.filter(p => p.stock === 0);
  visibleProducts = [...inStock, ...outOfStock];

  const crossSells = products.filter(p => p.category === 'Filamentos' || p.category === 'Accesorios').slice(0, 2);

  const scrollToCatalog = () => {
    document.getElementById('catalog-section')?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <>
      <Helmet>
        <title>Punto Base | Todo lo que necesitas en un solo lugar</title>
        <meta name="description" content="Tienda online con envios a todo el pais. Hogar, autopartes, mate, perfumeria y productos personalizados. Los mejores precios." />
        
        {/* Open Graph / Facebook */}
        <meta property="og:type" content="website" />
        <meta property="og:url" content={window.location.href} />
        <meta property="og:title" content="Punto Base | Todo lo que necesitas en un solo lugar" />
        <meta property="og:description" content="Tienda online con envios a todo el pais. Hogar, autopartes, mate, perfumeria y productos personalizados. Los mejores precios." />
        <meta property="og:image" content="/hero-bg.png" />
        <meta property="og:site_name" content="Punto Base" />

        {/* Twitter */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content="Punto Base | Todo lo que necesitas en un solo lugar" />
        <meta name="twitter:description" content="Tienda online con envios a todo el pais. Hogar, autopartes, mate, perfumeria y productos personalizados. Los mejores precios." />
        <meta name="twitter:image" content="/hero-bg.png" />
      </Helmet>
      <Header 
        cartCount={cartCount} 
        onCartClick={() => setIsCartOpen(true)} 
        onNavClick={(cat, subCat = 'All') => {
          setCurrentCategory(cat);
          setMateSubCategory(subCat);
          setSearchTerm(''); // clear search on nav
        }}
        currentCategory={currentCategory}
      />

      {/* Full-bleed Hero — only on main catalog view */}
      {currentCategory === 'All' && !searchTerm && isLaunched && (
        <>
          <section
            className="hero-fullbleed"
            style={{
              position: 'relative',
              overflow: 'hidden',
              opacity: 1,
              transition: 'opacity 0.4s ease',
            }}
          >
            {/* Responsive background via <picture> */}
            <picture style={{ position: 'absolute', inset: 0, zIndex: 0 }}>
              <img
                src="/hero-bg.png"
                alt="Todo lo que necesitas, en un solo lugar"
                aria-hidden="true"
                fetchPriority="high"
                style={{
                  width: '100%',
                  height: '100%',
                  objectFit: 'cover',
                  objectPosition: 'center',
                  display: 'block',
                }}
              />
            </picture>
            <div className="hero-fullbleed-overlay" />
            <div className="hero-fullbleed-content" style={{ position: 'relative', zIndex: 1 }}>
              <span className="hero-badge" style={{ display: 'inline-flex', alignItems: 'center', gap: '0.4rem' }}>
                <Truck size={14} /> Envios rapidos a todo el pais
              </span>
              <h1 className="hero-fullbleed-title">Todo lo que necesitas,<br/>en un <span className="handwriting-accent">solo lugar.</span></h1>
              <p className="hero-fullbleed-subtitle">Hogar, autopartes, mate, perfumeria y mas. La mejor calidad, los mejores precios, con envios a todo el pais.</p>
              <div className="hero-buttons-container" style={{ display: 'flex', gap: '0.75rem', flexWrap: 'nowrap', marginTop: '1.5rem', width: '100%', justifyContent: 'center' }}>
                <button className="hero-fullbleed-cta" onClick={scrollToCatalog} style={{ padding: '0.9rem 2rem', whiteSpace: 'nowrap', textAlign: 'center', fontWeight: 900 }}>
                  Explorar productos
                </button>
              </div>
            </div>
          </section>


          {/* Trust Metrics Bar */}
          <div className="trust-bar fade-in">
            <div className="trust-bar-container">
              <div className="trust-bar-item">
                <div className="trust-icon-wrapper">
                  <BadgeCheck size={20} color="#2ea337" />
                </div>
                <div className="trust-text-wrapper">
                  <div className="trust-title">
                    +{870 + products.reduce((acc, p) => acc + (p.sold_count || 0), 0)} ventas
                    <span className="verified-badge">Verificado</span>
                  </div>
                  <span className="trust-subtitle">en todo el pais</span>
                </div>
              </div>
              
              <div className="trust-bar-item">
                <div className="trust-icon-wrapper">
                  <Star size={20} fill="#e5b62b" color="#e5b62b" />
                </div>
                <div className="trust-text-wrapper">
                  <div className="trust-title">4.9/5 Estrellas</div>
                  <span className="trust-subtitle">de satisfaccion</span>
                </div>
              </div>
              
              <div className="trust-bar-item">
                <div className="trust-icon-wrapper">
                  <Truck size={20} color="#2663eb" />
                </div>
                <div className="trust-text-wrapper">
                  <div className="trust-title">Envios rapidos</div>
                  <span className="trust-subtitle">por Andreani</span>
                </div>
              </div>
              
              <div className="trust-bar-item">
                <div className="trust-icon-wrapper">
                  <CreditCard size={20} color="#454545" />
                </div>
                <div className="trust-text-wrapper">
                  <div className="trust-title">Pagos seguros</div>
                  <span className="trust-subtitle">por Mercado Pago</span>
                </div>
              </div>
            </div>
          </div>

          {/* Semana del Amigo — Temporal promo section */}
          {FRIENDS_WEEK_ACTIVE && (
            <FriendsWeekPromoSection
              products={products}
              onAddToCart={addToCart}
            />
          )}

          {/* Categories Preview Grid */}
          <CategoryShowcase onCategoryClick={(cat) => {
            setCurrentCategory(cat);
            setTimeout(() => document.getElementById('catalog-section')?.scrollIntoView({ behavior: 'smooth' }), 100);
          }} />
        </>
      )}

      {currentCategory === 'All' && !searchTerm && !isLaunched && (
        <main className="container main-content">
          <CountdownTimer />
        </main>
      )}

      <main className="container main-content" id="catalog-section">
        <div className="fade-in catalog-main-content">
            <div className="catalog-header">
              <div className="catalog-title-bar">
                <h2>
                  {currentCategory === 'All' 
                    ? (isLaunched ? 'Catálogo' : 'Elegí tus favoritos') 
                    : mateSubCategory !== 'All' 
                      ? `${mateSubCategory}` 
                      : currentCategory}
                </h2>
                
                <div className="catalog-controls">
                  <input 
                    type="search" 
                    placeholder="Buscar producto..." 
                    className="search-input"
                    value={searchTerm}
                    onChange={(e) => {
                      const val = e.target.value;
                      setSearchTerm(val);

                      // Meta Pixel: Search event (debounced 800ms)
                      if (searchDebounceRef.current) clearTimeout(searchDebounceRef.current);
                      if (val.trim().length >= 2) {
                        searchDebounceRef.current = setTimeout(() => {
                          trackPixelEvent('Search', {
                            search_string: val.trim(),
                            content_category: currentCategory !== 'All' ? currentCategory : undefined,
                          });
                          logAnalyticsEvent('search', { query: val.trim() });
                        }, 800);
                      }
                    }}
                  />
                  <select 
                    className="sort-select" 
                    value={sortOrder} 
                    onChange={(e) => setSortOrder(e.target.value)}
                  >
                    <option value="newest">Más nuevos</option>
                    <option value="price_asc">Menor precio</option>
                    <option value="price_desc">Mayor precio</option>
                  </select>
                </div>
              </div>
            </div>

            {loading ? (
              <div className="product-grid fade-in">
                {Array.from({ length: 8 }).map((_, i) => (
                  <ProductCardSkeleton key={i} />
                ))}
              </div>
            ) : visibleProducts.length === 0 ? (
              <p>No hay productos que coincidan con la búsqueda.</p>
            ) : (
              <div className="product-grid">
                {visibleProducts.map(product => (
                  <ProductCard 
                    key={product.id} 
                    product={product} 
                    onAddToCart={addToCart} 
                    noZoom={product.no_zoom}
                  />
                ))}
              </div>
            )}
          </div>
      </main>
    </>
  );
}

export default PublicCatalog;
