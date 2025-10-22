import React, { useState, useEffect } from 'react';
import MensagemService from '../services/MensagemService';
import UsuarioService from '../services/UsuarioService';

const Suporte = () => {
  const [formData, setFormData] = useState({
    nome: '',
    email: '',
    assunto: '',
    mensagem: ''
  });

  const [sending, setSending] = useState(false);
  const [feedback, setFeedback] = useState('');
  const [showMySupports, setShowMySupports] = useState(false);
  const [mySupports, setMySupports] = useState([]);
  const [loadingSupports, setLoadingSupports] = useState(false);
  const [usuarioLogado, setUsuarioLogado] = useState(null);

  useEffect(() => {
    const user = UsuarioService.getCurrentUser();
    setUsuarioLogado(user);
  }, []);

  const validateEmail = (email) => /\S+@\S+\.\S+/.test(email);

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setFeedback('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!formData.nome || !formData.email || !formData.assunto || !formData.mensagem) {
      setFeedback('Preencha todos os campos.');
      return;
    }

    if (!validateEmail(formData.email)) {
      setFeedback('Email inválido.');
      return;
    }

    setSending(true);
    setFeedback('');

    const mensagem = {
      dataMensagem: new Date().toISOString(),
      nome: formData.nome,
      email: formData.email,
      telefone: '',
      texto: formData.mensagem,
      statusMensagem: 'ativa',
      usuario: { id: usuarioLogado?.id || 1 }
    };

    try {
      await MensagemService.save(mensagem);
      setFeedback('Mensagem enviada com sucesso!');
      setFormData({ nome: '', email: '', assunto: '', mensagem: '' });
    } catch (error) {
      console.error('Erro ao enviar:', error);
      setFeedback('Erro ao enviar. Tente novamente.');
    } finally {
      setSending(false);
    }
  };

  const handleShowMySupports = async () => {
    if (!usuarioLogado) return;
    
    setLoadingSupports(true);
    try {
      const response = await MensagemService.findAll();
      const userSupports = response.data.filter(msg => msg.usuario?.id === usuarioLogado.id);
      setMySupports(userSupports);
      setShowMySupports(true);
    } catch (error) {
      console.error('Erro ao buscar suportes:', error);
      setFeedback('Erro ao carregar seus suportes.');
    } finally {
      setLoadingSupports(false);
    }
  };

  const handleBackToForm = () => {
    setShowMySupports(false);
    setFeedback('');
  };

  const estiloCampo = {
    padding: '12px',
    border: '2px solid #ddd',
    borderRadius: '8px',
    fontSize: '16px',
    width: '100%',
    marginBottom: '20px'
  };

  const estiloBotao = {
    backgroundColor: '#dc143c',
    color: '#fff',
    padding: '14px',
    fontSize: '18px',
    border: 'none',
    borderRadius: '8px',
    cursor: sending ? 'not-allowed' : 'pointer',
    width: '100%',
    opacity: sending ? 0.7 : 1
  };

  if (showMySupports) {
    return (
      <div style={{ maxWidth: 800, margin: '40px auto', fontFamily: 'Segoe UI, sans-serif' }}>
        <div style={{ display: 'flex', alignItems: 'center', marginBottom: '20px' }}>
          <button 
            onClick={handleBackToForm}
            style={{
              backgroundColor: '#6c757d',
              color: '#fff',
              padding: '8px 16px',
              border: 'none',
              borderRadius: '6px',
              cursor: 'pointer',
              marginRight: '15px'
            }}
          >
            ← Voltar
          </button>
          <h2 style={{ color: '#dc143c', margin: 0 }}>Meus Suportes</h2>
        </div>
        
        {mySupports.length === 0 ? (
          <p style={{ textAlign: 'center', color: '#666' }}>Você ainda não enviou nenhum suporte.</p>
        ) : (
          <div>
            {mySupports.map((support, index) => (
              <div key={index} className="card" style={{
                padding: '20px',
                marginBottom: '15px'
              }}>
                <div style={{ marginBottom: '10px' }}>
                  <strong style={{ color: '#dc143c' }}>Data:</strong> {new Date(support.dataMensagem).toLocaleDateString('pt-BR')}
                </div>
                <div style={{ marginBottom: '10px' }}>
                  <strong style={{ color: '#dc143c' }}>Status:</strong> 
                  <span style={{
                    marginLeft: '8px',
                    padding: '4px 8px',
                    borderRadius: '4px',
                    fontSize: '12px',
                    fontWeight: 'bold',
                    color: '#fff',
                    backgroundColor: 
                      support.statusMensagem === 'ativa' ? '#ffc107' :
                      support.statusMensagem === 'andamento' ? '#007bff' :
                      support.statusMensagem === 'respondido' ? '#17a2b8' :
                      support.statusMensagem === 'finalizada' ? '#28a745' : '#6c757d'
                  }}>
                    {support.statusMensagem === 'ativa' ? 'Em Análise' :
                     support.statusMensagem === 'andamento' ? 'Em Andamento' :
                     support.statusMensagem === 'respondido' ? 'Respondido' :
                     support.statusMensagem === 'finalizada' ? 'Finalizado' : 'Indefinido'}
                  </span>
                </div>
                <div style={{ marginBottom: '10px' }}>
                  <strong style={{ color: '#dc143c' }}>Mensagem:</strong>
                </div>
                <div className="card" style={{
                  padding: '12px',
                  marginTop: '10px'
                }}>
                  {support.texto}
                </div>
                
                {(() => {
                  const responses = JSON.parse(localStorage.getItem('adminResponses') || '{}');
                  const response = responses[support.id];
                  return response ? (
                    <div style={{ marginTop: '15px' }}>
                      <div style={{ marginBottom: '10px' }}>
                        <strong style={{ color: '#28a745' }}>Resposta do Suporte:</strong>
                      </div>
                      <div className="card" style={{
                        padding: '12px',
                        backgroundColor: '#f0f8f0',
                        border: '1px solid #28a745'
                      }}>
                        {response}
                      </div>
                    </div>
                  ) : (
                    <div style={{ marginTop: '15px', padding: '10px', backgroundColor: '#fff3cd', border: '1px solid #ffeaa7', borderRadius: '4px' }}>
                      <small style={{ color: '#856404' }}>Aguardando resposta do suporte...</small>
                    </div>
                  );
                })()}
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  return (
    <div style={{ maxWidth: 600, margin: '40px auto', fontFamily: 'Segoe UI, sans-serif' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
        <h2 style={{ color: '#dc143c', margin: 0 }}>Suporte</h2>
        {usuarioLogado && (
          <button
            onClick={handleShowMySupports}
            disabled={loadingSupports}
            style={{
              backgroundColor: '#007bff',
              color: '#fff',
              padding: '10px 20px',
              border: 'none',
              borderRadius: '6px',
              cursor: loadingSupports ? 'not-allowed' : 'pointer',
              opacity: loadingSupports ? 0.7 : 1
            }}
          >
            {loadingSupports ? 'Carregando...' : 'Meus Suportes'}
          </button>
        )}
      </div>
      
      {/* Avisos Informativos */}
      <div className="card" style={{ padding: '20px', marginBottom: '20px', backgroundColor: '#e7f3ff', border: '1px solid #b3d9ff' }}>
        <h3 style={{ color: '#0066cc', marginBottom: '15px', fontSize: '18px' }}>ℹ️ Como Podemos Ajudar</h3>
        <div style={{ fontSize: '14px', lineHeight: '1.6' }}>
          <p style={{ marginBottom: '10px' }}>
            <strong>✓ Use este formulário para:</strong> Dúvidas sobre eventos, problemas no site, orientações gerais.
          </p>
          <p style={{ marginBottom: '10px' }}>
            <strong>✉️ Para assuntos mais detalhados:</strong> Envie um email para <strong>suporte@coracaogeneroso.com</strong>
          </p>
          <p style={{ marginBottom: '0' }}>
            <strong>⏰ Nosso compromisso:</strong> Responderemos em até 24 horas
          </p>
        </div>
      </div>
      <div className="card" style={{ padding: '15px', marginBottom: '20px', backgroundColor: '#fff3cd', border: '1px solid #ffeaa7' }}>
        <p style={{ margin: '0', fontSize: '14px', color: '#856404' }}>
          <strong>💡 Importante:</strong> Descreva sua situação com detalhes para que possamos ajudar melhor.
        </p>
      </div>
      
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          name="nome"
          placeholder="Nome"
          value={formData.nome}
          onChange={handleChange}
          style={estiloCampo}
          disabled={sending}
          required
        />
        <input
          type="email"
          name="email"
          placeholder="Email"
          value={formData.email}
          onChange={handleChange}
          style={estiloCampo}
          disabled={sending}
          required
        />
        <input
          type="text"
          name="assunto"
          placeholder="Assunto"
          value={formData.assunto}
          onChange={handleChange}
          style={estiloCampo}
          disabled={sending}
          required
        />
        <textarea
          name="mensagem"
          placeholder="Mensagem"
          value={formData.mensagem}
          onChange={handleChange}
          rows="5"
          style={{ ...estiloCampo, resize: 'vertical' }}
          disabled={sending}
          required
        />
        <button type="submit" style={estiloBotao} disabled={sending}>
          {sending ? 'Enviando...' : 'Enviar'}
        </button>
      </form>
      {feedback && (
        <p style={{
          marginTop: '10px',
          fontWeight: '600',
          color: feedback.includes('sucesso') ? 'green' : 'red',
          textAlign: 'center'
        }}>
          {feedback}
        </p>
      )}
    </div>
  );
};

export default Suporte;
