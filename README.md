# AWS Nodejs Microserives Demo

### Projects Structure
```
/microservices-demo
 ├── auth-service
 │    ├── app.js
 │    ├── package.json
 │    └── Dockerfile
 ├── orders-service
 │    ├── app.js (o main.py)
 │    ├── package.json
 │    └── Dockerfile
 ├── catalog-service
 │    ├── app.js (o main.py)
 │    ├── package.json
 │    └── Dockerfile
 ├── docker-compose.yml (para desarrollo local)
 └── README.md
```

## auth-service
```sh
cd auth-service
```
```sh
npm init -y
```
```sh
npm install express body-parser jsonwebtoken pg
```

## catalog-service
```sh
cd catalog-service
```
```sh
npm init -y
```
```sh
npm install express body-parser pg
```

## orders-service
```sh
cd orders-service
```
```sh
npm init -y
```
```sh
npm install express body-parser jsonwebtoken pg
```

## Docker-Compose Local RUN
```sh
docker-compose up --build
```
```sh
docker-compose down
```
```sh
docker-compose down --rmi all -v
```

## Thunder Client
- POST http://localhost:3001/register
```json
{
  "username": "alice",
  "password": "123"
}
```
- POST http://localhost:3001/login
```json
{
  "username": "alice",
  "password": "123"
}
```
- Respuesta esperada:
```json
{
  "token": "<JWT_TOKEN>"
}
```
- POST http://localhost:3002/orders
```json
{
  "Content-Type": "application/json",
  "Authorization": "Bearer <JWT_TOKEN>"
}
```
```json
{
  "item": "Laptop",
  "quantity": 1
}
```
- GET http://localhost:3002/orders
```json
{
  "Authorization": "Bearer <JWT_TOKEN>"
}
```
- POST http://localhost:3003/products
```json
{
  "name": "Keyboard",
  "price": 29.99
}
```
- GET http://localhost:3003/products
