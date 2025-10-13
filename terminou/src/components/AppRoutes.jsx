import { Routes, Route } from "react-router-dom"
import App from "../templates/App/App"
import Home from "../templates/Home/Home"

import LoginForgotPass from "../templates/Login/LoginForgotPass"
import Login from "../templates/Login/Login"

import Mensagem from "../templates/Mensagem/Mensagem"
import MensagemLer from "../templates/Mensagem/MensagemLer"

import Usuario from "../templates/Usuario/Usuario"
import UsuarioEditar from "../templates/Usuario/UsuarioEditar"
import UsuarioNovo from "../templates/Usuario/UsuarioNovo"
import UsuariosLista from "../templates/Usuario/UsuariosLista"
import LoginNewPass from "../templates/Login/LoginNewPass"
import UsuarioPerfil from "../templates/Usuario/UsuarioPerfil"
import FaleConosco from "../templates/Mensagem/FaleConosco"
import UsuarioAlterarSenha from "../templates/Usuario/UsuarioAlterarSenha"
import Produto from "../templates/Produto/Produto"
import ProdutosLista from "../templates/Produto/ProdutosLista"
import ProdutoNovo from "../templates/Produto/ProdutoNovo"
import ProdutoEditar from "../templates/Produto/ProdutoEditar"
import CepModal from "./Cep/CepModal"
import Cep from "./Cep/Cep"
import MensagensLista from "../templates/Mensagem/MensagensLista"
import ProdutosListaFiltro from "../templates/Produto/ProdutosListaFiltro"
import Promocao from "../templates/Promocao/Promocao"
import PromocaoNova from "../templates/Promocao/PromocaoNova"
import PromocoesLista from "../templates/Promocao/PromocoesLista"
import PromocaoEditar from "../templates/Promocao/PromocaoEditar"
import Cardapio from "../templates/Produto/Cardapio"
import ProdutoAvaliar from "../templates/Produto/ProdutoAvaliar"
import Kardapio from "../templates/Produto/Kardapio"

const AppRoutes = () => {
  return (
    <div>
      <Routes>
        <Route path="/" element={<App />} />
        <Route path="/home" element={<Home />} />
        <Route path="/login" element={<Login />} />
        <Route path="/forgotpass" element={<LoginForgotPass />} />
        <Route path="/newpass/:id" element={<LoginNewPass/>} />

        <Route path="/mensagem" element={<Mensagem />} />
        <Route path="/mensagemler/:id" element={<MensagemLer />} />
        <Route path="/mensagenslista" element={<MensagensLista />} />
        <Route path="/faleconosco" element={<FaleConosco />} />

        <Route path="/produto" element={<Produto />} />
        <Route path="/produtoslista" element={<ProdutosLista />} />
        <Route path="/produtoslistafiltro" element={<ProdutosListaFiltro />} />
        <Route path="/produtonovo" element={<ProdutoNovo />} />
        <Route path="/produtoeditar/:id" element={<ProdutoEditar />} />
        <Route path="/produtoavaliar/:id" element={<ProdutoAvaliar />} />
        <Route path="/cardapio" element={<Cardapio />} />
        <Route path="/kardapio" element={<Kardapio />} />

        <Route path="/promocao" element={<Promocao />} />
        <Route path="/promocaonova" element={<PromocaoNova />} />
        <Route path="/promocoeslista" element={<PromocoesLista/>} />
        <Route path="/promocaoeditar/:id" element={<PromocaoEditar />} />

        <Route path="/usuario" element={<Usuario />} />
        <Route path="/usuarioslista" element={<UsuariosLista />} />
        <Route path="/usuarionovo" element={<UsuarioNovo />} />
        <Route path="/usuarioeditar/:id" element={<UsuarioEditar />} />
        <Route path="/usuarioperfil/:id" element={<UsuarioPerfil />} />
        <Route path="/usuarioalterarsenha/:id" element={<UsuarioAlterarSenha />} />
        
        <Route path="/cepmodal" element={<CepModal />} />
        <Route path="/cep" element={<Cep />} />
      </Routes>
    </div>
  )
}
export default AppRoutes