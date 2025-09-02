-- auth-service
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- orders-service
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    item VARCHAR(100),
    quantity INT
);

-- catalog-service
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC
);
