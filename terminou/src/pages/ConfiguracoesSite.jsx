import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import MensagemService from '../services/MensagemService';
import UsuarioService from '../services/UsuarioService';

const SystemStatus = ({ config }) => {
  const [stats, setStats] = useState({
    usuarios: 0,
    suportes: 0,
    backup: 'Nunca'
  });

  useEffect(() => {
    loadStats();
  }, []);

  const loadStats = async () => {
    try {
      // Carregar usuários
      const users = JSON.parse(localStorage.getItem('users') || '[]');
      
      // Carregar suportes
      const suportesResponse = await MensagemService.findAll();
      const suportesAtivos = suportesResponse.data.filter(s => s.statusMensagem === 'ativa');
      
      // Verificar backup
      const backupData = localStorage.getItem('siteBackup');
      const lastBackup = backupData ? new Date(JSON.parse(backupData).timestamp).toLocaleDateString('pt-BR') : 'Nunca';
      
      setStats({
        usuarios: users.length,
        suportes: suportesAtivos.length,
        backup: lastBackup
      });
    } catch (error) {
      console.error('Erro ao carregar estatísticas:', error);
    }
  };

  const isOnline = !config.manutencao;
  
  return (
    <div className="card" style={{ backgroundColor: isOnline ? '#e8f5e8' : '#ffe6e6', padding: '20px', border: `1px solid ${isOnline ? '#28a745' : '#dc3545'}` }}>
      <h3 style={{ color: isOnline ? '#28a745' : '#dc3545', marginBottom: '15px' }}>📈 Status do Sistema</h3>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '10px', fontSize: '14px' }}>
        <div>{isOnline ? '🟢 Servidor Online' : '🔴 Servidor em Manutenção'}</div>
        <div>💾 Último Backup: {stats.backup}</div>
        <div>👤 Usuários Cadastrados: {stats.usuarios}</div>
        <div>💬 Suportes Pendentes: {stats.suportes}</div>
      </div>
    </div>
  );
};

