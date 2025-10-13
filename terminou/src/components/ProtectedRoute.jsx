import React from 'react';
import { Navigate } from 'react-router-dom';

const ProtectedRoute = ({ children, adminOnly = false }) => {
  const userType = localStorage.getItem('userType');
  
  if (!userType) {
    return <Navigate to="/login" replace />;
  }
  
  if (adminOnly && userType !== 'admin') {
    return (
      <div className="container">
        <div className="card" style={{ textAlign: 'center', padding: '50px' }}>
          <span style={{ fontSize: '3rem', display: 'block', marginBottom: '20px' }}>🚫</span>
          <h2 style={{ color: '#dc143c', marginBottom: '15px' }}>Acesso Restrito</h2>
          <p style={{ color: '#666', marginBottom: '20px' }}>
            Esta área é exclusiva para administradores.
          </p>
          <a href="/login-admin" className="btn btn-primary">
            Fazer Login como Admin
          </a>
        </div>
      </div>
    );
  }
  
  return children;
};

export default ProtectedRoute;