import { useState, useEffect } from 'react';
import { useMutation } from 'react-query';
import UsuarioService from '../services/UsuarioService';

export const useAuth = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isAdminAuthenticated, setIsAdminAuthenticated] = useState(false);
  const [user, setUser] = useState(null);

  useEffect(() => {
    setIsAuthenticated(UsuarioService.isAuthenticated());
    setIsAdminAuthenticated(UsuarioService.isAdminAuthenticated());
    setUser(UsuarioService.getCurrentUser());
  }, []);

  const loginMutation = useMutation(UsuarioService.signin, {
    onSuccess: (data) => {
      setIsAuthenticated(true);
      setUser(data.user);
    },
  });

  const adminLoginMutation = useMutation(UsuarioService.loginAdmin, {
    onSuccess: (data) => {
      setIsAdminAuthenticated(true);
      setUser(data.user);
    },
  });

  const logout = () => {
    UsuarioService.logout();
    localStorage.removeItem('adminToken');
    localStorage.removeItem('adminUser');
    setIsAuthenticated(false);
    setIsAdminAuthenticated(false);
    setUser(null);
  };

  return {
    isAuthenticated,
    isAdminAuthenticated,
    user,
    login: loginMutation.mutate,
    adminLogin: adminLoginMutation.mutate,
    logout,
    isLoading: loginMutation.isLoading || adminLoginMutation.isLoading,
    error: loginMutation.error || adminLoginMutation.error,
  };
};