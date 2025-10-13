import { api } from '../config/api';

export const chatService = {
  // Salvar conversa do chatbot
  saveConversation: async (messages, userInfo) => {
    try {
      const response = await api.post('/chat/conversation', {
        messages,
        userInfo,
        timestamp: new Date().toISOString(),
        status: 'active'
      });
      return response.data;
    } catch (error) {
      console.error('Erro ao salvar conversa:', error);
      throw error;
    }
  },

  // Transferir para administrador
  transferToAdmin: async (conversationId, reason) => {
    try {
      const response = await api.post('/chat/transfer-admin', {
        conversationId,
        reason,
        timestamp: new Date().toISOString()
      });
      return response.data;
    } catch (error) {
      console.error('Erro ao transferir para admin:', error);
      throw error;
    }
  },

  // Buscar conversas pendentes (para admin)
  getPendingConversations: async () => {
    try {
      const response = await api.get('/chat/pending');
      return response.data;
    } catch (error) {
      console.error('Erro ao buscar conversas pendentes:', error);
      throw error;
    }
  },

  // Responder como admin
  adminReply: async (conversationId, message) => {
    try {
      const response = await api.post('/chat/admin-reply', {
        conversationId,
        message,
        timestamp: new Date().toISOString()
      });
      return response.data;
    } catch (error) {
      console.error('Erro ao responder como admin:', error);
      throw error;
    }
  }
};