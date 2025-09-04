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
├── products-service
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

## products-service
```sh
cd products-service
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

- ✔️ 3 repositorios en ECR
- ✔️ 1 base de datos en RDS PostgreSQL
- ✔️ 1 cluster en EKS
- ✔️ 1 node group con 2 nodos

## **Seciruty Group**:
### node-sg-bastion
- **Name**: node-sg-service
- **Description**: Access Node
- **VPC**: default
- **Inbound rules**:
  - SSH
    - Type: SSH
    - Protocol: TCP
    - Port range: 22
    - Destination type: Anywhere-IPv4
    - Destination: 0.0.0.0/0
    - Description: Acceso SSH
  - HTTP
    - Type: HTTP
    - Protocol: TCP
    - Port range: 80
    - Destination type: Custom
    - Destination: postgres-sg-rds
    - Description: Acceso web
- **Outbound rules**:
  - Outbound
    - Type: All traffic
    - Protocol: all
    - Port range: all
    - Destination type: Custom
    - Destination: 0.0.0.0/0
    - Description:

### postgres-sg-rds
- **Name**: postgres-sg-rds
- **Description**: Acceso postgreSQL
- **VPC**: default
- **Inbound rules**:
  - PostgreSQL
    - Type: PostgreSQL
    - Protocol: TCP
    - Port range: 5432
    - Destination type: Custom
    - Destination: node-sg-service
    - Description: Acceso PostgreSQL
- **Outbound rules**:
  - Outbound
    - Type: All traffic
    - Protocol: all
    - Port range: all
    - Destination type: Custom
    - Destination: 0.0.0.0/0
    - Description:

## **ECR**: Elastic Container Registry
### Repositorio - auth-service-repo
- **Repository name**: auth-service-repo
- **Image tag mutability**: Mutable
- **Mutable tag exclusions**:
- **Encryption configuration**: AES-256
- **View push commands**

> [!CAUTION]
> View push commands from `auth-service-repo`.

### Repositorio - products-service-repo
- **Repository name**: products-service-repo
- **Image tag mutability**: Mutable
- **Mutable tag exclusions**:
- **Encryption configuration**: AES-256
- **View push commands**

> [!CAUTION]
> View push commands from `products-service-repo`.

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
2. Modify aws-auth-service.yaml, aws-orders-service.yaml, aws-products-service.yaml and add <your_ecr_catalog_image> <your-rds-endpoint>
3. Upload aws_cloudshel_docker.sh aws-auth-service.yaml, aws-orders-service.yaml, aws-products-service.yaml files
4. Add execute permission to aws_cloudshel_docker.sh
```sh
chmod +x aws_cloudshel_docker.sh
```
5. Run aws_cloudshel_docker.sh
```sh
./aws_cloudshel_docker.sh
```

## **RDS**: Relational Database Service
### PostgreSQL
- **Creation method**: Standard create
- **Engine type**: PostgreSQL
- **Templates**: Sandbox
- **Availability and durability**: Single-AZ DB instance deployment (1 instance)
- **DB instance**: pgdb-rds
- **Master username**: postgres
- **Credentials management**: ********
- **Instance configuration**:
    - Burstable classes (includes t classes)
    - db.t3.micro
- **Allocated storage**: 20 GiB
- **Enable storage autoscaling**: check
- **Compute resource**: Don’t connect to an EC2 compute resource
- **VPC**: default
- **DB subnet group**: default
- **Public access**: No
- **Security groups**: postgres-sg-rds
- **Monitoring**: Database Insights - Standard
- **Enhanced Monitoring**: Disabled  

```sql
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

-- products-service
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC
);

INSERT INTO products 
    (name, price)
VALUES
    ('Laptop', 1200.50),
    ('Mouse', 25.99),
    ('Keyboard', 45.00),
    ('Monitor', 300.00),
    ('Headphones', 75.50);
```

## **EKS**: Elastic Kubernetes Service
### Clusters
- **Configuration options**: Custom configuration
- **Use EKS Auto Mode**_ uncheck
- **Name**: node-microservices-demo
- **Cluster IAM role**: LabEksClusterRole
- **EKS API**: check
- **ARC Zonal shift**: disabled
- **VPC**: default
- **Subnets**: default
- **Additional security groups**: node-sg-service
- **Cluster endpoint access**: Public and private

### Clusters - Compute - Add node group
- **Name**: ng-general
- **Node IAM role**: LabRole
- **AMI type**: Amazon Linux 2023 (x86_64)
- **Instance types**: t3.medium
- **Disk size**: 20 GiB
- **Desired size**: 2
- **Minimum size**: 2
- **Maximum size**: 4
- **Subnets** default

### Clusters - Resources - Workload ???

## **CloudShell**:
### Create .yaml and upload
- auth-service.yaml
- orders-service.yaml
- products-service.yaml

### Update Kubernete Config (Connect kubectl to EKS)
```sh
aws eks update-kubeconfig --name node-microservices-demo --region <REGION>
``` 
```sh
kubectl get nodes
```
```sh
kubectl apply -f aws-auth-service.yaml
kubectl apply -f aws-orders-service.yaml
kubectl apply -f aws-products-service.yaml
```
```sh
kubectl get all
```
- optional
```sh
kubectl delete all --all
kubectl delete configmap --all
kubectl delete secret --all
```

## **Api Gateway**:
### HTTP API - add Clouster - API server endpoint
- **API name**: node-microservices-demo-api
  - **Integrations**:
    - HTTP
    - Method: GET
    - URL endpoint: https:// + auth-service-LoadBalancer-External-IP + :3000
  - **Integrations**:
    - HTTP
    - Method: POST
    - URL endpoint: https:// + auth-service-LoadBalancer-External-IP + :3000/api/register 
  - **Integrations**:
    - HTTP
    - Method: POST
    - URL endpoint: https:// + auth-service-LoadBalancer-External-IP + :3000/api/login     
  - **Integrations**:
    - HTTP
    - Method: GET
    - URL endpoint: https:// + products-service-LoadBalancer-External-IP + :3000
  - **Integrations**:
    - HTTP
    - Method: ANY
    - URL endpoint: https:// + products-service-LoadBalancer-External-IP + :3000/api/products
  - **Integrations**:
    - HTTP
    - Method: GET
    - URL endpoint: https:// + orders-service-LoadBalancer-External-IP + :3000
  - **Integrations**:
    - HTTP
    - Method: ANY
    - URL endpoint: https:// + orders-service-LoadBalancer-External-IP + :3000/api/orders
- **Configure routes**:
  - Auth
    - **Method**: GET
    - **Resource path**: /auth
    - **Integration target**: URL endpoint Auth
  - Auth
    - **Method**: POST
    - **Resource path**: /api/register 
    - **Integration target**: URL endpoint Auth
  - Auth
    - **Method**: POST
    - **Resource path**: /api/login
    - **Integration target**: URL endpoint Auth
  - Products
    - **Method**: GET
    - **Resource path**: /products
    - **Integration target**: URL endpoint Products
  - Products
    - **Method**: ANY
    - **Resource path**: /api/products
    - **Integration target**: URL endpoint Products
  - Orders
    - **Method**: GET
    - **Resource path**: /orders
    - **Integration target**: URL endpoint Orders
  - Orders
    - **Method**: ANY
    - **Resource path**: /api/orders
    - **Integration target**: URL endpoint Orders
