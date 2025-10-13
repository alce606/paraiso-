// Adicione isso ao seu backend existente
const WebSocket = require('ws');

// Criar servidor WebSocket
const wss = new WebSocket.Server({ port: 8080 });

// Função para notificar Flutter
function notifyFlutter(type, data) {
  const message = JSON.stringify({ type, data });
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

// Nas suas rotas existentes, adicione as notificações:

// Quando criar evento:
// notifyFlutter('evento_created', novoEvento);

// Quando atualizar evento:
// notifyFlutter('evento_updated', eventoAtualizado);

// Quando deletar evento:
// notifyFlutter('evento_deleted', { id: eventoId });