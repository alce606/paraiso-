import React from 'react';
import { useNavigate } from 'react-router-dom';

const GerenciamentoAdmin = () => {
  const navigate = useNavigate();

  const handleCriarEvento = () => {
    navigate('/eventos/criar');
  };

  const handleGerenciarEventos = () => {
    navigate('/eventos');
  };

  const handleGerenciarUsuarios = () => {
    navigate('/admin/usuarios');
  };


  const handleConfiguracoes = () => {
    navigate('/admin/configuracoes');
  };





  const handleGerenciarSuporte = () => {
    navigate('/admin/suporte');
  };

  return (
    <div className="container">
      <div className="card">
        <div style={{ textAlign: 'center', marginBottom: '30px' }}>
          <div style={{ fontSize: '3rem', color: '#dc143c', fontWeight: 'bold' }}>ADMIN</div>
          <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Painel Administrativo</h1>
          <p style={{ color: '#666', fontSize: '1.1rem' }}>Central de gerenciamento do Coração Generoso</p>
        </div>

        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', 
          gap: '20px',
          marginBottom: '30px'
        }}>
          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s'
            }}
            onClick={handleCriarEvento}
            onMouseEnter={(e) => e.target.style.transform = 'translateY(-3px)'}
            onMouseLeave={(e) => e.target.style.transform = 'translateY(0)'}
          >
            <div style={{ textAlign: 'center', marginBottom: '15px' }}>
              <i className="bi bi-plus-circle" style={{ fontSize: '2.5rem', color: '#dc143c' }}></i>
            </div>
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Criar Evento</h3>
            <p style={{ marginBottom: '15px' }}>Criar novos eventos beneficentes</p>
            <button className="btn btn-danger">Novo Evento</button>
          </div>

          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s'
            }}
            onClick={handleGerenciarEventos}
            onMouseEnter={(e) => e.target.style.transform = 'translateY(-3px)'}
            onMouseLeave={(e) => e.target.style.transform = 'translateY(0)'}
          >
            <div style={{ textAlign: 'center', marginBottom: '15px' }}>
              <i className="bi bi-calendar-event" style={{ fontSize: '2.5rem', color: '#dc143c' }}></i>
            </div>
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Gerenciar Eventos</h3>
            <p style={{ marginBottom: '15px' }}>Organizar e acompanhar eventos</p>
            <button className="btn btn-danger">Ver Eventos</button>
          </div>

          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s'
            }}
            onClick={handleGerenciarUsuarios}
            onMouseEnter={(e) => e.target.style.transform = 'translateY(-3px)'}
            onMouseLeave={(e) => e.target.style.transform = 'translateY(0)'}
          >
            <div style={{ textAlign: 'center', marginBottom: '15px' }}>
              <i className="bi bi-people" style={{ fontSize: '2.5rem', color: '#dc143c' }}></i>
            </div>
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Gerenciar Usuários</h3>
            <p style={{ marginBottom: '15px' }}>Gerenciar comunidade e organizações</p>
            <button className="btn btn-danger">Ver Usuários</button>
          </div>

          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s'
            }}
            onClick={handleConfiguracoes}
            onMouseEnter={(e) => e.target.style.transform = 'translateY(-3px)'}
            onMouseLeave={(e) => e.target.style.transform = 'translateY(0)'}
          >
            <div style={{ textAlign: 'center', marginBottom: '15px' }}>
              <i className="bi bi-gear" style={{ fontSize: '2.5rem', color: '#dc143c' }}></i>
            </div>
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Configurações</h3>
            <p style={{ marginBottom: '15px' }}>Personalizar e configurar o site</p>
            <button className="btn btn-danger">Configurar</button>
          </div>



          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s'
            }}
            onClick={handleGerenciarSuporte}
            onMouseEnter={(e) => e.target.style.transform = 'translateY(-3px)'}
            onMouseLeave={(e) => e.target.style.transform = 'translateY(0)'}
          >
            <div style={{ textAlign: 'center', marginBottom: '15px' }}>
              <i className="bi bi-headset" style={{ fontSize: '2.5rem', color: '#dc143c' }}></i>
            </div>
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Gerenciar Suporte</h3>
            <p style={{ marginBottom: '15px' }}>Atender e ajudar nossa comunidade</p>
            <button className="btn btn-danger">Ver Suportes</button>
          </div>




        </div>

      </div>
    </div>
  );
};

export default GerenciamentoAdmin;