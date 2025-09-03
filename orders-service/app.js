const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');

const app = express();
app.use(bodyParser.json());

const pool = new Pool({
  host: process.env.DB_HOST ?? 'host.docker.internal', // en ECS apuntarías al RDS endpoint
  user: process.env.DB_USER ?? 'postgres',
  database: process.env.DB_NAME  ?? 'postgres',
  password: process.env.DB_PASS ?? 'testing',
  port: process.env.DB_PORT ?? 5432,
});

const SECRET = "supersecretkey";

function authenticate(req, res, next) {
  const token = req.headers['authorization'];
  if (!token) return res.status(403).json({ message: 'Token required' });

  jwt.verify(token.replace("Bearer ", ""), SECRET, (err, decoded) => {
    if (err) return res.status(401).json({ message: 'Invalid token' });
    req.user = decoded;
    next();
  });
}

app.get('/', (req, res) => {
  res.json({ 
    status: 'Healthy', 
    service: 'orders-service',
    endpoints: [
      'GET  - /api/orders',
      'POST - /api/orders'
    ],
  });
});

app.get('/api/orders', authenticate, async (req, res) => {
  const result = await pool.query('SELECT * FROM orders WHERE username=$1', [req.user.username]);
  res.json(result.rows);
});

app.post('/api/orders', authenticate, async (req, res) => {
  const { item, quantity } = req.body;
  await pool.query('INSERT INTO orders (username, item, quantity) VALUES ($1, $2, $3)',
    [req.user.username, item, quantity]);
  res.json({ message: 'Order created' });
});

app.listen(3000, () => console.log('Orders service running on port 3000'));
