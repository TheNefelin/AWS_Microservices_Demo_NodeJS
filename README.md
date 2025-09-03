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
- Clone Repository
```sh
git clone https://github.com/TheNefelin/AWS_Microservices_Demo_NodeJS.git
```
```sh
cd AWS_Microservices_Demo_NodeJS
```
- Build Docker Images
```sh
docker build -f auth-service/Dockerfile -t auth-service-repo ./auth-service
```
```sh
auth-service-repo:latest [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/auth-service-repo:latest
```
```sh
docker build -f catalog-service/Dockerfile -t catalog-service-repo ./catalog-service
```
```sh
catalog-service-repo:latest [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/catalog-service-repo:latest
```
```sh
docker build -f orders-service/Dockerfile -t orders-service-repo ./orders-service
```
```sh
orders-service-repo:latest [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/orders-service-repo:latest
```
- Login
```
aws ecr get-login-password --region [REGION] | docker login --username AWS --password-stdin [YOUR_ACCOUNT_ID].dkr.ecr.us-east-1.amazonaws.com
```
- Push to ECR
```sh
docker push [YOUR_ACCOUNT_ID].dkr.ecr.us-east-1.amazonaws.com/auth-service-repo:latest
```
```sh
docker push [YOUR_ACCOUNT_ID].dkr.ecr.us-east-1.amazonaws.com/catalog-service-repo:lates
```
```sh
docker push [YOUR_ACCOUNT_ID].dkr.ecr.us-east-1.amazonaws.com/orders-service-repo:lates
```
- Clean up
```sh
df -h
docker builder prune -f
df -h
df -hclear
cd ..
rm -rf AWS_Microservices_Demo_NodeJS
docker images
```

527237860774
us-east-1