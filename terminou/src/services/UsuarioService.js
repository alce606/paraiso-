import http from '../common/http-common';
const API_URL = "usuario/";

const findAll = () => {
    return http.mainInstance.get(API_URL + 'findAll');
};

const findById = (id) => {
    return http.mainInstance.get(API_URL + `findById/${id}`);
};

const signup = (nome, email, senha) => {
    const formData = new FormData();
    formData.append('nome', nome);
    formData.append('email', email);
    formData.append('senha', senha);
    formData.append('nivelAcesso', 'USER');
    formData.append('statusUsuario', 'ATIVO');

    return http.mainInstance.post(API_URL + "create", formData);
};

const signin = async (email, senha) => {
    try {
        const response = await http.mainInstance
            .post(API_URL + "login", {
                email,
                senha,
            });
        if (response.data) {
            localStorage.setItem("user", JSON.stringify(response.data));
        }
        return response.data;
    } catch (error) {
        console.error('Erro no login:', error);
        throw error.response?.data || error.message || 'Erro no login';
    }
};

const logout = () => {
    localStorage.removeItem("user");
    localStorage.removeItem("userType");
    localStorage.removeItem("nivelAcesso");
    localStorage.removeItem("adminToken");
    localStorage.removeItem("adminUser");
    // Dispara evento para atualizar o Header
    window.dispatchEvent(new Event('userTypeChanged'));
};

const getCurrentUser = () => {
    return JSON.parse(localStorage.getItem("user"));
};

const updateCurrentUser = (userData) => {
    localStorage.setItem("user", JSON.stringify(userData));
    // Dispara evento para atualizar o Header
    window.dispatchEvent(new Event('userTypeChanged'));
};

const create = data => {
    const formData = new FormData();
    formData.append('nome', data.nome);
    formData.append('email', data.email);
    formData.append('nivelAcesso', data.nivelAcesso);

    return http.mainInstance.post(API_URL + "create", formData);
};

const update = (id, data) => {
    const formData = new FormData();
    formData.append('nome', data.nome);
    formData.append('email', data.email);
    formData.append('nivelAcesso', data.nivelAcesso);
    if (data.foto) {
        formData.append('foto', data.foto);
    }
    return http.multipartInstance.put(API_URL + `update/${id}`, formData);
};

const _alterar = (file, id, data) => {
    const formData = new FormData();

    formData.append('file', file);
    formData.append('nome', data.nome);
    formData.append('email', data.email);
    formData.append('nivelAcesso', data.nivelAcesso);

    for (const key of formData.entries()) {
        console.log(key[0] + ', ' + key[1]);
    }

    return http.multipartInstance.put(API_URL + `editar/${id}`, formData);
};

const alterar = async (id, data) => {
    const response = await http.mainInstance.put(API_URL + `alterar/${id}`, data);

    // Atualiza localStorage se for o usuário logado
    const currentUser = getCurrentUser();
    if (currentUser && currentUser.id === id) {
        updateCurrentUser({ ...currentUser, ...response.data });
    }

    return response;
};

const inativar = (id) => {
    return http.mainInstance.put(API_URL + `inativar/${id}`);
};

const reativar = (id) => {
    return http.mainInstance.put(API_URL + `reativar/${id}`);
};

const alterarSenha = (email, novaSenha) => {
    const formData = new FormData();
    formData.append('senha', novaSenha);

    return http.mainInstance.put(API_URL + `alterarSenha/${email}`, formData);
};

const findByNome = nome => {
    return http.mainInstance.get(API_URL + `findByNome?nome=${nome}`);
};

const deletar = (id) => {
    return http.mainInstance.delete(API_URL + `delete/${id}`);
};

const loginAdmin = async (email, senha) => {
    try {
        const response = await http.mainInstance
            .post(API_URL + "loginAdmin", {
                email,
                senha,
            });
        if (response.data) {
            localStorage.setItem("adminToken", response.data.token);
            localStorage.setItem("adminUser", JSON.stringify(response.data));
        }
        return response.data;
    } catch (error) {
        console.error('Erro no login admin:', error);
        throw error.response?.data || error.message || 'Erro no login admin';
    }
};

const isAdminAuthenticated = () => {
    return !!localStorage.getItem('adminToken');
};

const isAuthenticated = () => {
    return !!localStorage.getItem('user');
};



const forgotPassword = async (email) => {
    return http.mainInstance.post(`senha/solicitar?email=${email}`);
};

const validateToken = async (token) => {
    return http.mainInstance.post("senha/validar", { token });
};

const resetPassword = async (token, novaSenha) => {
    return http.mainInstance.post("senha/redefinir", { token, novaSenha });
};

const UsuarioService = {
    findAll,
    findById,
    signup,
    signin,
    loginAdmin,
    logout,
    getCurrentUser,
    updateCurrentUser,
    create,
    update,
    alterar,
    _alterar,
    inativar,
    reativar,
    alterarSenha,
    forgotPassword,
    validateToken,
    resetPassword,
    isAdminAuthenticated,
    isAuthenticated,
    findByNome,
    deletar,
}

export default UsuarioService;