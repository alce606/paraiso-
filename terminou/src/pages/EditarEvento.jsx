import { useEffect, useRef, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import logo from '../assets/images/blz_perfil.png';
import EventoService from '../services/EventoService';
import ImageUploader from '../components/ImageUploader/ImageUploader';

const EditarEvento = () => {
  const { id } = useParams(); // ID do evento para edição
  const navigate = useNavigate();
  const _dbRecords = useRef(true);

  const initialObject = {
    id: null,
    nome: "",
    descricao: "",
    localEvento: "",
    dataEvento: "",
    horaEvento: "",
    periodo: "",
    foto: null,
    precoEntrada: 0,
    totalParticipantes: 0,
    dataCadastro: "",
    usuario: {
      id: null
    },
    categoria: {
      id: null
    },
    statusEvento: ""
  };

  const [evento, setEvento] = useState(initialObject);

  useEffect(() => {
    if (_dbRecords.current) {
      EventoService.findById(id)
        .then(response => {
          const evento = response.data;
          setEvento(evento);
          console.log(evento);
        })
        .catch(e => {
          console.log(e);
        });
    } return () => {
      _dbRecords.current = false;
    }
  }, [id]);

  const handleChange = (e) => {
    const name = e.target.name;
    const value = e.target.value;
    setEvento(evento => ({ ...evento, [name]: value }));
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    EventoService.alterar(file, id, evento).then(
      (response) => {
        navigate('/eventos');
      }, (error) => {
        const resMessage =
          (error.response &&
            error.response.data &&
            error.response.data.message) ||
          error.message ||
          error.toString();
      }
    )
  };

  const handleDelete = () => {
    if (window.confirm('Tem certeza que deseja excluir este evento?')) {
      EventoService.deletar(id).then(
        (response) => {
          alert('Evento excluído com sucesso!');
          navigate('/eventos');
        },
        (error) => {
          alert('Erro ao excluir evento!');
          console.log(error);
        }
      );
    }
  };



  const [file, setFile] = useState("");
  const [chosenImage, setChosenImage] = useState();
  const setChosenFile = (dataFile) => {
    setFile(dataFile);
  }
  const setImage = (dataImage) => {
    setChosenImage(dataImage);
  }

  return (
    <div className="container">
      <div className="card">
        <div style={{ marginBottom: '30px' }}>
          <Link to="/eventos" style={{ color: '#dc143c', textDecoration: 'none' }}>
            ← Voltar para Eventos
          </Link>
          <div style={{ textAlign: 'center', marginTop: '20px' }}>
            <div>
              <img
                src={evento.foto ? 'data:image/jpeg;base64,' + evento.foto : logo}
                alt="Imagem atual"
                style={{
                  maxWidth: '100%',
                  height: 'auto',
                  borderRadius: '8px',
                  marginBottom: '10px'
                }}
              />
            </div>
            <ImageUploader setFile={setChosenFile} />
            {chosenImage && (
              <img
                src={chosenImage}
                alt="Pré-visualização"
                style={{
                  maxWidth: '100%',
                  height: 'auto',
                  marginTop: '10px',
                  borderRadius: '8px',
                  boxShadow: '0 4px 8px rgba(0,0,0,0.1)'
                }}
              />
            )}
            <h1 style={{ color: '#dc143c', marginTop: '10px' }}>Editar Evento</h1>
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
                  value={evento.nome}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="form-group">
                <label>Descrição</label>
                <textarea
                  name="descricao"
                  value={evento.descricao}
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
                  required
                ></textarea>
              </div>

              <div className="form-group">
                <label>Local do Evento</label>
                <input
                  type="text"
                  name="localEvento"
                  value={evento.localEvento}
                  onChange={handleChange}
                  required
                />
              </div>


            </div>

            <div>
              <div className="form-group">
                <label>Data do Evento</label>
                <input
                  type="date"
                  name="dataEvento"
                  value={evento.dataEvento}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="form-group">
                <label>Horário do Evento</label>
                <input
                  type="time"
                  name="horaEvento"
                  value={evento.horaEvento}
                  onChange={handleChange}
                />
              </div>

              <div className="form-group">
                <label>Período</label>
                <input
                  type="text"
                  name="periodo"
                  value={evento.periodo}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="form-group">
                <label>Preço de Entrada</label>
                <input
                  type="number"
                  name="precoEntrada"
                  value={evento.precoEntrada}
                  onChange={handleChange}
                  step="0.01"
                />
              </div>



              <div className="form-group">
                <label>Total de Participantes</label>
                <input
                  type="number"
                  name="totalParticipantes"
                  value={evento.totalParticipantes}
                  onChange={handleChange}
                  min="1"
                />
              </div>
            </div>
          </div>

          <div style={{ display: 'flex', gap: '15px', marginTop: '30px' }}>
            <button
              type="button"
              onClick={handleDelete}
              style={{
                background: '#dc3545',
                color: 'white',
                border: 'none',
                padding: '12px 24px',
                borderRadius: '25px',
                cursor: 'pointer',
                fontWeight: 'bold'
              }}
            >
              🗑️ Excluir
            </button>
            <Link to="/eventos" className="btn btn-secondary" style={{ flex: 1, textAlign: 'center' }}>
              Cancelar
            </Link>
            <button type="submit" className="btn btn-primary" style={{ flex: 1 }}>
              💾 Salvar Alterações
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default EditarEvento;
