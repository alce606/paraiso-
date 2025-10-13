// src/services/MensagemService.js

import http from '../common/http-common';

const API_URL = 'mensagem/';

const findAll = () => {
    return http.mainInstance.get(`${API_URL}findAll`);
};

const findById = (id) => {
    return http.mainInstance.get(`${API_URL}findById/${id}`);
};

const save = (mensagem) => {
    return http.mainInstance.post(`${API_URL}save`, mensagem);
};

const deleteById = (id) => {
    return http.mainInstance.delete(`${API_URL}delete/${id}`);
};

const MensagemService = {
    findAll,
    findById,
    save,
    deleteById
};

export default MensagemService;
