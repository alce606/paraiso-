// Gerenciador global de tema
export const applyTheme = () => {
  const savedConfig = localStorage.getItem('siteConfig');
  if (savedConfig) {
    const config = JSON.parse(savedConfig);
    
    // Aplicar tema
    document.body.className = config.tema === 'escuro' ? 'dark-theme' : 'light-theme';
    
    // Aplicar cor primária
    document.documentElement.style.setProperty('--primary-color', config.corPrimaria || '#dc143c');
    
    // Aplicar título
    document.title = config.nomesite || 'Coração Generoso';
  }
};

// Aplicar tema ao carregar qualquer página
document.addEventListener('DOMContentLoaded', applyTheme);

// Escutar mudanças de configuração
window.addEventListener('configChanged', applyTheme);