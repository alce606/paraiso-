import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const Header = () => {
  const navigate = useNavigate();
  const [userType, setUserType] = useState(null);
  const [userName, setUserName] = useState('');
  const [adminName, setAdminName] = useState('');
  const [config, setConfig] = useState({
    nomesite: 'Coração Generoso',
    registroUsuarios: true
  });

  const handleLogout = () => {
    UsuarioService.logout();
    navigate('/');
  };

  useEffect(() => {
    const checkUserType = () => {
      const type = localStorage.getItem('userType');
      setUserType(type);
      
      // Pega o nome do usuário do localStorage
      const userJson = localStorage.getItem('user');
      if (userJson) {
        const user = JSON.parse(userJson);
        setUserName(user.nome || '');
      } else {
        setUserName('');
      }
      
      // Pega o nome do admin do localStorage
      const adminJson = localStorage.getItem('adminUser');
      if (adminJson) {
        const admin = JSON.parse(adminJson);
        setAdminName(admin.nome || '');
      } else {
        setAdminName('');
      }
    };
    
    const loadConfig = () => {
      const savedConfig = localStorage.getItem('siteConfig');
      if (savedConfig) {
        const parsedConfig = JSON.parse(savedConfig);
        setConfig(prev => ({ ...prev, ...parsedConfig }));
      }
    };
    
    checkUserType();
    loadConfig();
    
    // Escuta mudanças no localStorage
    const handleStorageChange = () => {
      checkUserType();
    };
    
    window.addEventListener('storage', handleStorageChange);
    
    // Escuta mudanças customizadas (para mesma aba)
    window.addEventListener('userTypeChanged', handleStorageChange);
    window.addEventListener('configChanged', loadConfig);
    
    return () => {
      window.removeEventListener('storage', handleStorageChange);
      window.removeEventListener('userTypeChanged', handleStorageChange);
      window.removeEventListener('configChanged', loadConfig);
    };
  }, []);

  return (
    <header style={{
      background: 'white',
      padding: '15px 0',
      boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
      marginBottom: '20px'
    }}>
      <div className="container">
        <nav style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}>
          <Link to="/" style={{
            display: 'flex',
            alignItems: 'center',
            textDecoration: 'none',
            color: '#333'
          }}>
            <span className="heart-logo">❤️</span>
            <h1 style={{ color: config.corPrimaria || '#dc143c', fontSize: '1.8rem' }}>{config.nomesite}</h1>
          </Link>
          
          <div style={{ display: 'flex', gap: '20px', alignItems: 'center' }}>
            <Link to="/sobre" style={{ textDecoration: 'none', color: '#333', fontWeight: 'bold' }}>
              Sobre Nós
            </Link>
            <Link to="/eventos" style={{ textDecoration: 'none', color: '#333', fontWeight: 'bold' }}>
              Eventos
            </Link>
            <Link to="/suporte" style={{ textDecoration: 'none', color: '#333', fontWeight: 'bold' }}>
              Suporte
            </Link>
            {userType === 'user' ? (
              <div style={{ display: 'flex', gap: '10px', alignItems: 'center' }}>
                <Link to="/perfil" className="btn btn-secondary">
                  👤 {userName || 'Meu Perfil'}
                </Link>
                <button 
                  onClick={handleLogout}
                  className="btn btn-primary"
                >
                  Sair
                </button>
              </div>
            ) : userType === 'admin' ? (
              <div style={{ display: 'flex', gap: '10px', alignItems: 'center' }}>
                <Link to="/admin/perfil" className="btn btn-secondary">
                  👑 {adminName || 'Perfil Admin'}
                </Link>
                <Link to="/admin" className="btn btn-secondary">
                  ⚙️ Gerenciar
                </Link>
                <button 
                  onClick={handleLogout}
                  className="btn btn-primary"
                >
                  Sair
                </button>
              </div>
            ) : (
              <>
                <Link to="/login-admin" className="btn btn-secondary" style={{ marginRight: '10px' }}>
                  Admin
                </Link>
                <Link to="/login" className="btn btn-secondary" style={{ marginRight: '10px' }}>
                  Login
                </Link>
                {config.registroUsuarios && (
                  <Link to="/cadastro" className="btn btn-primary">
                    Cadastro
                  </Link>
                )}
              </>
            )}
          </div>
        </nav>
      </div>
    </header>
  );
};

export default Header;