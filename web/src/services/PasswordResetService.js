import http from "../common/http-common";

const API_URL = "senha/";

const solicitarReset = (email) => {
  return http.mainInstance.post(API_URL + "solicitar", { email });
};

const validarToken = (token) => {
  return http.mainInstance.post(API_URL + "validar", { token });
};

const redefinirSenha = (token, novaSenha) => {
  return http.mainInstance.post(API_URL + "redefinir", { token, novaSenha });
};

const PasswordResetService = {
  solicitarReset,
  validarToken,
  redefinirSenha,
};

export default PasswordResetService;