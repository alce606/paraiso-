import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const LoginAdmin = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: '',
    senha: ''
  });

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

   const [message, setMessage] = useState();

   const handleSubmit = (e) => {
        e.preventDefault();
        setMessage("");

      UsuarioService.signin(formData.email, formData.senha)
        .then(() => {
          const userJson = localStorage.getItem('user');
          const user = JSON.parse(userJson || '{}');
          
          if (user.nivelAcesso !== 'ADMIN') {
            setMessage('Acesso negado. Apenas administradores podem acessar.');
            return;
          }
          
          localStorage.setItem('userType', 'admin');
          localStorage.setItem('nivelAcesso', 'ADMIN');
          window.dispatchEvent(new Event('userTypeChanged'));
          
          console.log('Dados do admin:', user);
          const nomeAdmin = user.nome || user.email?.split('@')[0] || 'Administrador';
          alert(`Bem-vindo, ${nomeAdmin}!`);
          
          if (user.statusUsuario === 'ATIVO') {
            navigate('/admin');
          } else if (user.statusUsuario === 'TROCAR_SENHA') {
            navigate(`/alterarsenha/` + user.id);
          }
        },
            (error) => {
                const respMessage =
                    (error.response &&
                        error.response.data &&
                        error.response.data.message) ||
                    error.message ||
                    error.toString();

                setMessage(respMessage);
            }

        );
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
            <span style={{ fontSize: '3rem' }}>👨‍💼</span>
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Login Administrador</h1>
            <p style={{ color: '#666', marginTop: '10px' }}>
              Acesso exclusivo para gerenciar eventos
            </p>
          </div>

          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Email do Administrador</label>
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                placeholder="admin@coracaogeneroso.com"
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
                placeholder="Senha do administrador"
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
              Entrar como Admin
            </button>

            <div style={{ textAlign: 'center' }}>
              <p style={{ color: '#666', marginBottom: '10px' }}>
                Esqueceu sua senha? <Link to="/admin/trocar-senha" style={{ color: '#dc143c' }}>Trocar senha</Link>
              </p>
              <p style={{ color: '#666' }}>
                Usuário comum? <Link to="/login" style={{ color: '#dc143c' }}>Faça login aqui</Link>
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default LoginAdmin;