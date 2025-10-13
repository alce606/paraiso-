import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import UsuarioService from '../services/UsuarioService';

const EsqueceuSenha = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [token, setToken] = useState('');
  const [novaSenha, setNovaSenha] = useState('');
  const [confirmarSenha, setConfirmarSenha] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [step, setStep] = useState(1); // 1: email, 2: token, 3: nova senha
  const [tokenValido, setTokenValido] = useState(false);

  const handleEmailSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    
    try {
      await UsuarioService.forgotPassword(email);
      setMessage('Email de recuperação enviado! Digite o token recebido.');
      setStep(2);
    } catch (error) {
      setMessage(error.message);
      setStep(2); // Mostra o campo mesmo se der erro
    } finally {
      setLoading(false);
    }
  };

  const handleTokenSubmit = (e) => {
    e.preventDefault();
    if (token.trim()) {
      setTokenValido(true);
      setMessage('Agora defina sua nova senha.');
    } else {
      setMessage('Digite o token recebido por email.');
    }
  };

  const handlePasswordSubmit = async (e) => {
    e.preventDefault();
    
    if (novaSenha !== confirmarSenha) {
      setMessage('As senhas não coincidem!');
      return;
    }
    
    setLoading(true);
    
    try {
      await UsuarioService.alterarSenha(email, novaSenha);
      setMessage('Senha alterada com sucesso! Você pode fazer login agora.');
      navigate('/login');
    } catch (error) {
      setMessage('Erro ao alterar senha.');
    } finally {
      setLoading(false);
    }
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
            <span style={{ fontSize: '3rem' }}>🔑</span>
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Esqueceu a Senha?</h1>
            <p style={{ color: '#666', marginTop: '10px' }}>
              Digite seu email para receber instruções de recuperação
            </p>
          </div>

          {step === 1 && (
            <form onSubmit={handleEmailSubmit}>
            <div className="form-group">
              <label>Email</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="seu@email.com"
                required
              />
            </div>

            {message && (
              <div style={{
                padding: '10px',
                marginBottom: '20px',
                borderRadius: '5px',
                backgroundColor: message.includes('sucesso') ? '#d4edda' : '#f8d7da',
                color: message.includes('sucesso') ? '#155724' : '#721c24',
                border: `1px solid ${message.includes('sucesso') ? '#c3e6cb' : '#f5c6cb'}`
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
              {loading ? 'Enviando...' : 'Enviar Email de Recuperação'}
            </button>

            <div style={{ textAlign: 'center' }}>
              <p style={{ color: '#666' }}>
                Lembrou da senha? <Link to="/login" style={{ color: '#dc143c' }}>Fazer login</Link>
              </p>
            </div>
          </form>
          )}

          {step === 2 && (
            <form onSubmit={handleTokenSubmit}>
              <div className="form-group">
                <label>Token de Recuperação</label>
                <input
                  type="text"
                  value={token}
                  onChange={(e) => setToken(e.target.value)}
                  placeholder="Digite o token recebido por email"
                  required
                />
              </div>

              <button 
                type="submit" 
                className="btn btn-primary" 
                style={{ width: '100%', marginBottom: '20px' }}
              >
                Continuar
              </button>
            </form>
          )}

          {tokenValido && (
            <form onSubmit={handlePasswordSubmit}>
              <div className="form-group">
                <label>Nova Senha</label>
                <input
                  type="password"
                  value={novaSenha}
                  onChange={(e) => setNovaSenha(e.target.value)}
                  placeholder="Digite sua nova senha"
                  required
                  minLength="6"
                />
              </div>

              <div className="form-group">
                <label>Confirmar Nova Senha</label>
                <input
                  type="password"
                  value={confirmarSenha}
                  onChange={(e) => setConfirmarSenha(e.target.value)}
                  placeholder="Confirme sua nova senha"
                  required
                  minLength="6"
                />
              </div>

              <button 
                type="submit" 
                className="btn btn-primary" 
                style={{ width: '100%', marginBottom: '20px' }}
                disabled={loading}
              >
                {loading ? 'Alterando...' : 'Alterar Senha'}
              </button>
            </form>
          )}

          {step === 4 && (
            <div style={{ textAlign: 'center' }}>
              <Link to="/login" className="btn btn-primary">Ir para Login</Link>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default EsqueceuSenha;