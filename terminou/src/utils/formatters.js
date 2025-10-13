// Formatação de data
export const formatDate = (date) => {
  if (!date) return '';
  return new Date(date).toLocaleDateString('pt-BR');
};

export const formatDateTime = (date) => {
  if (!date) return '';
  return new Date(date).toLocaleString('pt-BR');
};

// Formatação de moeda
export const formatCurrency = (value) => {
  if (!value) return 'R$ 0,00';
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL'
  }).format(value);
};

// Formatação de números
export const formatNumber = (value) => {
  if (!value) return '0';
  return new Intl.NumberFormat('pt-BR').format(value);
};

// Formatação de status
export const formatStatus = (status) => {
  const statusMap = {
    active: 'Ativo',
    inactive: 'Inativo',
    pending: 'Pendente',
    approved: 'Aprovado',
    rejected: 'Rejeitado',
    draft: 'Rascunho',
    published: 'Publicado'
  };
  
  return statusMap[status] || status;
};

// Truncar texto
export const truncateText = (text, maxLength = 100) => {
  if (!text) return '';
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
};