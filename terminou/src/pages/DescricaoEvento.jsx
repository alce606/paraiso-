import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import EventoService from '../services/EventoService';

const DescricaoEvento = () => {
  const { id } = useParams();
  const [evento, setEvento] = useState({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    carregarEvento();
  }, [id]);

  const carregarEvento = async () => {
    try {
      const response = await EventoService.findById(id);
      setEvento(response.data);
    } catch (error) {
      console.error('Erro ao carregar evento:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="container">Carregando...</div>;
  }

  return (
    <div className="container">
      <div className="card">
        <div style={{ marginBottom: '30px' }}>
          <Link to="/eventos" style={{ color: '#dc143c', textDecoration: 'none' }}>
            ← Voltar para Eventos
          </Link>
        </div>

        <div style={{ textAlign: 'center', marginBottom: '30px' }}>
          <h1 style={{ color: '#dc143c' }}>{evento.nome}</h1>
          <span style={{
            background: evento.statusEvento === 'ATIVO' ? '#dc143c' : '#666',
            color: 'white',
            padding: '8px 16px',
            borderRadius: '20px',
            fontSize: '0.9rem'
          }}>
            {evento.statusEvento}
          </span>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '30px', marginBottom: '30px' }}>
          <div className="card" style={{ background: '#fff0f0' }}>
            <h3 style={{ color: '#dc143c', marginBottom: '20px' }}>📋 Informações Gerais</h3>
            <div style={{ display: 'grid', gap: '10px' }}>
              <p><strong>📅 Data:</strong> {new Date(evento.dataEvento).toLocaleDateString('pt-BR')}</p>
              <p><strong>⏰ Horário:</strong> {evento.horaEvento}</p>
              <p><strong>🌅 Período:</strong> {evento.periodo}</p>
              <p><strong>📍 Local:</strong> {evento.localEvento}</p>
              <p><strong>🏢 Endereço:</strong> {evento.complemento}</p>
              <p><strong>📮 CEP:</strong> {evento.cep}</p>
            </div>
          </div>

          <div className="card" style={{ background: '#f0fff0' }}>
            <h3 style={{ color: '#28a745', marginBottom: '20px' }}>💰 Detalhes Financeiros</h3>
            <div style={{ display: 'grid', gap: '10px' }}>
              <p><strong>💵 Valor da Entrada:</strong> 
                {evento.precoEntrada === 0 ? 
                  <span style={{ color: '#28a745', fontWeight: 'bold' }}> GRATUITO</span> : 
                  ` R$ ${evento.precoEntrada?.toFixed(2)}`
                }
              </p>
              <p><strong>👥 Participantes:</strong> {evento.totalParticipantes || 0}</p>
              <p><strong>🏷️ Categoria:</strong> {evento.categoria?.nome}</p>
            </div>
          </div>
        </div>

        <div className="card" style={{ background: '#f8f9fa' }}>
          <h3 style={{ color: '#dc143c', marginBottom: '20px' }}>📝 Descrição Completa</h3>
          <p style={{ 
            fontSize: '1.1rem', 
            lineHeight: '1.6', 
            color: '#333',
            textAlign: 'justify'
          }}>
            {evento.descricao || 'Nenhuma descrição disponível para este evento.'}
          </p>
        </div>

        {evento.usuario && (
          <div className="card" style={{ background: '#e3f2fd' }}>
            <h3 style={{ color: '#1976d2', marginBottom: '20px' }}>👤 Organizador</h3>
            <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
              <div>
                <p style={{ margin: 0, fontWeight: 'bold', fontSize: '1.1rem' }}>
                  {evento.usuario.nome}
                </p>
                <p style={{ margin: 0, color: '#666' }}>
                  {evento.usuario.email}
                </p>
              </div>
            </div>
          </div>
        )}

        <div style={{ textAlign: 'center', marginTop: '30px' }}>
          <button 
            onClick={() => alert('Esta função está disponível apenas no aplicativo móvel. Baixe o app para confirmar sua presença!')}
            className="btn btn-primary" 
            style={{ 
              padding: '15px 30px', 
              fontSize: '1.1rem',
              background: '#dc143c',
              border: 'none',
              cursor: 'pointer'
            }}
          >
            🎯 Participar do Evento
          </button>
        </div>
      </div>
    </div>
  );
};

export default DescricaoEvento;