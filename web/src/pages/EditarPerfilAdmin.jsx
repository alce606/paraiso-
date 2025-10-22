import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const EditarPerfilAdmin = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [formData, setFormData] = useState({
    nome: '',
    email: ''
  });
  const [foto, setFoto] = useState(null);

  useEffect(() => {
    carregarPerfil();
  }, []);

  const carregarPerfil = async () => {
    try {
      setLoading(true);
      const currentUser = UsuarioService.getCurrentUser();
      if (currentUser) {
        const response = await UsuarioService.findById(currentUser.id);
        setFormData({
          nome: response.data.nome || '',
          email: response.data.email || ''
        });
      }
    } catch (error) {
      console.error('Erro ao carregar perfil:', error);
      alert('Erro ao carregar dados do perfil');
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleFileChange = (e) => {
    setFoto(e.target.files[0]);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const currentUser = UsuarioService.getCurrentUser();
      const dataToSend = { ...formData };
      if (foto) {
        dataToSend.foto = foto;
      }
      
      await UsuarioService.update(currentUser.id, dataToSend);
      alert('Perfil alterado com sucesso!');
      navigate('/admin/perfil');
    } catch (error) {
      console.error('Erro ao alterar perfil:', error);
      alert('Erro ao alterar perfil');
    }
  };

  if (loading) {
    return (
      <div className="container">
        <div className="card" style={{ textAlign: 'center', padding: '50px' }}>
          <p>Carregando dados do perfil...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="container">
      <div style={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        minHeight: '70vh' 
      }}>
        <div className="card" style={{ width: '100%', maxWidth: '500px' }}>
          <div style={{ textAlign: 'center', marginBottom: '30px' }}>
            <span style={{ fontSize: '3rem' }}>✏️</span>
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Editar Perfil</h1>
            <p style={{ color: '#666', marginTop: '10px' }}>
              Alterar suas informações pessoais
            </p>
          </div>

          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Nome</label>
              <input
                type="text"
                name="nome"
                value={formData.nome}
                onChange={handleChange}
                placeholder="Seu nome"
                required
              />
            </div>

            <div className="form-group">
              <label>Email</label>
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                placeholder="seu@email.com"
                required
              />
            </div>

            <div className="form-group">
              <label>Foto (opcional)</label>
              <input
                type="file"
                accept="image/*"
                onChange={handleFileChange}
              />
            </div>

            <div style={{ display: 'flex', gap: '10px', marginTop: '20px' }}>
              <button 
                type="submit" 
                className="btn btn-primary" 
                style={{ flex: 1 }}
              >
                Salvar Alterações
              </button>
              <button 
                type="button" 
                onClick={() => navigate('/admin/perfil')}
                style={{
                  flex: 1,
                  padding: '12px',
                  background: '#6c757d',
                  color: 'white',
                  border: 'none',
                  borderRadius: '5px',
                  cursor: 'pointer'
                }}
              >
                Cancelar
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default EditarPerfilAdmin;