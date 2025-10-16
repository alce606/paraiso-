import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const PerfilAdmin = () => {
  const navigate = useNavigate();
  const [adminData, setAdminData] = useState({
    nome: 'Administrador',
    email: 'admin@coracaogeneroso.com',
    cargo: 'Administrador Geral',
    ultimoLogin: new Date().toLocaleDateString('pt-BR'),
    foto: null
  });

  useEffect(() => {
    carregarPerfil();
  }, []);

  const carregarPerfil = async () => {
    try {
      const currentUser = UsuarioService.getCurrentUser();
      if (currentUser) {
        const response = await UsuarioService.findById(currentUser.id);
        setAdminData({
          nome: response.data.nome || 'Administrador',
          email: response.data.email || 'admin@coracaogeneroso.com',
          cargo: 'Administrador Geral',
          ultimoLogin: new Date().toLocaleDateString('pt-BR'),
          foto: response.data.foto
        });
      }
    } catch (error) {
      console.error('Erro ao carregar perfil:', error);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('userType');
    localStorage.removeItem('adminToken');
    localStorage.removeItem('user');
    window.dispatchEvent(new Event('userTypeChanged'));
    navigate('/');
  };

  return (
    <div className="container">
      <div className="card" style={{ maxWidth: '600px', margin: '0 auto' }}>
        <div style={{ textAlign: 'center', marginBottom: '30px' }}>
          {adminData.foto ? (
            <img 
              src={adminData.foto} 
              alt="Foto do Admin" 
              style={{
                width: '120px',
                height: '120px',
                borderRadius: '50%',
                objectFit: 'cover',
                border: '3px solid #dc143c'
              }}
            />
          ) : (
            <span style={{ fontSize: '4rem' }}>👑</span>
          )}
          <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Perfil do Administrador</h1>
        </div>

        <div style={{ marginBottom: '30px' }}>
          <div style={{ 
            display: 'grid', 
            gap: '20px',
            gridTemplateColumns: '1fr 1fr'
          }}>
            <div>
              <label style={{ fontWeight: 'bold', color: '#666' }}>Nome:</label>
              <p style={{ fontSize: '1.1rem', margin: '5px 0' }}>{adminData.nome}</p>
            </div>
            
            <div>
              <label style={{ fontWeight: 'bold', color: '#666' }}>Email:</label>
              <p style={{ fontSize: '1.1rem', margin: '5px 0' }}>{adminData.email}</p>
            </div>
            
            <div>
              <label style={{ fontWeight: 'bold', color: '#666' }}>Cargo:</label>
              <p style={{ fontSize: '1.1rem', margin: '5px 0' }}>{adminData.cargo}</p>
            </div>
            
            <div>
              <label style={{ fontWeight: 'bold', color: '#666' }}>Último Login:</label>
              <p style={{ fontSize: '1.1rem', margin: '5px 0' }}>{adminData.ultimoLogin}</p>
            </div>
          </div>
        </div>

        <div style={{ 
          display: 'flex', 
          gap: '15px', 
          justifyContent: 'center',
          flexWrap: 'wrap'
        }}>
          <button
            onClick={() => navigate('/admin')}
            style={{
              padding: '12px 24px',
              backgroundColor: '#dc143c',
              color: 'white',
              border: 'none',
              borderRadius: '5px',
              cursor: 'pointer',
              fontSize: '16px'
            }}
          >
             Painel de Controle
          </button>
          
          <button
            onClick={handleLogout}
            style={{
              padding: '12px 24px',
              backgroundColor: '#dc3545',
              color: 'white',
              border: 'none',
              borderRadius: '5px',
              cursor: 'pointer',
              fontSize: '16px'
            }}
          >
             Sair
          </button>
        </div>
      </div>
    </div>
  );
};

export default PerfilAdmin;