import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';
import logo from '../assets/images/blz_perfil.png';

const PerfilUsuario = () => {
  const navigate = useNavigate();
  const [editMode, setEditMode] = useState(false);
  const [userData, setUserData] = useState({
    nome: '',
    email: '',
    foto: null
  });
  const [foto, setFoto] = useState(null);
  const [novaSenha, setNovaSenha] = useState('');
  const [alterarSenha, setAlterarSenha] = useState(false);
  const [errors, setErrors] = useState({});

  useEffect(() => {
    carregarPerfil();
  }, []);

  const carregarPerfil = async () => {
    try {
      const currentUser = UsuarioService.getCurrentUser();
      if (currentUser) {
        const response = await UsuarioService.findById(currentUser.id);
        setUserData({
          nome: response.data.nome || '',
          email: response.data.email || '',
          foto: response.data.foto || null
        });
      }
    } catch (error) {
      console.error('Erro ao carregar perfil:', error);
    }
  };

  const handleEdit = () => {
    setEditMode(!editMode);
  };

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

  const validateForm = () => {
    const newErrors = {};
    
    if (!userData.nome) {
      newErrors.nome = 'Nome é obrigatório';
    }
    
    if (alterarSenha) {
      if (!novaSenha) {
        newErrors.novaSenha = 'Nova senha é obrigatória';
      } else {
        const passwordError = validatePassword(novaSenha);
        if (passwordError) {
          newErrors.novaSenha = passwordError;
        }
      }
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSave = async () => {
    if (!validateForm()) {
      return;
    }
    
    try {
      const currentUser = UsuarioService.getCurrentUser();
      await UsuarioService._alterar(foto, currentUser.id, userData);
      
      if (alterarSenha && novaSenha.trim()) {
        try {
          await UsuarioService.alterarSenha(currentUser.email, novaSenha.trim());
        } catch (error) {
          console.error('Erro ao alterar a senha no perfil usuario:', error);
          alert('Erro ao alterar senha. Verifique se a senha atende aos requisitos.');
          return;
        }
      }
      
      // Atualiza o localStorage com os novos dados
      const updatedUser = { ...currentUser, nome: userData.nome, email: userData.email };
      UsuarioService.updateCurrentUser(updatedUser);
      
      setEditMode(false);
      alert('Perfil atualizado com sucesso!');
    } catch (error) {
      console.error('Erro ao atualizar perfil:', error);
      alert('Erro ao atualizar perfil');
    }
  };

  const handleChange = (e) => {
    setUserData({
      ...userData,
      [e.target.name]: e.target.value
    });
  };

  const handleLogout = () => {
    localStorage.removeItem('userType');
    // Dispara evento para atualizar Header
    window.dispatchEvent(new Event('userTypeChanged'));
    alert('Logout realizado com sucesso!');
    navigate('/');
  };

  return (
    <div className="container">
      <div className="card">
        <div style={{ textAlign: 'center', marginBottom: '30px' }}>
          {userData.foto ? (
            <img 
              src={userData.foto ? 'data:image/jpeg;base64,' + userData.foto : logo}
              alt="Foto do Usuário" 
              style={{
                width: '120px',
                height: '120px',
                borderRadius: '50%',
                objectFit: 'cover',
                border: '3px solid #dc143c'
              }}
            />
          ) : (
            <div style={{ 
              width: '120px', 
              height: '120px', 
              borderRadius: '50%', 
              backgroundColor: '#f0f0f0', 
              border: '3px solid #dc143c',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '14px',
              color: '#666'
            }}>
              Sem foto
            </div>
          )}
          <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Meu Perfil</h1>
          <p style={{ color: '#666' }}>Gerencie suas informações pessoais</p>
        </div>

        <div style={{ maxWidth: '500px', margin: '0 auto' }}>
          <div className="form-group">
            <label>Nome Completo</label>
            <input
              type="text"
              name="nome"
              value={userData.nome}
              onChange={handleChange}
              disabled={!editMode}
              style={{ 
                background: editMode ? 'white' : '#f5f5f5',
                cursor: editMode ? 'text' : 'not-allowed',
                border: `1px solid ${errors.nome ? '#dc3545' : '#ddd'}`
              }}
            />
            {errors.nome && (
              <div style={{ color: '#dc3545', fontSize: '14px', marginTop: '5px' }}>
                {errors.nome}
              </div>
            )}
          </div>

          <div className="form-group">
            <label>Email</label>
            <input
              type="email"
              name="email"
              value={userData.email}
              onChange={handleChange}
              disabled={!editMode}
              style={{ 
                background: editMode ? 'white' : '#f5f5f5',
                cursor: editMode ? 'text' : 'not-allowed'
              }}
              readOnly
            />
          </div>

          {editMode && (
            <>
              <div className="form-group">
                <label>Foto (opcional)</label>
                <input
                  type="file"
                  accept="image/*"
                  onChange={(e) => setFoto(e.target.files[0])}
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
                    style={{
                      border: `1px solid ${errors.novaSenha ? '#dc3545' : '#ddd'}`
                    }}
                  />
                  <small style={{ color: '#666', fontSize: '0.8rem', display: 'block', marginTop: '5px' }}>
                    Mínimo 8 caracteres, incluindo: maiúscula, minúscula, número e caractere especial
                  </small>
                  {errors.novaSenha && (
                    <div style={{ color: '#dc3545', fontSize: '14px', marginTop: '5px' }}>
                      {errors.novaSenha}
                    </div>
                  )}
                </div>
              )}
            </>
          )}

          <div style={{ 
            display: 'flex', 
            gap: '10px', 
            justifyContent: 'center',
            marginTop: '30px'
          }}>
            {!editMode ? (
              <button 
                onClick={handleEdit}
                style={{
                  padding: '12px 24px',
                  background: '#dc143c',
                  color: 'white',
                  border: 'none',
                  borderRadius: '5px',
                  cursor: 'pointer'
                }}
              >
                Editar Perfil
              </button>
            ) : (
              <>
                <button 
                  onClick={handleSave}
                  style={{
                    padding: '12px 24px',
                    background: '#28a745',
                    color: 'white',
                    border: 'none',
                    borderRadius: '5px',
                    cursor: 'pointer'
                  }}
                >
                  Salvar
                </button>
                <button 
                  onClick={() => setEditMode(false)}
                  style={{
                    padding: '12px 24px',
                    background: '#6c757d',
                    color: 'white',
                    border: 'none',
                    borderRadius: '5px',
                    cursor: 'pointer'
                  }}
                >
                  Cancelar
                </button>
              </>
            )}
          </div>

          <div style={{ 
            textAlign: 'center', 
            marginTop: '40px',
            paddingTop: '20px',
            borderTop: '1px solid #eee'
          }}>
            <h3 style={{ color: '#dc143c', marginBottom: '15px' }}></h3>
            <div style={{ 
              display: 'grid', 
              gridTemplateColumns: 'repeat(auto-fit, minmax(120px, 1fr))', 
              gap: '15px',
              marginBottom: '20px'
            }}>
              
              
              
            </div>

            <button 
              onClick={handleLogout}
              style={{
                padding: '10px 20px',
                background: '#dc3545',
                color: 'white',
                border: 'none',
                borderRadius: '5px',
                cursor: 'pointer',
                marginTop: '10px'
              }}
            >
              Sair da Conta
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PerfilUsuario;