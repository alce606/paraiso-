import { useQuery, useMutation, useQueryClient } from 'react-query';
import { eventService } from '../services/eventService';

export const useEvents = (params = {}) => {
  return useQuery(['events', params], () => eventService.getAll(params), {
    staleTime: 5 * 60 * 1000, // 5 minutos
  });
};

export const useEvent = (id) => {
  return useQuery(['event', id], () => eventService.getById(id), {
    enabled: !!id,
  });
};

export const useCreateEvent = () => {
  const queryClient = useQueryClient();
  
  return useMutation(eventService.create, {
    onSuccess: () => {
      queryClient.invalidateQueries(['events']);
    },
  });
};

export const useUpdateEvent = () => {
  const queryClient = useQueryClient();
  
  return useMutation(
    ({ id, data }) => eventService.update(id, data),
    {
      onSuccess: (data, variables) => {
        queryClient.invalidateQueries(['events']);
        queryClient.invalidateQueries(['event', variables.id]);
      },
    }
  );
};

export const useDeleteEvent = () => {
  const queryClient = useQueryClient();
  
  return useMutation(eventService.delete, {
    onSuccess: () => {
      queryClient.invalidateQueries(['events']);
    },
  });
};

export const useEventStats = () => {
  return useQuery(['eventStats'], eventService.getStats, {
    staleTime: 10 * 60 * 1000, // 10 minutos
  });
};