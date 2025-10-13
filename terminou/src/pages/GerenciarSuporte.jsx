import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import MensagemService from '../services/MensagemService';

const GerenciarSuporte = () => {
  const [suportes, setSuportes] = useState([]);
  const [filteredSuportes, setFilteredSuportes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedSupport, setSelectedSupport] = useState(null);
  const [showResponseModal, setShowResponseModal] = useState(false);
  const [responseText, setResponseText] = useState('');
  const [statusFilter, setStatusFilter] = useState('todos');
  const [searchTerm, setSearchTerm] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    loadSuportes();
  }, []);

  const loadSuportes = async () => {
    try {
      const response = await MensagemService.findAll();
      setSuportes(response.data);
      setFilteredSuportes(response.data);
    } catch (error) {
      console.error('Erro ao carregar suportes:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    let filtered = suportes;
    
    // Filtro por status
    if (statusFilter !== 'todos') {
      filtered = filtered.filter(s => s.statusMensagem === statusFilter);
    }
    
    // Filtro por busca
    if (searchTerm) {
      filtered = filtered.filter(s => 
        s.nome.toLowerCase().includes(searchTerm.toLowerCase()) ||
        s.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        s.texto.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }
    
    setFilteredSuportes(filtered);
  }, [suportes, statusFilter, searchTerm]);

  const handleStatusChange = async (id, novoStatus) => {
    try {
      const suporte = suportes.find(s => s.id === id);
      const updatedSupport = { ...suporte, statusMensagem: novoStatus };
      await MensagemService.save(updatedSupport);
      loadSuportes();
    } catch (error) {
      console.error('Erro ao atualizar status:', error);
    }
  };

  const handleDelete = async (id) => {
    if (confirm('Tem certeza que deseja deletar este suporte?')) {
      try {
        await MensagemService.deleteById(id);
        
        // Remover resposta do localStorage também
        const responses = JSON.parse(localStorage.getItem('adminResponses') || '{}');
        delete responses[id];
        localStorage.setItem('adminResponses', JSON.stringify(responses));
        
        loadSuportes();
        alert('Suporte deletado com sucesso!');
      } catch (error) {
        console.error('Erro ao deletar suporte:', error);
        alert('Erro ao deletar suporte.');
      }
    }
  };

  const handleResponse = (suporte) => {
    setSelectedSupport(suporte);
    const responses = JSON.parse(localStorage.getItem('adminResponses') || '{}');
    setResponseText(responses[suporte.id] || '');
    setShowResponseModal(true);
  };

  const sendResponse = async () => {
    if (responseText.trim()) {
      try {
        // Atualizar status para respondido
        const updatedSupport = {
          ...selectedSupport,
          statusMensagem: 'respondido'
        };
        
        // Salvar resposta única
        const responses = JSON.parse(localStorage.getItem('adminResponses') || '{}');
        responses[selectedSupport.id] = responseText;
        localStorage.setItem('adminResponses', JSON.stringify(responses));
        
        await MensagemService.save(updatedSupport);
        loadSuportes();
        
        alert(`Resposta enviada para ${selectedSupport.email}!`);
        
        setShowResponseModal(false);
        setResponseText('');
        setSelectedSupport(null);
      } catch (error) {
        console.error('Erro ao enviar resposta:', error);
        alert('Erro ao enviar resposta.');
      }
    }
  };

  if (loading) {
    return <div style={{ textAlign: 'center', padding: '50px' }}>Carregando...</div>;
  }

  return (
    <div style={{ maxWidth: 1000, margin: '40px auto', fontFamily: 'Segoe UI, sans-serif' }}>
      <div style={{ display: 'flex', alignItems: 'center', marginBottom: '30px' }}>
        <button 
          onClick={() => navigate('/admin/gerenciamento')}
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
        <h2 style={{ color: '#dc143c', margin: 0 }}>Gerenciar Suporte</h2>
      </div>

      {/* Filtros */}
      <div className="card" style={{ padding: '20px', marginBottom: '20px' }}>
        <div style={{ display: 'flex', gap: '15px', alignItems: 'center', flexWrap: 'wrap' }}>
          <div>
            <label style={{ marginRight: '8px', fontWeight: 'bold' }}>Status:</label>
            <select 
              value={statusFilter} 
              onChange={(e) => setStatusFilter(e.target.value)}
              style={{
                padding: '8px',
                borderRadius: '4px',
                border: '1px solid #ddd'
              }}
            >
              <option value="todos">Todos</option>
              <option value="ativa">Em Análise</option>
              <option value="andamento">Em Andamento</option>
              <option value="respondido">Respondido</option>
              <option value="finalizada">Finalizado</option>
            </select>
          </div>
          
          <div style={{ flex: 1, minWidth: '200px' }}>
            <input
              type="text"
              placeholder="Buscar por nome, email ou mensagem..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{
                width: '100%',
                padding: '8px',
                borderRadius: '4px',
                border: '1px solid #ddd'
              }}
            />
          </div>
          
          <div style={{ color: '#666', fontSize: '14px' }}>
            {filteredSuportes.length} de {suportes.length} suportes
          </div>
        </div>
      </div>

      {filteredSuportes.length === 0 ? (
        <p style={{ textAlign: 'center', color: '#666' }}>
          {suportes.length === 0 ? 'Nenhum suporte encontrado.' : 'Nenhum suporte corresponde aos filtros.'}
        </p>
      ) : (
        <div>
          {filteredSuportes.map((suporte) => (
            <div key={suporte.id} className="card" style={{
              padding: '20px',
              marginBottom: '15px'
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '15px' }}>
                <div>
                  <div style={{ marginBottom: '8px' }}>
                    <strong style={{ color: '#dc143c' }}>Nome:</strong> {suporte.nome}
                  </div>
                  <div style={{ marginBottom: '8px' }}>
                    <strong style={{ color: '#dc143c' }}>Email:</strong> {suporte.email}
                  </div>
                  <div style={{ marginBottom: '8px' }}>
                    <strong style={{ color: '#dc143c' }}>Data:</strong> {new Date(suporte.dataMensagem).toLocaleDateString('pt-BR')}
                  </div>
                  <div style={{ marginBottom: '8px' }}>
                    <strong style={{ color: '#dc143c' }}>Status:</strong>
                    <span style={{
                      marginLeft: '8px',
                      padding: '4px 8px',
                      borderRadius: '4px',
                      fontSize: '12px',
                      fontWeight: 'bold',
                      color: '#fff',
                      backgroundColor: 
                        suporte.statusMensagem === 'ativa' ? '#ffc107' :
                        suporte.statusMensagem === 'andamento' ? '#007bff' :
                        suporte.statusMensagem === 'respondido' ? '#17a2b8' :
                        suporte.statusMensagem === 'finalizada' ? '#28a745' : '#6c757d'
                    }}>
                      {suporte.statusMensagem === 'ativa' ? 'Em Análise' :
                       suporte.statusMensagem === 'andamento' ? 'Em Andamento' :
                       suporte.statusMensagem === 'respondido' ? 'Respondido' :
                       suporte.statusMensagem === 'finalizada' ? 'Finalizado' : 'Indefinido'}
                    </span>
                  </div>
                </div>
                <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
                  <button
                    onClick={() => handleStatusChange(suporte.id, 'ativa')}
                    style={{
                      padding: '6px 12px',
                      backgroundColor: suporte.statusMensagem === 'ativa' ? '#ffc107' : '#e9ecef',
                      color: suporte.statusMensagem === 'ativa' ? '#000' : '#6c757d',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer',
                      fontSize: '12px'
                    }}
                  >
                    🔍 Análise
                  </button>
                  <button
                    onClick={() => handleStatusChange(suporte.id, 'andamento')}
                    style={{
                      padding: '6px 12px',
                      backgroundColor: suporte.statusMensagem === 'andamento' ? '#007bff' : '#e9ecef',
                      color: suporte.statusMensagem === 'andamento' ? '#fff' : '#6c757d',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer',
                      fontSize: '12px'
                    }}
                  >
                    ⏳ Andamento
                  </button>
                  <button
                    onClick={() => handleStatusChange(suporte.id, 'respondido')}
                    style={{
                      padding: '6px 12px',
                      backgroundColor: suporte.statusMensagem === 'respondido' ? '#17a2b8' : '#e9ecef',
                      color: suporte.statusMensagem === 'respondido' ? '#fff' : '#6c757d',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer',
                      fontSize: '12px'
                    }}
                  >
                    💬 Respondido
                  </button>
                  <button
                    onClick={() => handleStatusChange(suporte.id, 'finalizada')}
                    style={{
                      padding: '6px 12px',
                      backgroundColor: suporte.statusMensagem === 'finalizada' ? '#28a745' : '#e9ecef',
                      color: suporte.statusMensagem === 'finalizada' ? '#fff' : '#6c757d',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer',
                      fontSize: '12px'
                    }}
                  >
                    ✅ Finalizado
                  </button>
                  <button
                    onClick={() => handleResponse(suporte)}
                    style={{
                      padding: '6px 12px',
                      backgroundColor: '#6f42c1',
                      color: '#fff',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer',
                      fontSize: '12px'
                    }}
                  >
                    📝 Responder
                  </button>
                  <button
                    onClick={() => handleDelete(suporte.id)}
                    style={{
                      padding: '6px 12px',
                      backgroundColor: '#dc3545',
                      color: '#fff',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer',
                      fontSize: '12px'
                    }}
                  >
                    🗑️ Deletar
                  </button>
                </div>
              </div>
              
              <div style={{ marginBottom: '10px' }}>
                <strong style={{ color: '#dc143c' }}>Mensagem:</strong>
              </div>
              <div className="card" style={{
                padding: '15px',
                marginTop: '10px'
              }}>
                {suporte.texto}
              </div>
              
              {(() => {
                const responses = JSON.parse(localStorage.getItem('adminResponses') || '{}');
                const response = responses[suporte.id];
                return response ? (
                  <div style={{ marginTop: '15px' }}>
                    <div style={{ marginBottom: '10px' }}>
                      <strong style={{ color: '#28a745' }}>Resposta do Admin:</strong>
                    </div>
                    <div className="card" style={{
                      padding: '15px',
                      backgroundColor: '#f0f8f0',
                      border: '1px solid #28a745'
                    }}>
                      {response}
                    </div>
                  </div>
                ) : null;
              })()}
            </div>
          ))}
        </div>
      )}
      
      {/* Modal de Resposta */}
      {showResponseModal && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          width: '100%',
          height: '100%',
          backgroundColor: 'rgba(0,0,0,0.5)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000
        }}>
          <div className="card" style={{
            width: '500px',
            maxWidth: '90%',
            padding: '20px'
          }}>
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>
              {(() => {
                const responses = JSON.parse(localStorage.getItem('adminResponses') || '{}');
                return responses[selectedSupport?.id] ? 'Editar Resposta' : 'Responder Suporte';
              })()} 
            </h3>
            <p><strong>Para:</strong> {selectedSupport?.email}</p>
            <p><strong>Assunto:</strong> Re: Suporte - {selectedSupport?.nome}</p>
            
            <textarea
              value={responseText}
              onChange={(e) => setResponseText(e.target.value)}
              placeholder="Digite sua resposta como administrador..."
              style={{
                width: '100%',
                height: '150px',
                padding: '10px',
                border: '1px solid #ddd',
                borderRadius: '4px',
                marginTop: '10px',
                marginBottom: '15px',
                resize: 'vertical'
              }}
            />
            
            <div style={{ display: 'flex', gap: '10px', justifyContent: 'flex-end' }}>
              <button
                onClick={() => {
                  setShowResponseModal(false);
                  setResponseText('');
                  setSelectedSupport(null);
                }}
                style={{
                  padding: '10px 20px',
                  backgroundColor: '#6c757d',
                  color: '#fff',
                  border: 'none',
                  borderRadius: '4px',
                  cursor: 'pointer'
                }}
              >
                Cancelar
              </button>
              <button
                onClick={sendResponse}
                disabled={!responseText.trim()}
                style={{
                  padding: '10px 20px',
                  backgroundColor: '#28a745',
                  color: '#fff',
                  border: 'none',
                  borderRadius: '4px',
                  cursor: 'pointer',
                  opacity: !responseText.trim() ? 0.5 : 1
                }}
              >
                {(() => {
                  const responses = JSON.parse(localStorage.getItem('adminResponses') || '{}');
                  return responses[selectedSupport?.id] ? 'Atualizar Resposta' : 'Enviar Resposta';
                })()}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default GerenciarSuporte;