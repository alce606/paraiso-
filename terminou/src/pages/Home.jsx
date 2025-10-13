import React from 'react';
import { useNavigate } from 'react-router-dom';

const Home = () => {
  const navigate = useNavigate();

  const handleGerenciamento = () => {
    navigate('/eventos');
  };

  const handleSuporte = () => {
    navigate('/suporte');
  };

  const handleResultados = () => {
    alert('📊 Resultados:\n\n• 150+ eventos organizados\n• 50+ ONGs cadastradas\n• 10.000+ pessoas impactadas\n• R$ 500.000+ arrecadados');
  };

  return (
    <div className="container">
      <div className="card" style={{ textAlign: 'center' }}>
        <div style={{ fontSize: '4rem', marginBottom: '20px' }}>❤️</div>
        <h1 style={{ color: '#dc143c', marginBottom: '20px' }}>Bem-vindo ao Coração Generoso</h1>
        <p style={{ fontSize: '1.2rem', color: '#666', marginBottom: '30px' }}>
          Sistema de Gerenciamento para fazer a diferença na vida das pessoas
        </p>
        
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
          gap: '20px',
          marginTop: '40px'
        }}>
          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s, box-shadow 0.2s'
            }}
            onClick={handleGerenciamento}
            onMouseEnter={(e) => {
              e.target.style.transform = 'translateY(-5px)';
              e.target.style.boxShadow = '0 8px 25px rgba(220, 20, 60, 0.15)';
            }}
            onMouseLeave={(e) => {
              e.target.style.transform = 'translateY(0)';
              e.target.style.boxShadow = 'none';
            }}
          >
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}> Gerenciamento</h3>
            <p>Controle total das atividades e recursos do projeto</p>
            <button style={{
              marginTop: '15px',
              padding: '8px 16px',
              background: '#dc143c',
              color: 'white',
              border: 'none',
              borderRadius: '5px',
              cursor: 'pointer'
            }}>Acessar Eventos</button>
          </div>
          
          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s, box-shadow 0.2s'
            }}
            onClick={handleSuporte}
            onMouseEnter={(e) => {
              e.target.style.transform = 'translateY(-5px)';
              e.target.style.boxShadow = '0 8px 25px rgba(220, 20, 60, 0.15)';
            }}
            onMouseLeave={(e) => {
              e.target.style.transform = 'translateY(0)';
              e.target.style.boxShadow = 'none';
            }}
          >
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Nossa Plataforma</h3>
            <p>Nossa plataforma está ativa e disponível para ONGs e organizações que desejam gerenciar seus eventos e divulgar suas ações beneficentes.</p>
            <button style={{
              marginTop: '15px',
              padding: '8px 16px',
              background: '#dc143c',
              color: 'white',
              border: 'none',
              borderRadius: '5px',
              cursor: 'pointer'
            }}>Ir ao Suporte</button>
          </div>
          
          <div 
            className="card" 
            style={{ 
              background: '#fff0f0', 
              cursor: 'pointer',
              transition: 'transform 0.2s, box-shadow 0.2s'
            }}
            onClick={handleResultados}
            onMouseEnter={(e) => {
              e.target.style.transform = 'translateY(-5px)';
              e.target.style.boxShadow = '0 8px 25px rgba(220, 20, 60, 0.15)';
            }}
            onMouseLeave={(e) => {
              e.target.style.transform = 'translateY(0)';
              e.target.style.boxShadow = 'none';
            }}
          >
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Resultados</h3>
            <p>Acompanhe o progresso e os resultados alcançados</p>
            <button style={{
              marginTop: '15px',
              padding: '8px 16px',
              background: '#dc143c',
              color: 'white',
              border: 'none',
              borderRadius: '5px',
              cursor: 'pointer'
            }}>Ver Estatísticas</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;