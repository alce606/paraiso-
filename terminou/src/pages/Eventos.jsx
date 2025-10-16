import React, { useState } from 'react';
import { useRef } from 'react';
import { Link } from 'react-router-dom';
import EventoService from '../services/EventoService';
import { useEffect } from 'react';

const Eventos = () => {
  const _dbRecords = useRef(true);
  const nivelAcesso = localStorage.getItem('nivelAcesso');
  const [eventos, setEventos] = useState([]);

  const getEventos = () => {
    EventoService.findAll().then(
      (response) => {
        const categorias = response.data;
        setEventos(categorias);
      }
    ).catch((error) => {
      console.log(error);
    })
  }

  useEffect(() => {
    if (_dbRecords.current) {
      getEventos();
    }
    return () => {
      _dbRecords.current = false;
    }
  }, []);


  return (
    <div className="container">
      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '30px' }}>
          <div>
            <span style={{ fontSize: '2.5rem', marginRight: '10px' }}>🎉</span>
            <h1 style={{ color: '#dc143c', display: 'inline' }}>
              {nivelAcesso === 'ADMIN' ? 'Gerenciar Eventos' : 'Eventos Disponíveis'}
            </h1>
          </div>
          {nivelAcesso === 'ADMIN' && (
            <Link to="/eventos/criar" className="btn btn-primary">
              + Criar Evento
            </Link>
          )}
        </div>

        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
          gap: '20px'
        }}>
          {eventos.map(evento => (
            <div key={evento.id} className="card" style={{ background: '#fff0f0', margin: 0 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', marginBottom: '15px' }}>
                <h3 style={{ color: '#dc143c', margin: 0 }}>{evento.nome}</h3>
                <span style={{
                  background: evento.statusEvento === 'Ativo' ? '#dc143c' : '#666',
                  color: 'white',
                  padding: '4px 8px',
                  borderRadius: '12px',
                  fontSize: '0.8rem'
                }}>
                  {evento.statusEvento}
                </span>
              </div>

              <p style={{ color: '#666', marginBottom: '10px' }}>
                <strong>📅 Data:</strong> {(() => {
                  try {
                    return new Date(evento.dataEvento).toLocaleDateString('pt-BR');
                  } catch (error) {
                    return 'Data inválida';
                  }
                })()}
              </p>
              <p style={{ color: '#666', marginBottom: '10px' }}>
                <strong>📍 Local:</strong> {evento.localEvento}
              </p>
              <p style={{ color: '#666', marginBottom: '20px' }}>
                {evento.descricao}
              </p>

              <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                {nivelAcesso === 'ADMIN' && (
                  <>
                    <Link to={`/eventos/editar/${evento.id}`} className="btn btn-secondary" style={{ flex: 1, padding: '8px', textAlign: 'center', textDecoration: 'none', minWidth: '100px' }}>
                      Editar
                    </Link>
                    <Link to={`/eventos/presencas/${evento.id}`} className="btn btn-success" style={{ flex: 1, padding: '8px', textAlign: 'center', textDecoration: 'none', minWidth: '100px' }}>
                      Presenças
                    </Link>
                  </>
                )}
                <Link to={`/eventos/descricao/${evento.id}`} className="btn btn-primary" style={{ flex: nivelAcesso === 'ADMIN' ? 1 : 2, padding: '8px', textAlign: 'center', textDecoration: 'none', minWidth: '100px' }}>
                  Ver Descrição
                </Link>
              </div>
            </div>
          ))}
        </div>

        {eventos.length === 0 && (
          <div style={{ textAlign: 'center', padding: '40px', color: '#666' }}>
            <span style={{ fontSize: '3rem', display: 'block', marginBottom: '20px' }}>📅</span>
            <h3>Nenhum evento criado ainda</h3>
            <p>Comece criando seu primeiro evento beneficente!</p>
          </div>
        )}
      </div>
    </div>
  );
};

export default Eventos;