const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');

const app = express();
app.use(bodyParser.json());

const pool = new Pool({
  host: process.env.DB_HOST ?? 'host.docker.internal', // en ECS apuntarías al RDS endpoint
  user: process.env.DB_USER ?? 'postgres',
  database: process.env.DB_NAME  ?? 'postgres',
  password: process.env.DB_PASS ?? 'testing',
  port: process.env.DB_PORT ?? 5432,
  ssl: {
    rejectUnauthorized: false
  }
});

app.get('/', (req, res) => {
  res.json({ 
    status: 'Healthy', 
    service: 'products-service',
    endpoints: [
      'GET  - /api/products',
      'POST - /api/products'
    ],
  });
});

app.get('/api/products', async (req, res) => {
  const result = await pool.query('SELECT * FROM products');
  res.json(result.rows);
});

app.post('/api/products', async (req, res) => {
  const { name, price } = req.body;
  await pool.query('INSERT INTO products (name, price) VALUES ($1, $2)', [name, price]);
  res.json({ message: 'Product added' });
});

app.listen(3000, () => console.log('Catalog service running on port 3000'));
