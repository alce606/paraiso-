import http from '../common/http-common';

const API_URL = "presenca/";

// Teste de conexão
const test = () => {
    return http.mainInstance.get(API_URL + 'test');
};

// Buscar todas as presenças
const findAll = () => {
    return http.mainInstance.get(API_URL + 'findAll');
};


const findById = (id) => {
    return http.mainInstance.get(API_URL + `findById/${id}`);
};

// Salvar nova presença
const save = (presenca) => {
    return http.mainInstance.post(API_URL + 'save', presenca);
};

// Atualizar presença (caso tenha endpoint PUT /update/{id})
const update = (id, presenca) => {
    return http.mainInstance.put(API_URL + `update/${id}`, presenca);
};

// Desmarcar presença (exemplo com PUT ou DELETE, conforme backend)
// Aqui um exemplo usando PUT para "desmarcar"
const desmarcar = (id) => {
    return http.mainInstance.put(API_URL + `desmarcar/${id}`);
};

// Ou, se usar DELETE para remover a presença
const remover = (id) => {
    return http.mainInstance.delete(API_URL + `delete/${id}`);
};



const PresencaService = {
    test,
    findAll,
    findById,
    save,
    update,
    desmarcar,
    remover
};

export default PresencaService;
