import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { chatService } from '../services/chatService';

const ChatSuporte = () => {
  const navigate = useNavigate();
  const [conversations, setConversations] = useState([]);
  const [selectedConversation, setSelectedConversation] = useState(null);
  const [replyMessage, setReplyMessage] = useState('');
  const [loading, setLoading] = useState(true);
  const [filtro, setFiltro] = useState('');
  const [statusFiltro, setStatusFiltro] = useState('todos');

  useEffect(() => {
    carregarConversas();
  }, []);

  const carregarConversas = async () => {
    try {
      setLoading(true);
      const response = await chatService.getPendingConversations();
      setConversations(response || []);
    } catch (error) {
      console.error('Erro ao carregar conversas:', error);
      setConversations([]);
    } finally {
      setLoading(false);
    }
  };

  const enviarResposta = async () => {
    if (!replyMessage.trim() || !selectedConversation) return;

    try {
      await chatService.adminReply(selectedConversation.id, replyMessage);
      setReplyMessage('');
      carregarConversas();
      setSelectedConversation(null);
    } catch (error) {
      console.error('Erro ao enviar resposta:', error);
    }
  };

  const conversasFiltradas = conversations.filter(conversa => {
    const matchNome = conversa.userInfo?.name?.toLowerCase().includes(filtro.toLowerCase());
    const matchStatus = statusFiltro === 'todos' || conversa.status === statusFiltro;
    return matchNome && matchStatus;
  });

  return (
    <div className="container">
      <div className="card">
        <div style={{ textAlign: 'center', marginBottom: '30px' }}>
          <span style={{ fontSize: '3rem' }}>💬</span>
          <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Chat Suporte</h1>
          <p style={{ color: '#666', fontSize: '1.1rem' }}>Gerenciar conversas do suporte usuario</p>
        </div>

        {/* Filtros */}
        <div style={{ 
          display: 'flex', 
          gap: '15px', 
          marginBottom: '30px',
          flexWrap: 'wrap'
        }}>
          <input
            type="text"
            placeholder="Buscar por nome do usuário..."
            value={filtro}
            onChange={(e) => setFiltro(e.target.value)}
            style={{
              flex: 1,
              minWidth: '200px',
              padding: '10px',
              border: '1px solid #ddd',
              borderRadius: '5px'
            }}
          />
          <select
            value={statusFiltro}
            onChange={(e) => setStatusFiltro(e.target.value)}
            style={{
              padding: '10px',
              border: '1px solid #ddd',
              borderRadius: '5px'
            }}
          >
            <option value="todos">Todos os status</option>
            <option value="active">Ativo</option>
            <option value="pending">Pendente</option>
            <option value="resolved">Resolvido</option>
          </select>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '20px' }}>
          {/* Lista de conversas */}
          <div>
            <h3 style={{ color: '#333', marginBottom: '15px' }}>
              {conversasFiltradas.length} conversa(s) encontrada(s)
            </h3>
            
            {loading ? (
              <div style={{ textAlign: 'center', padding: '50px' }}>
                <p>Carregando conversas...</p>
              </div>
            ) : conversasFiltradas.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '30px', color: '#666' }}>
                <p>Nenhuma conversa encontrada</p>
              </div>
            ) : (
              <div style={{ maxHeight: '500px', overflowY: 'auto' }}>
                {conversasFiltradas.map((conversa) => (
                  <div
                    key={conversa.id}
                    onClick={() => setSelectedConversation(conversa)}
                    className="card"
                    style={{
                      marginBottom: '10px',
                      cursor: 'pointer',
                      background: selectedConversation?.id === conversa.id ? '#fff0f0' : 'white',
                      border: selectedConversation?.id === conversa.id ? '2px solid #dc143c' : '1px solid #ddd'
                    }}
                  >
                    <div style={{ fontWeight: 'bold', marginBottom: '5px' }}>
                      {conversa.userInfo?.name || 'Usuário Anônimo'}
                    </div>
                    <div style={{ fontSize: '0.8rem', color: '#666', marginBottom: '5px' }}>
                      {new Date(conversa.timestamp).toLocaleString('pt-BR')}
                    </div>
                    <div style={{ fontSize: '0.9rem', color: '#333' }}>
                      {conversa.lastMessage?.substring(0, 60)}...
                    </div>
                    <div style={{ marginTop: '5px' }}>
                      <span style={{
                        padding: '2px 6px',
                        borderRadius: '10px',
                        fontSize: '0.7rem',
                        background: conversa.status === 'active' ? '#28a745' : 
                                   conversa.status === 'pending' ? '#ffc107' : '#6c757d',
                        color: 'white'
                      }}>
                        {conversa.status?.toUpperCase()}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Detalhes da conversa */}
          <div>
            {selectedConversation ? (
              <>
                <h3 style={{ color: '#333', marginBottom: '15px' }}>
                  Conversa com {selectedConversation.userInfo?.name || 'Usuário'}
                </h3>
                
                <div style={{
                  height: '400px',
                  border: '1px solid #ddd',
                  borderRadius: '8px',
                  padding: '15px',
                  overflowY: 'auto',
                  backgroundColor: '#f9f9f9',
                  marginBottom: '15px'
                }}>
                  {selectedConversation.messages?.map((message, index) => (
                    <div key={index} style={{
                      marginBottom: '10px',
                      display: 'flex',
                      justifyContent: message.sender === 'user' ? 'flex-end' : 'flex-start'
                    }}>
                      <div style={{
                        maxWidth: '80%',
                        padding: '10px 15px',
                        borderRadius: '18px',
                        backgroundColor: message.sender === 'user' ? '#dc143c' : '#e0e0e0',
                        color: message.sender === 'user' ? 'white' : 'black'
                      }}>
                        <div style={{ fontSize: '0.7rem', opacity: 0.7, marginBottom: '5px' }}>
                          {message.sender === 'user' ? 'Usuário' : 'Bot'}
                        </div>
                        {message.text}
                      </div>
                    </div>
                  ))}
                </div>

                <div style={{ display: 'flex', gap: '10px' }}>
                  <textarea
                    value={replyMessage}
                    onChange={(e) => setReplyMessage(e.target.value)}
                    placeholder="Digite sua resposta..."
                    style={{
                      flex: 1,
                      padding: '10px',
                      border: '1px solid #ddd',
                      borderRadius: '8px',
                      resize: 'vertical',
                      minHeight: '80px'
                    }}
                  />
                  <button
                    onClick={enviarResposta}
                    disabled={!replyMessage.trim()}
                    style={{
                      padding: '10px 20px',
                      backgroundColor: '#dc143c',
                      color: 'white',
                      border: 'none',
                      borderRadius: '8px',
                      cursor: 'pointer',
                      height: 'fit-content'
                    }}
                  >
                    Enviar
                  </button>
                </div>
              </>
            ) : (
              <div style={{ textAlign: 'center', padding: '50px', color: '#666' }}>
                <p>Selecione uma conversa para visualizar</p>
              </div>
            )}
          </div>
        </div>

        {/* Botão voltar */}
        <div style={{ textAlign: 'center', marginTop: '30px' }}>
          <button
            onClick={() => navigate('/admin')}
            style={{
              padding: '12px 30px',
              background: '#6c757d',
              color: 'white',
              border: 'none',
              borderRadius: '5px',
              cursor: 'pointer',
              fontSize: '1rem'
            }}
          >
            ← Voltar ao Painel Admin
          </button>
        </div>
      </div>
    </div>
  );
};

export default ChatSuporte;