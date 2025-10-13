import React, { useState, useEffect } from 'react';
import { chatService } from '../services/chatService';

const AdminChatManager = () => {
  const [conversations, setConversations] = useState([]);
  const [selectedConversation, setSelectedConversation] = useState(null);
  const [replyMessage, setReplyMessage] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadPendingConversations();
  }, []);

  const loadPendingConversations = async () => {
    try {
      setLoading(true);
      const data = await chatService.getPendingConversations();
      setConversations(data);
    } catch (error) {
      console.error('Erro ao carregar conversas:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleReply = async () => {
    if (!replyMessage.trim() || !selectedConversation) return;

    try {
      await chatService.adminReply(selectedConversation.id, replyMessage);
      setReplyMessage('');
      loadPendingConversations();
      alert('Resposta enviada com sucesso!');
    } catch (error) {
      alert('Erro ao enviar resposta');
    }
  };

  return (
    <div style={{ padding: '20px' }}>
      <h2 style={{ color: '#dc143c', marginBottom: '20px' }}>
        💬 Gerenciamento de Chat - Conversas Pendentes
      </h2>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '20px' }}>
        {/* Lista de conversas */}
        <div>
          <h3>Conversas Aguardando Atendimento</h3>
          {loading ? (
            <p>Carregando...</p>
          ) : conversations.length === 0 ? (
            <p>Nenhuma conversa pendente</p>
          ) : (
            <div>
              {conversations.map((conv) => (
                <div
                  key={conv.id}
                  onClick={() => setSelectedConversation(conv)}
                  style={{
                    padding: '15px',
                    border: '1px solid #ddd',
                    borderRadius: '8px',
                    marginBottom: '10px',
                    cursor: 'pointer',
                    backgroundColor: selectedConversation?.id === conv.id ? '#fff0f0' : 'white'
                  }}
                >
                  <div style={{ fontWeight: 'bold' }}>
                    {conv.userInfo?.name || 'Usuário Anônimo'}
                  </div>
                  <div style={{ fontSize: '12px', color: '#666' }}>
                    {new Date(conv.timestamp).toLocaleString()}
                  </div>
                  <div style={{ fontSize: '14px', marginTop: '5px' }}>
                    {conv.lastMessage?.substring(0, 50)}...
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Detalhes da conversa selecionada */}
        <div>
          {selectedConversation ? (
            <>
              <h3>Conversa com {selectedConversation.userInfo?.name || 'Usuário'}</h3>
              
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
                      <div style={{ fontSize: '12px', opacity: 0.7, marginBottom: '5px' }}>
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
                  onClick={handleReply}
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
                  Enviar Resposta
                </button>
              </div>
            </>
          ) : (
            <p>Selecione uma conversa para visualizar</p>
          )}
        </div>
      </div>
    </div>
  );
};

export default AdminChatManager;