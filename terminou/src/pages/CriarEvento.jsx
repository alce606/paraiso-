import React, { useEffect, useRef, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import EventoService from '../services/EventoService';
import CategoriaService from '../services/CategoriaService';
import ImageUploader from "../components/ImageUploader/ImageUploader";
import CepModal from "../components/Cep/CepModal";
import UsuarioService from '../services/UsuarioService';

const CriarEvento = () => {
  const usuario = UsuarioService.getCurrentUser();
  const navigate = useNavigate();
  const _dbRecords = useRef(true);
  const [categorias, setCategorias] = useState([]);

  const [file, setFile] = useState("");

  const [formData, setFormData] = useState({
    nome: '',
    descricao: '',
    localEvento: '',
    /* cep: '',
     numero: '',
     complemento: '',*/
    dataEvento: '',
    horaEvento: '',
    periodo: '',
    precoEntrada: '',
    totalParticipantes: '',

    usuario: null,
    categoria: null
  });


  const [successful, setSuccessful] = useState(false);
  const [message, setMessage] = useState();

  const [cep, setCep] = useState('');

  const setChosenCep = (data) => {
    setCep(data);
  }

  const [chosenImage, setChosenImage] = useState();

  const setChosenFile = (dataFile) => {
    setFile(dataFile);
  }

  const setImage = (dataImage) => {
    setChosenImage(dataImage);
  }

  const handleChange = (e) => {
    const name = e.target.name;
    const value = e.target.value;
    setFormData(formData => ({ ...formData, [name]: value }));
  }

  const getCategorias = () => {
    CategoriaService.findAll().then(
      (response) => {
        const categorias = response.data;
        setCategorias(categorias);
      }
    ).catch((error) => {
      console.log(error);
    })
  }

  useEffect(() => {
    if (_dbRecords.current) {
      getCategorias();
    }
    return () => {
      _dbRecords.current = false;
    }
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    setMessage("");
    setSuccessful(false);


    EventoService.create(file, formData, usuario).then(
      (response) => {
        setMessage(response.data.message);
        setSuccessful(true);
        setTimeout(() => navigate("/eventos"), 2000);
      }, (error) => {
        const resMessage =
          (error.response &&
            error.response.data &&
            error.response.data.message) ||
          error.message ||
          error.toString();

        setMessage(resMessage);
        setSuccessful(false);
      }
    );
  };

  return (
    <div className="container">
      <div className="card">
        <div style={{ marginBottom: '30px' }}>
          <Link to="/eventos" style={{ color: '#dc143c', textDecoration: 'none' }}>
            ← Voltar para Eventos
          </Link>
          <div style={{ textAlign: 'center', marginTop: '20px' }}>
            <span style={{ fontSize: '3rem' }}>🎉</span>
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Criar Novo Evento</h1>
          </div>
        </div>

        <form onSubmit={handleSubmit}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '20px' }}>
            <div>
              <div className="form-group">
                <label>Nome do Evento</label>
                <input
                  type="text"
                  name="nome"
                  value={formData.nome}
                  onChange={handleChange}
                  placeholder="Ex: Almoço Solidário"
                  required
                />
              </div>

              <div className="form-group">
                <label>Categoria de Evento</label>
                <select
                  name="categoria" defaultValue={0}
                  value={formData.categoria}
                  onChange={(e) => handleChange(e)}
                  style={{
                    width: '100%',
                    padding: '12px',
                    border: '2px solid #ddd',
                    borderRadius: '8px',
                    fontSize: '16px'
                  }}
                  required
                >
                  <option value={0} disabled>
                    Selecione a tipo...
                  </option>
                  {categorias?.map((categoria) => (
                    <option key={categoria.id} value={categoria.id}>
                      {categoria.nome}
                    </option>
                  ))}
                </select>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px' }}>
                <div className="form-group">
                  <label>Data do Evento</label>
                  <input
                    type="date"
                    name="dataEvento"
                    value={formData.dataEvento}
                    onChange={handleChange}
                    required
                  />
                </div>

                <div className="form-group">
                  <label>Horário</label>
                  <input
                    type="time"
                    name="horaEvento"
                    value={formData.horaEvento}
                    onChange={handleChange}
                    required
                  />
                </div>
              </div>

              <div className="form-group">
                <label>Local</label>
                <input
                  type="text"
                  name="localEvento"
                  value={formData.localEvento}
                  onChange={handleChange}
                  placeholder="Ex: Centro Comunitário"
                  required
                />
              </div>
            </div>
            <div>
              <div className="form-group">
                <label>Descrição do Evento</label>
                <textarea
                  name="descricao"
                  value={formData.descricao}
                  onChange={handleChange}
                  rows="4"
                  style={{
                    width: '100%',
                    padding: '12px',
                    border: '2px solid #ddd',
                    borderRadius: '8px',
                    fontSize: '16px',
                    resize: 'vertical'
                  }}
                  placeholder="Descreva o objetivo e detalhes do evento..."
                  required
                ></textarea>
              </div>

              <div className="form-group">
                <label>Preço da Entrada(R$)</label>
                <input
                  type="number"
                  name="precoEntrada"
                  value={formData.precoEntrada}
                  onChange={handleChange}
                  placeholder="0.00"
                  step="0.10"
                  required
                />
              </div>

              <div className="form-group">
                <label>Período</label>
                <input
                  type="text"
                  name="periodo"
                  value={formData.periodo}
                  onChange={handleChange}
                  placeholder="Período do Evento"
                  required
                />
              </div>

              <div className="form-group">
                <label>Total de Participantes</label>
                <input
                  type="number"
                  name="totalParticipantes"
                  value={formData.totalParticipantes || ''}
                  onChange={handleChange}
                  placeholder="Ex: 50"
                  min="1"
                  required
                />
              </div>
            </div>
          </div>

          <div>
            <label>Banner do Evento</label>
            
              <ImageUploader
                setFile={setFile}
                setImage={setImage}
                chosenImage={chosenImage} />
          
          </div>
          <div style={{ display: 'flex', gap: '15px', marginTop: '30px' }}>
            <Link to="/eventos" className="btn btn-secondary" style={{ flex: 1, textAlign: 'center' }}>
              Cancelar
            </Link>
            <button type="submit" className="btn btn-primary" style={{ flex: 1 }}>
              Criar Evento
            </button>
          </div>
          {message && (
            <div
              style={{
                backgroundColor: successful ? '#d4edda' : '#f8d7da',
                color: successful ? '#155724' : '#721c24',
                border: `1px solid ${successful ? '#c3e6cb' : '#f5c6cb'}`,
                padding: '15px',
                borderRadius: '5px',
                marginBottom: '20px'
              }}
              role="alert"
            >
              {message}
            </div>
          )}
        </form>
      </div>
    </div>
  );
};

export default CriarEvento;