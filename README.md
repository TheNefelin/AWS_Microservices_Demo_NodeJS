# AWS Nodejs Microserives Demo

### Projects Structure
```
/microservices-demo
├── auth-service
│   ├── .dockerignore
│   ├── app.js
│   ├── Dockerfile
│   ├── package-lock.json 
│   └── package.json
├── orders-service
│   ├── .dockerignore
│   ├── app.js
│   ├── Dockerfile
│   ├── package-lock.json 
│   └── package.json
├── catalog-service
│   ├── .dockerignore
│   ├── app.js
│   ├── Dockerfile
│   ├── package-lock.json 
│   └── package.json
├── .gitignore
├── aws_cloudshel_docker.sh
├── docker-compose.yml
├── PostgreSQL.sql
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

---

# AWS

## **ECR**: Elastic Container Registry
### Repositorio - auth-service-repo
- **Repository name**: auth-service-repo
- **Image tag mutability**: Mutable
- **Mutable tag exclusions**:
- **Encryption configuration**: AES-256
- **View push commands**

> [!CAUTION]
> View push commands from `auth-service-repo`.

### Repositorio - catalog-service-repo
- **Repository name**: catalog-service-repo
- **Image tag mutability**: Mutable
- **Mutable tag exclusions**:
- **Encryption configuration**: AES-256
- **View push commands**

> [!CAUTION]
> View push commands from `catalog-service-repo`.

### Repositorio - orders-service-repo
- **Repository name**: orders-service-repo
- **Image tag mutability**: Mutable
- **Mutable tag exclusions**:
- **Encryption configuration**: AES-256
- **View push commands**

> [!CAUTION]
> View push commands from `orders-service-repo`.

## **CloudShell**:
1. Modify aws_cloudshel_docker.sh then add [YOUR_ACCOUNT_ID] and [REGION]
2. Run aws_cloudshel_docker.sh
3. [Repo](git clone https://github.com/TheNefelin/AWS_Microservices_Demo_NodeJS.git)
- Clone Repository

