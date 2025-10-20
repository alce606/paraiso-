import React from 'react';
import fotoNicolly from '../assets/images/fotoNicolly.png';
import fotoRafaela from '../assets/images/fotoRafaela.png';
import fotoArthur from '../assets/images/fotoArthur.png';
import fotoIsabela from '../assets/images/fotoIsabela.png';
import fotoGuilherme from '../assets/images/fotoGuilherme.png';
import fotoPedro from '../assets/images/fotoPedro.png';
 
 
 
const SobreNos = () => {
  return (
    <div className="container">
      <div className="card">
        <div style={{ textAlign: 'center', marginBottom: '30px' }}>
          <span style={{ fontSize: '3rem' }}>❤️</span>
          <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Sobre o Coração Generoso</h1>
        </div>
       
        <div style={{ fontSize: '1.1rem', lineHeight: '1.8', color: '#555' }}>
          <p style={{ marginBottom: '20px' }}>
            O <strong>Coração Generoso</strong> é uma plataforma completa dedicada ao <strong>gerenciamento e divulgação  </strong>
            de eventos beneficentes e projetos sociais. Nossa plataforma está disponível para ONGs
            e organizações que desejam organizar e promover suas ações solidárias.
          </p>
         
          <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', marginBottom: '20px', border: '2px solid #dc143c' }}>
            <h4 style={{ color: '#dc143c', marginBottom: '10px' }}>Nosso Aplicativo Móvel</h4>
            <p style={{ marginBottom: '10px' }}>
              Desenvolvemos um <strong>aplicativo exclusivo</strong> que permite aos usuários:
            </p>
            <ul style={{ marginLeft: '20px', marginBottom: '15px' }}>
              <li><strong>Marcar presença nos eventos</strong> - Funcionalidade disponível APENAS no app</li>
              <li>Receber notificações sobre novos eventos</li>
              <li>Acompanhar eventos confirmados</li>
              <li>Interface otimizada para dispositivos móveis</li>
            </ul>
            <p style={{ fontSize: '0.9rem', color: '#666', fontStyle: 'italic' }}>
              * A confirmação de presença só pode ser feita através do nosso aplicativo móvel.
            </p>
          </div>
         
          <h3 style={{ color: '#dc143c', marginBottom: '15px', marginTop: '30px' }}>Nossa Missão</h3>
          <p style={{ marginBottom: '20px' }}>
            Disponibilizar uma plataforma online para o <strong>gerenciamento eficiente</strong> de eventos
            beneficentes e a <strong>divulgação</strong> de ações sociais, conectando organizações
            com a comunidade interessada em participar e contribuir.
          </p>
         
          <h3 style={{ color: '#dc143c', marginBottom: '15px', marginTop: '30px' }}>O que Oferecemos</h3>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
            gap: '20px',
            marginBottom: '30px'
          }}>
            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px' }}>
              <h4 style={{ color: '#dc143c', marginBottom: '10px' }}> Gerenciamento</h4>
              <p>Sistema completo para criar, editar e organizar eventos beneficentes</p>
            </div>
           
            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px' }}>
              <h4 style={{ color: '#dc143c', marginBottom: '10px' }}> Divulgação</h4>
              <p>Plataforma para promover e dar visibilidade aos seus eventos</p>
            </div>
          </div>
         
          <h3 style={{ color: '#dc143c', marginBottom: '15px', marginTop: '30px' }}>Nossa Equipe</h3>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
            gap: '20px',
            marginBottom: '30px'
          }}>
            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', textAlign: 'center' }}>
               <img src={fotoArthur} alt="" style={{ borderRadius: '10%', width: '80px', height: '80px', objectFit: 'cover', margin: '0 auto', display: 'block' }} />
              <h4 style={{ color: '#dc143c', marginBottom: '5px', marginTop: '15px' }}>Arthur Silva</h4>
              <p style={{ fontSize: '0.9rem', color: '#666' }}>Desenvolvedor </p>
            </div>
           
         <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', textAlign: 'center' }}>
               <img src={fotoPedro} alt="" style={{ borderRadius: '10%', width: '80px', height: '80px', objectFit: 'cover', margin: '0 auto', display: 'block' }} />
              <h4 style={{ color: '#dc143c', marginBottom: '5px', marginTop: '15px' }}>Pedro Oliveira</h4>
              <p style={{ fontSize: '0.9rem', color: '#666' }}>Desenvolvedor </p>
            </div>
           
            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', textAlign: 'center' }}>
               <img src={fotoRafaela} alt="" style={{ borderRadius: '10%', width: '80px', height: '80px', objectFit: 'cover', margin: '0 auto', display: 'block' }} />
              <h4 style={{ color: '#dc143c', marginBottom: '5px', marginTop: '15px' }}>Rafaela Kolle</h4>
              <p style={{ fontSize: '0.9rem', color: '#666' }}>Time-Skrull Designer </p>
            </div>
           
            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', textAlign: 'center' }}>
               <img src={fotoNicolly} alt="" style={{ borderRadius: '10%', width: '80px', height: '80px', objectFit: 'cover', margin: '0 auto', display: 'block' }} />
              <h4 style={{ color: '#dc143c', marginBottom: '5px', marginTop: '15px' }}>Nicolly Costa</h4>
              <p style={{ fontSize: '0.9rem', color: '#666' }}>Time-Skrull Designer</p>
            </div>
           
            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', textAlign: 'center' }}>
               <img src={fotoIsabela} alt="" style={{ borderRadius: '10%', width: '80px', height: '80px', objectFit: 'cover', margin: '0 auto', display: 'block' }} />
              <h4 style={{ color: '#dc143c', marginBottom: '5px', marginTop: '15px' }}>Isabela Marques</h4>
              <p style={{ fontSize: '0.9rem', color: '#666' }}>Gerente</p>
            </div>
           
           
            <div style={{ background: '#fff0f0', padding: '20px', borderRadius: '10px', textAlign: 'center' }}>
               <img src={fotoGuilherme} alt="" style={{ borderRadius: '10%', width: '80px', height: '80px', objectFit: 'cover', margin: '0 auto', display: 'block' }} />
              <h4 style={{ color: '#dc143c', marginBottom: '5px', marginTop: '15px' }}>Guilherme Félix</h4>
              <p style={{ fontSize: '0.9rem', color: '#666' }}>Product-owner</p>
            </div>
          </div>
         
          
          <h3 style={{ color: '#dc143c', marginBottom: '15px', marginTop: '30px' }}>Contato</h3>
          <div style={{ background: '#fff0f0', padding: '25px', borderRadius: '10px', textAlign: 'center' }}>
            <h4 style={{ color: '#dc143c', marginBottom: '15px' }}>Entre em Contato</h4>
            <div style={{ fontSize: '1.1rem', lineHeight: '1.8' }}>
              <p><strong>Celular:</strong> <span style={{ color: '#dc143c' }}>(11) 98635-0216</span></p>
              <p><strong>Email:</strong> coracaogeneroso087@gmail.com</p>
              <p style={{ marginTop: '15px', fontSize: '1rem' }}>
                Nossa plataforma está <strong>ativa e disponível</strong> para ONGs e organizações
                que desejam gerenciar seus eventos e divulgar suas ações beneficentes.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
 
export default SobreNos;