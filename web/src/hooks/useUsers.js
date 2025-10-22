import { useQuery, useMutation, useQueryClient } from 'react-query';
import { userService } from '../services/userService';

export const useUsers = (params = {}) => {
  return useQuery(['users', params], () => userService.getAll(params), {
    staleTime: 5 * 60 * 1000,
  });
};

export const useUser = (id) => {
  return useQuery(['user', id], () => userService.getById(id), {
    enabled: !!id,
  });
};

export const useCreateUser = () => {
  const queryClient = useQueryClient();
  
  return useMutation(userService.create, {
    onSuccess: () => {
      queryClient.invalidateQueries(['users']);
    },
  });
};

export const useUpdateUser = () => {
  const queryClient = useQueryClient();
  
  return useMutation(
    ({ id, data }) => userService.update(id, data),
    {
      onSuccess: (data, variables) => {
        queryClient.invalidateQueries(['users']);
        queryClient.invalidateQueries(['user', variables.id]);
      },
    }
  );
};

export const useDeleteUser = () => {
  const queryClient = useQueryClient();
  
  return useMutation(userService.delete, {
    onSuccess: () => {
      queryClient.invalidateQueries(['users']);
    },
  });
};

export const useUserStats = () => {
  return useQuery(['userStats'], userService.getStats, {
    staleTime: 10 * 60 * 1000,
  });
};

export const useOngs = () => {
  return useQuery(['ongs'], userService.getOngs, {
    staleTime: 15 * 60 * 1000,
  });
};