const ConfiguracoesSite = () => {
  const navigate = useNavigate();
  const [config, setConfig] = useState(() => {
    const saved = localStorage.getItem('siteConfig');
    return saved ? JSON.parse(saved) : {
      tema: 'claro',
      corPrimaria: '#dc143c',
      nomesite: 'Coração Generoso',
      manutencao: false,
      notificacoes: true,
      backup: true,
      analytics: false,
      registroUsuarios: true
    };
  });

  useEffect(() => {
    applyConfig(config);
  }, [config]);

  const applyConfig = (newConfig) => {
    // Aplicar tema
    if (newConfig.tema === 'escuro') {
      document.body.style.backgroundColor = '#1a1a1a';
      document.body.style.color = '#ffffff';
    } else {
      document.body.style.backgroundColor = '#ffffff';
      document.body.style.color = '#000000';
    }
    
    // Aplicar cor primária globalmente
    const style = document.getElementById('dynamic-styles') || document.createElement('style');
    style.id = 'dynamic-styles';
    style.innerHTML = `
      :root { --primary-color: ${newConfig.corPrimaria} !important; }
      .btn-primary, button[style*="#dc143c"] { background-color: ${newConfig.corPrimaria} !important; }
      h1, h2, h3 { color: ${newConfig.corPrimaria} !important; }
      .text-primary { color: ${newConfig.corPrimaria} !important; }
      .heart-logo { color: ${newConfig.corPrimaria} !important; }
      body.dark-theme .btn-secondary { border-color: ${newConfig.corPrimaria} !important; color: ${newConfig.corPrimaria} !important; }
      body.dark-theme .btn-secondary:hover { background-color: ${newConfig.corPrimaria} !important; }
    `;
    if (!document.getElementById('dynamic-styles')) {
      document.head.appendChild(style);
    }
    
    // Aplicar título
    document.title = newConfig.nomesite;
    
    // Disparar evento para atualizar header
    window.dispatchEvent(new Event('configChanged'));
    
    // Modo manutenção (apenas para usuários, não para admin)
    const isAdmin = localStorage.getItem('userType') === 'admin';
    if (newConfig.manutencao && !isAdmin) {
      const overlay = document.getElementById('maintenance-overlay') || document.createElement('div');
      overlay.id = 'maintenance-overlay';
      overlay.innerHTML = `
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(135deg, rgba(220,20,60,0.95), rgba(0,0,0,0.95)); z-index: 9999; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; font-family: 'Segoe UI', sans-serif; text-align: center; padding: 20px;">
          <div style="background: rgba(255,255,255,0.1); padding: 40px; border-radius: 20px; backdrop-filter: blur(10px); max-width: 500px;">
            <div style="font-size: 4rem; margin-bottom: 20px;">⚙️</div>
            <h2 style="margin-bottom: 15px; font-weight: 300;">Estamos em Manutenção</h2>
            <p style="font-size: 18px; line-height: 1.6; margin-bottom: 25px; opacity: 0.9;">Nosso site está passando por melhorias para oferecer uma experiência ainda melhor.</p>
            <p style="font-size: 16px; opacity: 0.8; margin-bottom: 20px;">Voltaremos em breve!</p>
            <div style="border-top: 1px solid rgba(255,255,255,0.2); padding-top: 20px; margin-top: 20px;">
              <p style="font-size: 14px; opacity: 0.7;">Precisa de ajuda? Entre em contato com nosso suporte</p>
              <p style="font-size: 14px; opacity: 0.7;">📧 suporte@coracaogeneroso.com</p>
            </div>
          </div>
        </div>
      `;
      if (!document.getElementById('maintenance-overlay')) {
        document.body.appendChild(overlay);
      }
    } else {
      const overlay = document.getElementById('maintenance-overlay');
      if (overlay) overlay.remove();
    }
    
    // Notificações
    if (newConfig.notificacoes && 'Notification' in window) {
      Notification.requestPermission();
    }
    
    // Analytics
    if (newConfig.analytics) {
      if (!window.gtag) {
        const script = document.createElement('script');
        script.src = 'https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID';
        document.head.appendChild(script);
        window.dataLayer = window.dataLayer || [];
        window.gtag = function(){window.dataLayer.push(arguments);};
        window.gtag('js', new Date());
        window.gtag('config', 'GA_MEASUREMENT_ID');
      }
    }
  };

  const handleChange = (key, value) => {
    const newConfig = { ...config, [key]: value };
    setConfig(newConfig);
    localStorage.setItem('siteConfig', JSON.stringify(newConfig));
    
    // Disparar evento para atualizar header
    window.dispatchEvent(new Event('configChanged'));
    
    // Aplicar mudanças imediatamente
    if (key === 'notificacoes' && value) {
      new Notification('✅ Notificações ativadas!');
    }

  };

  const handleSave = () => {
    localStorage.setItem('siteConfig', JSON.stringify(config));
    applyConfig(config);
    
    // Backup automático
    if (config.backup) {
      const backup = {
        config,
        timestamp: new Date().toISOString(),
        users: JSON.parse(localStorage.getItem('users') || '[]'),
        events: JSON.parse(localStorage.getItem('events') || '[]')
      };
      localStorage.setItem('siteBackup', JSON.stringify(backup));
    }
    
    if (config.notificacoes && 'Notification' in window && Notification.permission === 'granted') {
      new Notification('✅ Configurações salvas!', {
        body: 'Todas as alterações foram aplicadas com sucesso.',
        icon: config.logoUrl || '/favicon.ico'
      });
    } else {
      alert('✅ Configurações salvas com sucesso!');
    }
  };

  const handleReset = () => {
    if (confirm('🔄 Deseja restaurar as configurações padrão?')) {
      const defaultConfig = {
        tema: 'claro',
        corPrimaria: '#dc143c',
        nomesite: 'Coração Generoso',
        manutencao: false,
        notificacoes: true,
        backup: true,
        analytics: false,
        registroUsuarios: true
      };
      setConfig(defaultConfig);
      localStorage.setItem('siteConfig', JSON.stringify(defaultConfig));
      applyConfig(defaultConfig);
      window.dispatchEvent(new Event('configChanged'));
      alert('🔄 Configurações restauradas!');
    }
  };

  const handleClearCache = () => {
    // Limpar localStorage específico
    const keysToKeep = ['siteConfig', 'siteBackup'];
    const allKeys = Object.keys(localStorage);
    allKeys.forEach(key => {
      if (!keysToKeep.includes(key)) {
        localStorage.removeItem(key);
      }
    });
    
    // Limpar cache do navegador
    if ('caches' in window) {
      caches.keys().then(names => {
        names.forEach(name => caches.delete(name));
      });
    }
    
    alert('🗑️ Cache limpo com sucesso!');
  };

  const handleExportConfig = () => {
    const dataStr = JSON.stringify(config, null, 2);
    const dataBlob = new Blob([dataStr], {type: 'application/json'});
    const url = URL.createObjectURL(dataBlob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'site-config.json';
    link.click();
  };

  const handleImportConfig = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        try {
          const importedConfig = JSON.parse(e.target.result);
          setConfig(importedConfig);
          localStorage.setItem('siteConfig', JSON.stringify(importedConfig));
          applyConfig(importedConfig);
          window.dispatchEvent(new Event('configChanged'));
          alert('📥 Configurações importadas!');
        } catch (error) {
          alert('❌ Erro ao importar configurações!');
        }
      };
      reader.readAsText(file);
    }
  };

  return (
    <div style={{ maxWidth: 800, margin: '40px auto', fontFamily: 'Segoe UI, sans-serif' }}>
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
        <h2 style={{ color: '#dc143c', margin: 0 }}>Personalizar Site</h2>
      </div>

      <div style={{ display: 'grid', gap: '25px' }}>
        {/* Aparência */}
        <div className="card" style={{ padding: '20px' }}>
          <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Visual do Site</h3>
          
          <div style={{ marginBottom: '15px' }}>
            <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Tema:</label>
            <select 
              value={config.tema} 
              onChange={(e) => handleChange('tema', e.target.value)}
              style={{ padding: '8px', borderRadius: '4px', border: '1px solid #ddd', width: '200px' }}
            >
              <option value="claro">Claro</option>
              <option value="escuro">Escuro</option>
              <option value="auto">Automático</option>
            </select>
          </div>

          <div style={{ marginBottom: '15px' }}>
            <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Cor Primária:</label>
            <input 
              type="color" 
              value={config.corPrimaria}
              onChange={(e) => handleChange('corPrimaria', e.target.value)}
              style={{ width: '60px', height: '40px', border: 'none', borderRadius: '4px' }}
            />
            <span style={{ marginLeft: '10px', color: '#666' }}>{config.corPrimaria}</span>
          </div>

          <div>
            <label style={{ display: 'block', marginBottom: '5px', fontWeight: 'bold' }}>Nome do Site:</label>
            <input 
              type="text" 
              value={config.nomesite}
              onChange={(e) => handleChange('nomesite', e.target.value)}
              style={{ padding: '8px', borderRadius: '4px', border: '1px solid #ddd', width: '300px' }}
            />
          </div>
        </div>

        {/* Sistema */}
        <div className="card" style={{ padding: '20px' }}>
          <h3 style={{ color: '#dc143c', marginBottom: '15px' }}>Funcionalidades</h3>
          
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '15px' }}>
            <label style={{ display: 'flex', alignItems: 'center', cursor: 'pointer' }}>
              <input 
                type="checkbox" 
                checked={config.manutencao}
                onChange={(e) => handleChange('manutencao', e.target.checked)}
                style={{ marginRight: '8px' }}
              />
              🚧 Modo Manutenção
            </label>

            <label style={{ display: 'flex', alignItems: 'center', cursor: 'pointer' }}>
              <input 
                type="checkbox" 
                checked={config.notificacoes}
                onChange={(e) => handleChange('notificacoes', e.target.checked)}
                style={{ marginRight: '8px' }}
              />
              🔔 Notificações Push
            </label>

            <label style={{ display: 'flex', alignItems: 'center', cursor: 'pointer' }}>
              <input 
                type="checkbox" 
                checked={config.backup}
                onChange={(e) => handleChange('backup', e.target.checked)}
                style={{ marginRight: '8px' }}
              />
              💾 Backup Automático
            </label>

            <label style={{ display: 'flex', alignItems: 'center', cursor: 'pointer' }}>
              <input 
                type="checkbox" 
                checked={config.analytics}
                onChange={(e) => handleChange('analytics', e.target.checked)}
                style={{ marginRight: '8px' }}
              />
              📊 Google Analytics
            </label>



            <label style={{ display: 'flex', alignItems: 'center', cursor: 'pointer' }}>
              <input 
                type="checkbox" 
                checked={config.registroUsuarios}
                onChange={(e) => handleChange('registroUsuarios', e.target.checked)}
                style={{ marginRight: '8px' }}
              />
              👥 Registro de Usuários
            </label>
          </div>
        </div>

        {/* Status Atual */}
        <SystemStatus config={config} />

        {/* Ações */}
        <div style={{ display: 'flex', gap: '15px', justifyContent: 'center' }}>
          <button 
            onClick={handleSave}
            className="btn btn-success"
          >
            <i className="bi bi-check-circle"></i> Salvar Configurações
          </button>
          
          <button 
            onClick={handleReset}
            className="btn btn-warning"
          >
            <i className="bi bi-arrow-clockwise"></i> Restaurar Padrão
          </button>
          
          <button 
            onClick={handleClearCache}
            className="btn btn-info"
          >
            <i className="bi bi-trash"></i> Limpar Cache
          </button>
          
          <button 
            onClick={handleExportConfig}
            className="btn btn-primary"
          >
            <i className="bi bi-download"></i> Exportar
          </button>
          
          <label className="btn btn-secondary">
            <i className="bi bi-upload"></i> Importar
            <input 
              type="file" 
              accept=".json" 
              onChange={handleImportConfig}
              style={{ display: 'none' }}
            />
          </label>
        </div>
      </div>
    </div>
  );
};

export default ConfiguracoesSite;