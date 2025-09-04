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
  ssl: {
    rejectUnauthorized: false
  }
});

const SECRET = "supersecretkey";

app.get('/', (req, res) => {
  res.json({ 
    status: 'Healthy', 
    service: 'auth-service',
    endpoints: [
      'POST - /api/register',
      'POST - /api/login'
    ],
  });
});

app.post('/api/register', async (req, res) => {
  const { username, password } = req.body;
  await pool.query('INSERT INTO users (username, password) VALUES ($1, $2)', [username, password]);
  res.json({ message: 'User registered' });
});

app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;
  const result = await pool.query('SELECT * FROM users WHERE username=$1 AND password=$2', [username, password]);
  if (result.rows.length > 0) {
    const token = jwt.sign({ username }, SECRET, { expiresIn: '1h' });
    res.json({ token });
  } else {
    res.status(401).json({ message: 'Invalid credentials' });
  }
});

app.listen(3000, () => console.log('Auth service running on port 3000'));
