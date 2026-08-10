import React from 'react';
import { Outlet } from 'react-router-dom';
import Footer from './Footer';
import SocialProofPopup from './SocialProofPopup';

const PublicLayout = () => {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
      <div className="public-content-wrap" style={{ flex: 1 }}>
        <Outlet />
      </div>
      <SocialProofPopup />
      <Footer />
    </div>
  );
};

export default PublicLayout;
