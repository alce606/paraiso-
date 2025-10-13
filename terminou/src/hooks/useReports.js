import { useQuery } from 'react-query';
import { reportService } from '../services/reportService';

export const useSystemStats = () => {
  return useQuery(['systemStats'], reportService.getSystemStats, {
    staleTime: 5 * 60 * 1000,
    refetchInterval: 5 * 60 * 1000, // Atualiza a cada 5 minutos
  });
};

export const useEventStats = (period = 'month') => {
  return useQuery(['eventStats', period], () => reportService.getEventStats(period), {
    staleTime: 10 * 60 * 1000,
  });
};

export const useUserStats = (period = 'month') => {
  return useQuery(['userStatsReport', period], () => reportService.getUserStats(period), {
    staleTime: 10 * 60 * 1000,
  });
};

export const useFinancialStats = (period = 'month') => {
  return useQuery(['financialStats', period], () => reportService.getFinancialStats(period), {
    staleTime: 10 * 60 * 1000,
  });
};