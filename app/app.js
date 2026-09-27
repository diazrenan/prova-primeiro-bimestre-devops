const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;
const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PORT = process.env.DB_PORT || 5432;
const DB_NAME = process.env.DB_NAME || 'reservas';

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    servico: 'prova primeiro bimestre',
    aluno: 'Renan Dias',
    ra: '6325033',
    status: 'online',
    banco: `${DB_HOST}:${DB_PORT}/${DB_NAME}`,
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime(),
    servicos: {
      api: 'online',
      banco: `${DB_HOST}:${DB_PORT}`
    }
  });
});

app.listen(PORT, () => {
  console.log(`API de Reservas rodando na porta ${PORT}`);
  console.log(`Banco: ${DB_HOST}:${DB_PORT}/${DB_NAME}`);
});