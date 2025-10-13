import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const Cadastro = () => {
  const navigate = useNavigate();
  const [config, setConfig] = useState({ registroUsuarios: true });
  const [formData, setFormData] = useState({
    nome: '',
    email: '',
    senha: '',
    confirmarSenha: ''
  });
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const savedConfig = localStorage.getItem('siteConfig');
    if (savedConfig) {
      const parsedConfig = JSON.parse(savedConfig);
      setConfig(parsedConfig);
      if (!parsedConfig.registroUsuarios) {
        alert('🚫 Registro de novos usuários está desabilitado.');
        navigate('/');
      }
    }
  }, [navigate]);

  if (!config.registroUsuarios) {
    return (
      <div className="container">
        <div className="card" style={{ textAlign: 'center', maxWidth: '500px', margin: '50px auto' }}>
          <h2 style={{ color: '#dc143c' }}>🚫 Registro Desabilitado</h2>
          <p>O registro de novos usuários está temporariamente desabilitado.</p>
          <Link to="/" className="btn btn-primary">Voltar ao Início</Link>
        </div>
      </div>
    );
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
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

  const handleSubmit = (e) => {
    e.preventDefault();
    setMessage('');
    
    if (formData.senha !== formData.confirmarSenha) {
      setMessage('As senhas não coincidem!');
      return;
    }
    
    const passwordError = validatePassword(formData.senha);
    if (passwordError) {
      setMessage(passwordError);
      return;
    }
    
    setLoading(true);
    
    UsuarioService.signup(formData.nome, formData.email, formData.senha)
      .then(() => {
        alert('Cadastro realizado com sucesso! Você será redirecionado para o login.');
        navigate('/login');
      })
      .catch((error) => {
        const respMessage = 
          (error.response && error.response.data && error.response.data.message) ||
          error.message ||
          error.toString();
        setMessage(respMessage);
      })
      .finally(() => {
        setLoading(false);
      });
  };

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
            <span style={{ fontSize: '3rem' }}>❤️</span>
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Cadastro</h1>
            <p style={{ color: '#666', marginTop: '10px' }}>
              Junte-se ao {config.nomesite || 'Coração Generoso'} e faça a diferença
            </p>
          </div>

          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Nome Completo</label>
              <input
                type="text"
                name="nome"
                value={formData.nome}
                onChange={handleChange}
                placeholder="Seu nome completo"
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
              <label>Senha</label>
              <input
                type="password"
                name="senha"
                value={formData.senha}
                onChange={handleChange}
                placeholder="Crie uma senha segura"
                required
              />
              <small style={{ color: '#666', fontSize: '0.8rem', display: 'block', marginTop: '5px' }}>
                Mínimo 8 caracteres, incluindo: maiúscula, minúscula, número e caractere especial
              </small>
            </div>

            <div className="form-group">
              <label>Confirmar Senha</label>
              <input
                type="password"
                name="confirmarSenha"
                value={formData.confirmarSenha}
                onChange={handleChange}
                placeholder="Confirme sua senha"
                required
              />
            </div>

            {message && (
              <div style={{ 
                background: '#f8d7da', 
                color: '#721c24', 
                padding: '10px', 
                borderRadius: '5px', 
                marginBottom: '15px',
                textAlign: 'center'
              }}>
                {message}
              </div>
            )}

            <button 
              type="submit" 
              className="btn btn-primary" 
              style={{ width: '100%', marginBottom: '20px' }}
              disabled={loading}
            >
              {loading ? 'Criando conta...' : 'Criar Conta'}
            </button>

            <div style={{ textAlign: 'center' }}>
              <p style={{ color: '#666' }}>
                Já tem uma conta? <Link to="/login" style={{ color: '#dc143c' }}>Faça login</Link>
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Cadastro;