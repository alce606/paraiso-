import React, { useState, useEffect, useRef } from 'react';
import MensagemService from '../services/MensagemService';
import UsuarioService from '../services/UsuarioService';

const ChatBot = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState([]);
  const [inputValue, setInputValue] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [waitingForAdmin, setWaitingForAdmin] = useState(false);
  const [isVisible, setIsVisible] = useState(true);
  const [isDarkTheme, setIsDarkTheme] = useState(false);

  useEffect(() => {
    const checkChatbotConfig = () => {
      const config = JSON.parse(localStorage.getItem('siteConfig') || '{}');
      setIsVisible(config.chatbot !== false);
      setIsDarkTheme(config.tema === 'escuro');
    };
    
    checkChatbotConfig();
    window.addEventListener('configChanged', checkChatbotConfig);
    
    return () => window.removeEventListener('configChanged', checkChatbotConfig);
  }, []);

  if (!isVisible) return null;
  const messagesEndRef = useRef(null);

  const botResponses = {
    greeting: [
      "Olá! Sou o assistente virtual do Coração Generoso. Como posso ajudá-lo hoje?",
      "Oi! Bem-vindo ao suporte do Coração Generoso. Em que posso ajudar?"
    ],
    events: [
      "Para criar um evento, acesse a página 'Criar Evento' no menu principal. Você precisará estar logado em sua conta.",
      "Você pode visualizar todos os eventos disponíveis na página 'Eventos'. Lá você encontra detalhes e pode se inscrever."
    ],
    registration: [
      "Para se cadastrar, clique em 'Cadastro' no menu superior e preencha seus dados.",
      "O cadastro é gratuito e permite que você participe de eventos e ações solidárias."
    ],
    login: [
      "Se você esqueceu sua senha, entre em contato conosco pelo email suporte@coracaogeneroso.com.br",
      "Para fazer login, clique em 'Login' no menu superior e use seu email e senha."
    ],
    donation: [
      "Você pode fazer doações através dos eventos cadastrados na plataforma.",
      "Todas as doações são destinadas às causas sociais cadastradas em nossa plataforma."
    ],
    contact: [
      "Nosso email de contato é: suporte@coracaogeneroso.com.br",
      "WhatsApp: (11) 99999-9999 | Horário: Segunda a Sexta 8h-18h, Sábado 8h-12h"
    ],
    default: [
      "Desculpe, não entendi sua pergunta. Posso ajudar com: eventos, cadastro, login, doações ou contato.",
      "Não consegui compreender. Você gostaria de falar com um administrador?"
    ]
  };

  useEffect(() => {
    if (isOpen && messages.length === 0) {
      addBotMessage(getRandomResponse('greeting'));
    }
  }, [isOpen]);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  const getRandomResponse = (category) => {
    const responses = botResponses[category];
    return responses[Math.floor(Math.random() * responses.length)];
  };

  const addBotMessage = (message) => {
    setIsTyping(true);
    setTimeout(() => {
      setMessages(prev => [...prev, { text: message, sender: 'bot', timestamp: new Date() }]);
      setIsTyping(false);
    }, 1000);
  };

  const addUserMessage = (message) => {
    setMessages(prev => [...prev, { text: message, sender: 'user', timestamp: new Date() }]);
  };

  const analyzeMessage = (message) => {
    const lowerMessage = message.toLowerCase();
    
    if (lowerMessage.includes('evento') || lowerMessage.includes('criar') || lowerMessage.includes('participar')) {
      return 'events';
    }
    if (lowerMessage.includes('cadastr') || lowerMessage.includes('registr') || lowerMessage.includes('conta')) {
      return 'registration';
    }
    if (lowerMessage.includes('login') || lowerMessage.includes('senha') || lowerMessage.includes('entrar')) {
      return 'login';
    }
    if (lowerMessage.includes('doa') || lowerMessage.includes('contribui') || lowerMessage.includes('ajud')) {
      return 'donation';
    }
    if (lowerMessage.includes('contato') || lowerMessage.includes('telefone') || lowerMessage.includes('email')) {
      return 'contact';
    }
    if (lowerMessage.includes('admin') || lowerMessage.includes('humano') || lowerMessage.includes('pessoa')) {
      return 'admin';
    }
    
    return 'default';
  };

  const handleSendMessage = () => {
    if (!inputValue.trim() || waitingForAdmin) return;

    addUserMessage(inputValue);
    const category = analyzeMessage(inputValue);
    
    if (category === 'admin') {
      setWaitingForAdmin(true);
      addBotMessage("Entendi que você gostaria de falar com um administrador. Estou transferindo você agora. Um de nossos atendentes entrará em contato em breve!");
      
      // Salvar solicitação para admin
      saveAdminRequest(inputValue);
      
      setTimeout(() => {
        addBotMessage("Sua solicitação foi encaminhada para nossa equipe. Você receberá um retorno por email em até 24 horas.");
      }, 2000);
    } else {
      addBotMessage(getRandomResponse(category));
      
      if (category === 'default') {
        setTimeout(() => {
          addBotMessage("Se não consegui resolver sua dúvida, digite 'admin' para falar com um atendente humano.");
        }, 2000);
      }
    }
    
    setInputValue('');
  };

  const saveAdminRequest = async (userMessage) => {
    try {
      const usuario = UsuarioService.getCurrentUser();
      const conversationHistory = messages.map(msg => 
        `${msg.sender === 'user' ? 'Usuário' : 'Bot'}: ${msg.text}`
      ).join('\n');
      
      const adminRequest = {
        dataMensagem: new Date().toISOString(),
        nome: usuario?.nome || 'Usuário Anônimo',
        email: usuario?.email || 'nao-informado@chatbot.com',
        telefone: usuario?.telefone || '',
        texto: `SOLICITAÇÃO VIA CHATBOT:\n\nÚltima mensagem: ${userMessage}\n\nHistórico da conversa:\n${conversationHistory}`,
        statusMensagem: 'ativa',
        usuario: { id: usuario?.id || 1 }
      };
      
      await MensagemService.save(adminRequest);
    } catch (error) {
      console.error('Erro ao salvar solicitação:', error);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleSendMessage();
    }
  };

  return (
    <>
      {/* Botão flutuante do chat */}
      <div 
        style={{
          position: 'fixed',
          bottom: '20px',
          right: '20px',
          zIndex: 1000,
          cursor: 'pointer'
        }}
        onClick={() => setIsOpen(!isOpen)}
      >
        <div style={{
          width: '60px',
          height: '60px',
          backgroundColor: '#dc143c',
          borderRadius: '50%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          color: 'white',
          fontSize: '24px',
          boxShadow: '0 4px 12px rgba(0,0,0,0.3)',
          transition: 'transform 0.3s ease'
        }}>
          {isOpen ? '✕' : '💬'}
        </div>
      </div>

      {/* Janela do chat */}
      {isOpen && (
        <div style={{
          position: 'fixed',
          bottom: '90px',
          right: '20px',
          width: '350px',
          height: '500px',
          backgroundColor: isDarkTheme ? '#2a2a2a' : 'white',
          borderRadius: '12px',
          boxShadow: '0 8px 32px rgba(0,0,0,0.3)',
          zIndex: 1000,
          display: 'flex',
          flexDirection: 'column',
          overflow: 'hidden'
        }}>
          {/* Header do chat */}
          <div style={{
            backgroundColor: '#dc143c',
            color: 'white',
            padding: '15px',
            textAlign: 'center',
            fontWeight: 'bold'
          }}>
            🤖 Assistente Virtual
          </div>

          {/* Área de mensagens */}
          <div style={{
            flex: 1,
            padding: '15px',
            overflowY: 'auto',
            backgroundColor: isDarkTheme ? '#1e1e1e' : '#f9f9f9'
          }}>
            {messages.map((message, index) => (
              <div key={index} style={{
                marginBottom: '10px',
                display: 'flex',
                justifyContent: message.sender === 'user' ? 'flex-end' : 'flex-start'
              }}>
                <div style={{
                  maxWidth: '80%',
                  padding: '10px 15px',
                  borderRadius: '18px',
                  backgroundColor: message.sender === 'user' ? '#dc143c' : (isDarkTheme ? '#404040' : '#e0e0e0'),
                  color: message.sender === 'user' ? 'white' : (isDarkTheme ? '#e0e0e0' : 'black'),
                  fontSize: '14px',
                  lineHeight: '1.4'
                }}>
                  {message.text}
                </div>
              </div>
            ))}
            
            {isTyping && (
              <div style={{
                display: 'flex',
                justifyContent: 'flex-start',
                marginBottom: '10px'
              }}>
                <div style={{
                  padding: '10px 15px',
                  borderRadius: '18px',
                  backgroundColor: isDarkTheme ? '#404040' : '#e0e0e0',
                  color: isDarkTheme ? '#e0e0e0' : 'black',
                  fontSize: '14px'
                }}>
                  Digitando...
                </div>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>

          {/* Input de mensagem */}
          <div style={{
            padding: '15px',
            borderTop: isDarkTheme ? '1px solid #444' : '1px solid #eee',
            display: 'flex',
            gap: '10px'
          }}>
            <input
              type="text"
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder={waitingForAdmin ? "Aguardando admin..." : "Digite sua mensagem..."}
              disabled={waitingForAdmin}
              style={{
                flex: 1,
                padding: '10px',
                border: isDarkTheme ? '1px solid #444' : '1px solid #ddd',
                borderRadius: '20px',
                outline: 'none',
                fontSize: '14px',
                backgroundColor: isDarkTheme ? '#404040' : 'white',
                color: isDarkTheme ? '#e0e0e0' : 'black'
              }}
            />
            <button
              onClick={handleSendMessage}
              disabled={!inputValue.trim() || waitingForAdmin}
              style={{
                padding: '10px 15px',
                backgroundColor: '#dc143c',
                color: 'white',
                border: 'none',
                borderRadius: '20px',
                cursor: 'pointer',
                fontSize: '14px',
                opacity: (!inputValue.trim() || waitingForAdmin) ? 0.5 : 1
              }}
            >
              Enviar
            </button>
          </div>
        </div>
      )}
    </>
  );
};

export default ChatBot;