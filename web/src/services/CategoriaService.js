import http from '../common/http-common';

const API_URL = "categoria/";

// Buscar todas as categorias
const findAll = () => {
    return http.mainInstance.get(API_URL + 'findAll');
};

// Buscar categoria por ID
const findById = (id) => {
    return http.mainInstance.get(API_URL + `findById/${id}`);
};

// Cadastrar nova categoria
const save = (categoria) => {
    return http.mainInstance.post(API_URL + 'save', categoria);
};

const CategoriaService = {
    findAll,
    findById,
    save
};

export default CategoriaService;
