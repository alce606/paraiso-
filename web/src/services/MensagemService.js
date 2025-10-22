// src/services/MensagemService.js

import http from '../common/http-common';

const API_URL = 'mensagem/';

const findAll = () => {
    return http.mainInstance.get(`${API_URL}findAll`);
};

const findById = (id) => {
    return http.mainInstance.get(`${API_URL}findById/${id}`);
};

const save = async (mensagem) => {
    try {
        return await http.mainInstance.post(`${API_URL}save`, mensagem);
    } catch (error) {
        console.error('Erro ao salvar mensagem:', error.response?.data || error.message);
        throw error;
    }
};

const responder = async (id, mensagem) => {
    try {
        return await http.mainInstance.put(`${API_URL}responder/${id}`, mensagem);
    } catch (error) {
        console.error('Erro ao salvar mensagem:', error.response?.data || error.message);
        throw error;
    }
};

const deleteById = (id) => {
    return http.mainInstance.delete(`${API_URL}delete/${id}`);
};

const MensagemService = {
    findAll,
    findById,
    save,
    responder,
    deleteById
};

export default MensagemService;
