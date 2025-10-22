import React, { useEffect, useRef, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import EventoService from '../services/EventoService';
import UsuarioService from '../services/UsuarioService';
import PresencaService from '../services/PresencaService';
import logo from '../assets/images/blz_perfil.png';

const DetalhesEvento = () => {

  const { id } = useParams();
  const _dbRecords = useRef(true);

  // Simulando dados conforme a estrutura do banco de dados
  /*
  const evento = {
    id: 1,
    nome: 'Almoço Solidário',
    descricao: 'Almoço beneficente para arrecadar fundos para a comunidade local',
    localEvento: 'Centro Comunitário',
    cep: '12345678',
    numero: '123',
    complemento: 'Salão Principal',
    dataEvento: '2024-02-15',
    horaEvento: '12:00',
    periodo: 'Almoço',
    foto: null, // Aqui poderia vir um base64 ou um blob para exibição da imagem
    precoEntrada: 5000.00,
    arrecadacao: .00,
    totalParticipantes: 0,
    dataCadastro: '2024-01-20T10:00:00',
    usuario_id: 1,
    categoria_id: 1,
    statusEvento: 'Ativo',
    metaArrecadacao: 5000.00,

  };

  const porcentagemMeta = evento.metaArrecadacao > 0
    ? (evento.arrecadacao / evento.metaArrecadacao) * 100
    : 0;
*/
  const initialObject = {
    id: null,
    nome: "",
    descricao: "",
    localEvento: "",
    cep: "",
    numero: "",
    complemento: "",
    dataEvento: "",
    horaEvento: "",
    periodo: "",
    foto: null,
    precoEntrada: 0,
    arrecadacao: 0,
    totalParticipantes: 0,
    dataCadastro: "",
    usuario: {
      id: null
    },
    categoria: {
      id: null
    },
    statusEvento: ""
  };

  const [evento, setEvento] = useState(initialObject);
  const [isParticipating, setIsParticipating] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [totalPresencas, setTotalPresencas] = useState(0);

  useEffect(() => {
    if (_dbRecords.current) {
      // Carrega dados do usuário
      const user = UsuarioService.getCurrentUser();
      setCurrentUser(user);
      
      EventoService.findById(id)
        .then(response => {
          const evento = response.data;
          setEvento(evento);
          console.log(evento);
        })
        .catch(e => {
          console.log(e);
        });
      
      // Carregar número de presenças confirmadas
      PresencaService.findAll()
        .then(response => {
          const presencasEvento = response.data.filter(p => p.evento?.id == id && p.statusPresenca === 'CONFIRMADO');
          setTotalPresencas(presencasEvento.length);
        })
        .catch(e => {
          console.log(e);
        });
    } return () => {
      _dbRecords.current = false;
    }
  }, [id]);

  const porcentagemMeta = evento.arrecadacao + 10 > 0
    ? (evento.arrecadacao / evento.arrecadacao * 1.05) * 10
    : 0;

  const handleConfirmarPresenca = async () => {
    if (!currentUser) {
      alert('Você precisa estar logado para confirmar presença!');
      return;
    }
    try {
      const presencaData = {
        statusPresenca: 'CONFIRMADO',
        usuario: { id: currentUser.id },
        evento: { id: evento.id }
      };
      await PresencaService.save(presencaData);
      setIsParticipating(true);
      alert('Presença confirmada com sucesso!');
    } catch (error) {
      console.error('Erro ao confirmar presença:', error);
      alert('Erro ao confirmar presença. Tente novamente.');
    }
  };

  const handleCancelarParticipacao = async () => {
    if (!currentUser) {
      alert('Você precisa estar logado!');
      return;
    }
    try {
      // Assumindo que você tem o ID da presença ou pode buscar
      await PresencaService.desmarcar(currentUser.id);
      setIsParticipating(false);
      alert('Participação cancelada!');
    } catch (error) {
      console.error('Erro ao cancelar participação:', error);
      alert('Erro ao cancelar participação. Tente novamente.');
    }
  };

  return (
    <div className="container">
      <div className="card">
        <div style={{ marginBottom: '30px' }}>
          <Link to="/eventos" style={{ color: '#dc143c', textDecoration: 'none' }}>
            ← Voltar para Eventos
          </Link>
        </div>

        <div style={{ textAlign: 'center', marginBottom: '30px' }}>

          <div>
             <img  src={evento.foto ? 'data:image/jpeg;base64,' + evento.foto : logo} alt="..." />
          </div>
        
          <h1 style={{ color: '#dc143c', marginTop: '10px' }}>{evento.nome}</h1>
          <span style={{
            background: evento.statusEvento === 'Ativo' ? '#dc143c' : '#666',
            color: 'white',
            padding: '8px 16px',
            borderRadius: '20px',
            fontSize: '0.9rem'
          }}>
            {evento.statusEvento}
          </span>
        </div>

        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
          gap: '30px'
        }}>
          <div>
            <h3 style={{ color: '#dc143c', marginBottom: '20px' }}>📋 Informações do Evento</h3>

            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', marginBottom: '20px' }}>
              <p style={{ marginBottom: '10px' }}>
                <strong>Data:</strong> {new Date(evento.dataEvento).toLocaleDateString('pt-BR')}
              </p>
              <p style={{ marginBottom: '10px' }}>
                <strong> Horário:</strong> {evento.horaEvento}
              </p>
              <p style={{ marginBottom: '10px' }}>
                <strong> Período:</strong> {evento.periodo}
              </p>
              <p style={{ marginBottom: '10px' }}>
                <strong>Local:</strong> {evento.localEvento}, Nº {evento.numero}
              </p>
              {evento.complemento && (
                <p style={{ marginBottom: '10px' }}>
                  <strong> Complemento:</strong> {evento.complemento}
                </p>
              )}
              {evento.cep && (
                <p style={{ marginBottom: '10px' }}>
                  <strong> CEP:</strong> {evento.cep}
                </p>
              )}

            </div>

            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px' }}>
              <h4 style={{ color: '#dc143c', marginBottom: '10px' }}> Descrição</h4>
              <p style={{ lineHeight: '1.6', color: '#555' }}>{evento.descricao}</p>
            </div>
          </div>

          <div>
            <h3 style={{ color: '#dc143c', marginBottom: '20px' }}> Estatísticas</h3>

            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', marginBottom: '20px' }}>
              <div style={{ textAlign: 'center', marginBottom: '20px' }}>
                <span style={{ fontSize: '2rem', display: 'block' }}>💵</span>
                <h4 style={{ color: '#dc143c', margin: '10px 0 5px' }}>R$ {evento.precoEntrada}</h4>
                <p style={{ color: '#666', margin: '0' }}>Valor da Entrada</p>
              </div>
            </div>

            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', marginBottom: '20px' }}>
              <h4 style={{ color: '#dc143c', marginBottom: '15px' }}> Arrecadação</h4>
              <div style={{ marginBottom: '10px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '5px' }}>
                  <span>Arrecadado:</span>
                  <strong>R$ {evento.arrecadacao}</strong>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '10px' }}>
                  <span>Meta:</span>
                  <span>R$ {evento.arrecadacao}</span>
                </div>
                <div style={{
                  background: '#ddd',
                  borderRadius: '10px',
                  height: '10px',
                  overflow: 'hidden'
                }}>
                  <div style={{
                    background: '#dc143c',
                    height: '100%',
                    width: `${porcentagemMeta}%`,
                    borderRadius: '10px'
                  }}></div>
                </div>
                <p style={{ textAlign: 'center', marginTop: '5px', fontSize: '0.9rem', color: '#666' }}>
                  {Math.round(porcentagemMeta)}% da meta
                </p>
              </div>
            </div>

            {localStorage.getItem('nivelAcesso') !== 'ADMIN' && (
              <div style={{ display: 'flex', gap: '10px' }}>
                {!isParticipating ? (
                  <button 
                    className="btn btn-primary" 
                    style={{ flex: 1 }}
                    onClick={handleConfirmarPresenca}
                  >
                    ✓ Confirmar Presença
                  </button>
                ) : (
                  <button 
                    className="btn btn-secondary" 
                    style={{ flex: 1 }}
                    onClick={handleCancelarParticipacao}
                  >
                    ✗ Cancelar Participação
                  </button>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default DetalhesEvento;
