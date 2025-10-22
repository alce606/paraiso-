import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'
import './utils/themeManager.js'

// Aplicar tema imediatamente
const applyThemeOnLoad = () => {
  const savedConfig = localStorage.getItem('siteConfig');
  if (savedConfig) {
    const config = JSON.parse(savedConfig);
    document.body.className = config.tema === 'escuro' ? 'dark-theme' : 'light-theme';
    document.documentElement.style.setProperty('--primary-color', config.corPrimaria || '#dc143c');
    document.title = config.nomesite || 'Coração Generoso';
  }
};

applyThemeOnLoad();

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)