import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const EditarUsuario = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [loading, setLoading] = useState(true);
  const currentUser = UsuarioService.getCurrentUser();
  const [formData, setFormData] = useState({
    nome: '',
    email: '',
    nivelAcesso: 'USER',
    statusUsuario: 'ATIVO'
  });
  const [foto, setFoto] = useState(null);
  const [novaSenha, setNovaSenha] = useState('');
  const [alterarSenha, setAlterarSenha] = useState(false);

  const validatePassword = (senha) => {
    const minLength = 8;
    const hasUpperCase = /[A-Z]/.test(senha);
    const hasLowerCase = /[a-z]/.test(senha);
    const hasNumbers = /\d/.test(senha);
    const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(senha);
    
    if (senha.length < minLength) {
      return 'A senha deve ter pelo menos 8 caracteres.';
    }
    if (!hasUpperCase) {
      return 'A senha deve conter pelo menos uma letra maiúscula.';
    }
    if (!hasLowerCase) {
      return 'A senha deve conter pelo menos uma letra minúscula.';
    }
    if (!hasNumbers) {
      return 'A senha deve conter pelo menos um número.';
    }
    if (!hasSpecialChar) {
      return 'A senha deve conter pelo menos um caractere especial (!@#$%^&*(),.?":{}|<>).';
    }
    return null;
  };

  useEffect(() => {
    carregarUsuario();
  }, [id]);

  const carregarUsuario = async () => {
    try {
      setLoading(true);
      const response = await UsuarioService.findById(id);
      setFormData({
        nome: response.data.nome || '',
        email: response.data.email || '',
        nivelAcesso: response.data.nivelAcesso || 'USER',
        statusUsuario: response.data.statusUsuario || 'ATIVO'
      });
    } catch (error) {
      console.error('Erro ao carregar usuário:', error);
      alert('Erro ao carregar dados do usuário');
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
    
    if (!formData.nome.trim()) {
      alert('Nome é obrigatório');
      return;
    }
    
    if (alterarSenha) {
      if (!novaSenha.trim()) {
        alert('Nova senha é obrigatória');
        return;
      }
      
      const passwordError = validatePassword(novaSenha);
      if (passwordError) {
        alert(passwordError);
        return;
      }
    }
    
    try {
      const dataToSend = { ...formData };
      if (foto) {
        dataToSend.foto = foto;
      }
      
      await UsuarioService.alterar(id, dataToSend);
      
      if (alterarSenha && novaSenha) {
        await UsuarioService.alterarSenha(id, { senha: novaSenha });
      }
      
      alert('Usuário alterado com sucesso!');
      navigate('/admin/usuarios');
    } catch (error) {
      console.error('Erro:', error);
      alert(error.response?.data?.message || 'Erro ao alterar usuário');
    }
  };

  if (loading) {
    return (
      <div className="container">
        <div className="card" style={{ textAlign: 'center', padding: '50px' }}>
          <p>Carregando dados do usuário...</p>
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
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Editar Usuário</h1>
            <p style={{ color: '#666', marginTop: '10px' }}>
              Alterar informações do usuário
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
                placeholder="Nome do usuário"
                required
              />
            </div>

            <div className="form-group">
              <label>Email</label>
              <input
                type="email"
                name="email"
                value={formData.email}
                placeholder="email@exemplo.com"
                disabled
                style={{ backgroundColor: '#f5f5f5', cursor: 'not-allowed' }}
              />
            </div>

            <div className="form-group">
              <label>Nível de Acesso</label>
              <select
                name="nivelAcesso"
                value={formData.nivelAcesso}
                onChange={handleChange}
                required
              >
                <option value="USER">Usuário</option>
                <option value="ADMIN">Administrador</option>
              </select>
            </div>

            <div className="form-group">
              <label>Status</label>
              <select
                name="statusUsuario"
                value={formData.statusUsuario}
                onChange={handleChange}
                required
              >
                <option value="ATIVO">Ativo</option>
                <option value="INATIVO">Inativo</option>
                <option value="TROCAR_SENHA">Trocar Senha</option>
              </select>
            </div>

            <div className="form-group">
              <label>Foto (opcional)</label>
              <input
                type="file"
                accept="image/*"
                onChange={handleFileChange}
              />
            </div>

            <div className="form-group">
              <label>
                <input
                  type="checkbox"
                  checked={alterarSenha}
                  onChange={(e) => setAlterarSenha(e.target.checked)}
                  style={{ marginRight: '8px' }}
                />
                Alterar senha
              </label>
            </div>

            {alterarSenha && (
              <div className="form-group">
                <label>Nova Senha</label>
                <input
                  type="password"
                  value={novaSenha}
                  onChange={(e) => setNovaSenha(e.target.value)}
                  placeholder="Digite a nova senha"
                  required={alterarSenha}
                />
                <small style={{ color: '#666', fontSize: '0.8rem', display: 'block', marginTop: '5px' }}>
                  Mínimo 8 caracteres, incluindo: maiúscula, minúscula, número e caractere especial
                </small>
              </div>
            )}

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
                onClick={() => navigate('/admin/usuarios')}
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

export default EditarUsuario;