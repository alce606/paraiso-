import React, { useState, useEffect } from "react";
import './ImageUploader.css';

const ImageUploader = ({ setFile }) => {
    const [currentFile, setCurrentFile] = useState(undefined);
    const [previewImage, setPreviewImage] = useState(undefined);

    const selectFile = (event) => {
        const file = event.target.files[0];
        
        if (file) {
            // Limitar tamanho do arquivo a 1MB
            const maxSize = 1 * 1024 * 1024; // 1MB em bytes
            
            if (file.size > maxSize) {
                alert('Arquivo muito grande! Máximo permitido: 1MB');
                event.target.value = '';
                return;
            }
            
            const preview = URL.createObjectURL(file);
            setCurrentFile(file);
            setPreviewImage(preview);
        }
    };

    const deleteFile = () => {
        setCurrentFile(null);
        setPreviewImage(null);
        setFile(null);
        // Limpa o input file
        const fileInput = document.getElementById('uploadImage');
        if (fileInput) {
            fileInput.value = '';
        }
    };

    useEffect(() => {
        setFile(currentFile);
    }, [currentFile, setFile]);

    return (
        <div className="img-card">
            <div className="image-controls">
                <label htmlFor="uploadImage" className="btn-open-image">
                    <span>Buscar Imagem</span>
                    <input type="file" name="file" accept="image/*" id="uploadImage" onChange={selectFile} />
                </label>
                <p className="file-name">
                    {currentFile ? currentFile.name : 'Nenhum arquivo escolhido'}
                </p>
                <button type="button" className="btn-close-image" onClick={deleteFile}>
                    <span>Excluir Imagem</span>
                </button>
            </div>

            {previewImage && (
                <div className="preview-container">
                    <img id="preView" className="preview-image" src={previewImage} alt="Preview" />
                </div>
            )}
        </div>
    );
};

export default ImageUploader;
