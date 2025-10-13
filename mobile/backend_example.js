// Exemplo para seu sistema web (Node.js + Express + WebSocket)
const express = require('express');
const WebSocket = require('ws');
const app = express();

// WebSocket Server
const wss = new WebSocket.Server({ port: 8080 });

// Broadcast para todos os clientes conectados
function broadcast(message) {
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(message));
    }
  });
}

// Rotas da API
app.post('/api/eventos', (req, res) => {
  // Criar evento no banco
  const novoEvento = criarEvento(req.body);
  
  // Notificar Flutter via WebSocket
  broadcast({
    type: 'evento_created',
    data: novoEvento
  });
  
  res.json(novoEvento);
});

app.put('/api/eventos/:id', (req, res) => {
  // Atualizar evento no banco
  const eventoAtualizado = atualizarEvento(req.params.id, req.body);
  
  // Notificar Flutter via WebSocket
  broadcast({
    type: 'evento_updated',
    data: eventoAtualizado
  });
  
  res.json(eventoAtualizado);
});

app.delete('/api/eventos/:id', (req, res) => {
  // Deletar evento do banco
  deletarEvento(req.params.id);
  
  // Notificar Flutter via WebSocket
  broadcast({
    type: 'evento_deleted',
    data: { id: req.params.id }
  });
  
  res.status(204).send();
});