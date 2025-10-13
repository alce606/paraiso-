import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const GerenciarUsuarios = () => {
  const navigate = useNavigate();
  const [usuarios, setUsuarios] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filtro, setFiltro] = useState('');
  const [tipoFiltro, setTipoFiltro] = useState('todos');

  useEffect(() => {
    carregarUsuarios();
  }, []);

  const carregarUsuarios = async () => {
    try {
      setLoading(true);
      const response = await UsuarioService.findAll();
      setUsuarios(response.data || []);
    } catch (error) {
      console.error('Erro ao carregar usuários:', error);
      setUsuarios([]);
    } finally {
      setLoading(false);
    }
  };

  const alterarStatus = async (id, statusAtual) => {
    try {
      if (statusAtual === 'ATIVO') {
        await UsuarioService.inativar(id);
      } else {
        await UsuarioService.reativar(id);
      }
      carregarUsuarios();
    } catch (error) {
      console.error('Erro ao alterar status:', error);
    }
  };

  const deletarUsuario = async (id) => {
    if (window.confirm('Tem certeza que deseja deletar este usuário? Esta ação não pode ser desfeita.')) {
      try {
        await UsuarioService.deletar(id);
        carregarUsuarios();
      } catch (error) {
        console.error('Erro ao deletar usuário:', error);
      }
    }
  };

  const usuariosFiltrados = usuarios.filter(usuario => {
    const matchNome = usuario.nome?.toLowerCase().includes(filtro.toLowerCase());
    const matchEmail = usuario.email?.toLowerCase().includes(filtro.toLowerCase());
    const matchTipo = tipoFiltro === 'todos' || usuario.nivelAcesso === tipoFiltro;
    return (matchNome || matchEmail) && matchTipo;
  });

  return (
    <div className="container">
      <div className="card">
        <div style={{ textAlign: 'center', marginBottom: '30px' }}>
          <span style={{ fontSize: '3rem' }}>👥</span>
          <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Gerenciar Usuários</h1>
          <p style={{ color: '#666', fontSize: '1.1rem' }}>Administrar usuários do sistema</p>
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
            placeholder="Buscar por nome ou email..."
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
            value={tipoFiltro}
            onChange={(e) => setTipoFiltro(e.target.value)}
            style={{
              padding: '10px',
              border: '1px solid #ddd',
              borderRadius: '5px'
            }}
          >
            <option value="todos">Todos os tipos</option>
            <option value="USER">Usuários</option>
            <option value="ADMIN">Administradores</option>
          </select>
        </div>

        {/* Lista de usuários */}
        {loading ? (
          <div style={{ textAlign: 'center', padding: '50px' }}>
            <p>Carregando usuários...</p>
          </div>
        ) : (
          <div style={{ marginBottom: '20px' }}>
            <h3 style={{ color: '#333', marginBottom: '15px' }}>
              {usuariosFiltrados.length} usuário(s) encontrado(s)
            </h3>
            
            {usuariosFiltrados.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '30px', color: '#666' }}>
                <p>Nenhum usuário encontrado</p>
              </div>
            ) : (
              usuariosFiltrados.map(usuario => (
                <div 
                  key={usuario.id}
                  className="card"
                  style={{ 
                    marginBottom: '15px',
                    background: usuario.statusUsuario === 'ATIVO' ? '#f8fff8' : '#fff8f8'
                  }}
                >
                  <div style={{ 
                    display: 'flex', 
                    justifyContent: 'space-between', 
                    alignItems: 'center',
                    flexWrap: 'wrap',
                    gap: '10px'
                  }}>
                    <div style={{ flex: 1, minWidth: '200px' }}>
                      <h4 style={{ margin: '0 0 5px 0', color: '#333' }}>{usuario.nome}</h4>
                      <p style={{ margin: '0 0 5px 0', color: '#666' }}>{usuario.email}</p>
                      {usuario.telefone && (
                        <p style={{ margin: '0 0 5px 0', color: '#666', fontSize: '0.9rem' }}>
                          📞 {usuario.telefone}
                        </p>
                      )}
                      <p style={{ margin: '0', color: '#666', fontSize: '0.9rem' }}>
                        Cadastro: {new Date(usuario.dataCadastro).toLocaleDateString('pt-BR')}
                      </p>
                    </div>
                    
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                      <span style={{
                        padding: '4px 8px',
                        borderRadius: '12px',
                        fontSize: '0.8rem',
                        background: usuario.nivelAcesso === 'ADMIN' ? '#dc143c' : '#007bff',
                        color: 'white'
                      }}>
                        {usuario.nivelAcesso || 'USER'}
                      </span>
                      
                      <span style={{
                        padding: '4px 8px',
                        borderRadius: '12px',
                        fontSize: '0.8rem',
                        background: usuario.statusUsuario === 'ATIVO' ? '#28a745' : 
                                   usuario.statusUsuario === 'INATIVO' ? '#dc3545' : '#ffc107',
                        color: 'white'
                      }}>
                        {usuario.statusUsuario}
                      </span>
                    </div>
                    
                    <div style={{ display: 'flex', gap: '5px' }}>
                      <button
                        onClick={() => navigate(`/admin/usuarios/editar/${usuario.id}`)}
                        style={{
                          padding: '5px 10px',
                          background: '#007bff',
                          color: 'white',
                          border: 'none',
                          borderRadius: '3px',
                          cursor: 'pointer',
                          fontSize: '0.8rem'
                        }}
                      >
                        Editar
                      </button>
                      <button
                        onClick={() => alterarStatus(usuario.id, usuario.statusUsuario)}
                        style={{
                          padding: '5px 10px',
                          background: usuario.statusUsuario === 'ATIVO' ? '#ffc107' : '#28a745',
                          color: 'white',
                          border: 'none',
                          borderRadius: '3px',
                          cursor: 'pointer',
                          fontSize: '0.8rem'
                        }}
                      >
                        {usuario.statusUsuario === 'ATIVO' ? 'Inativar' : 'Ativar'}
                      </button>
                      <button
                        onClick={() => deletarUsuario(usuario.id)}
                        style={{
                          padding: '5px 10px',
                          background: '#dc3545',
                          color: 'white',
                          border: 'none',
                          borderRadius: '3px',
                          cursor: 'pointer',
                          fontSize: '0.8rem'
                        }}
                      >
                        Deletar
                      </button>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        )}

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

export default GerenciarUsuarios;