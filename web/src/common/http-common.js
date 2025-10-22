import axios from 'axios';
//const API_URL =  "https://projeto.com.br/"; //remote(produção)
const API_URL = "http://localhost:8080/"; //local(desenvolvimento)

//Texto somente
const mainInstance = axios.create({
    baseURL: API_URL,
    headers: {
        "Content-type": "application/json"
    }
});

//Arquivos e texto
const multipartInstance = axios.create({
    baseURL: API_URL,
    headers: {
        "Content-type": "multipart/form-data"
    }
});

// Interceptador para adicionar token de autenticação se existir
mainInstance.interceptors.request.use(
    (config) => {
        const adminToken = localStorage.getItem('adminToken');
        if (adminToken) {
            config.headers.Authorization = `Bearer ${adminToken}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

multipartInstance.interceptors.request.use(
    (config) => {
        const adminToken = localStorage.getItem('adminToken');
        if (adminToken) {
            config.headers.Authorization = `Bearer ${adminToken}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

const httpCommom = {
    mainInstance,
    multipartInstance,
};
export default httpCommom;