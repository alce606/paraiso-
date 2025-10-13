import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import EventoService from '../services/EventoService';
import PresencaService from '../services/PresencaService';

const ParticipantesEvento = () => {
  const { id } = useParams();
  const [evento, setEvento] = useState({});
  const [participantes, setParticipantes] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    carregarDados();
  }, [id]);

  const carregarDados = async () => {
    try {
      const eventoResponse = await EventoService.findById(id);
      setEvento(eventoResponse.data);
      
      const presencasResponse = await PresencaService.findAll();
      const participantesEvento = presencasResponse.data.filter(p => p.evento?.id == id && p.statusPresenca === 'CONFIRMADO');
      setParticipantes(participantesEvento);
    } catch (error) {
      console.error('Erro ao carregar dados:', error);
    } finally {
      setLoading(false);
    }
  };

  const vagasDisponiveis = (evento.totalParticipantes || 0) - participantes.length;

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
          <h1 style={{ color: '#dc143c' }}>Participantes - {evento.nome}</h1>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '30px', marginBottom: '30px' }}>
          <div className="card" style={{ background: '#fff0f0', textAlign: 'center' }}>
            <h3 style={{ color: '#dc143c' }}>Total de Participantes</h3>
            <div style={{ fontSize: '2.5rem', color: '#dc143c', fontWeight: 'bold' }}>
              {participantes.length}
            </div>
          </div>
          
          <div className="card" style={{ background: '#f0fff0', textAlign: 'center' }}>
            <h3 style={{ color: '#28a745' }}>Vagas Disponíveis</h3>
            <div style={{ fontSize: '2.5rem', color: '#28a745', fontWeight: 'bold' }}>
              {vagasDisponiveis}
            </div>
          </div>
        </div>

        <div className="card">
          <h3 style={{ color: '#dc143c', marginBottom: '20px' }}>Lista de Participantes</h3>
          
          {participantes.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '40px', color: '#666' }}>
              <h4>Nenhum participante confirmado ainda</h4>
              <p>Aguardando confirmações de presença...</p>
            </div>
          ) : (
            <div style={{ display: 'grid', gap: '15px' }}>
              {participantes.map((participante, index) => (
                <div key={index} style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  padding: '15px',
                  background: '#f8f9fa',
                  borderRadius: '8px',
                  border: '1px solid #dee2e6'
                }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
                    <div>
                      <div style={{ fontWeight: 'bold', color: '#333' }}>
                        {participante.usuario?.nome || `Participante ${index + 1}`}
                      </div>
                      <div style={{ color: '#666', fontSize: '0.9rem' }}>
                        {participante.usuario?.email || 'Email não disponível'}
                      </div>
                    </div>
                  </div>
                  
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    <span style={{
                      background: '#28a745',
                      color: 'white',
                      padding: '4px 8px',
                      borderRadius: '12px',
                      fontSize: '0.8rem'
                    }}>
                      Confirmado
                    </span>
                    <span style={{ color: '#666', fontSize: '0.9rem' }}>
                      {new Date(participante.dataCadastro).toLocaleDateString('pt-BR')}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ParticipantesEvento;