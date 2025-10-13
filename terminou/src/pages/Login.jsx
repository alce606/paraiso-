import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const Login = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: '',
    senha: ''
  });
  const [message, setMessage] = useState('');

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setMessage('');

    UsuarioService.signin(formData.email, formData.senha)
      .then(() => {
        const userJson = localStorage.getItem('user');
        const user = JSON.parse(userJson || '{}');
        
        if (user.nivelAcesso === 'ADMIN') {
          setMessage('Acesso negado. Use o login de administrador.');
          return;
        }
        
        localStorage.setItem('userType', 'user');
        localStorage.setItem('nivelAcesso', 'USER');
        window.dispatchEvent(new Event('userTypeChanged'));
        
        console.log('Dados do usuário:', user);
        const nomeUsuario = user.nome || user.email?.split('@')[0] || 'Usuário';
        alert(`Bem-vindo, ${nomeUsuario}!`);
        navigate('/');
      })
      .catch((error) => {
        const respMessage = 
          (error.response && error.response.data && error.response.data.message) ||
          error.message ||
          error.toString();
        setMessage(respMessage);
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
        <div className="card" style={{ width: '100%', maxWidth: '400px' }}>
          <div style={{ textAlign: 'center', marginBottom: '30px' }}>
            <span style={{ fontSize: '3rem' }}>👤</span>
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Login Usuário</h1>
            <p style={{ color: '#666', marginTop: '10px' }}>
              Acesse para visualizar eventos e informações
            </p>
          </div>

          <form onSubmit={handleSubmit}>
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
                placeholder="Sua senha"
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

            <button type="submit" className="btn btn-primary" style={{ width: '100%', marginBottom: '20px' }}>
              Entrar
            </button>

            <div style={{ textAlign: 'center' }}>
              <p style={{ color: '#666', marginBottom: '10px' }}>
                Esqueceu sua senha? <Link to="/esqueceu-senha" style={{ color: '#dc143c' }}>Clique aqui</Link>
              </p>
              <p style={{ color: '#666', marginBottom: '10px' }}>
                Não tem uma conta? <Link to="/cadastro" style={{ color: '#dc143c' }}>Cadastre-se</Link>
              </p>
              <p style={{ color: '#666' }}>
                É administrador? <Link to="/login-admin" style={{ color: '#dc143c' }}>Login Admin</Link>
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Login;