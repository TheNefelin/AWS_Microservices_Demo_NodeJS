df -h
docker system prune -a --volumes -f
df -h

git clone https://github.com/TheNefelin/AWS_Microservices_Demo_NodeJS.git
cd AWS_Microservices_Demo_NodeJS

aws ecr get-login-password --region [REGION] | docker login --username AWS --password-stdin [YOUR_ACCOUNT_ID].dkr.ecr.us-east-1.amazonaws.com

docker build -f auth-service/Dockerfile -t auth-service-repo ./auth-service
auth-service-repo:latest [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/auth-service-repo:latest
docker push [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/auth-service-repo:latest

df -h
docker system prune -a --volumes -f
df -h

docker build -f catalog-service/Dockerfile -t catalog-service-repo ./catalog-service
catalog-service-repo:latest [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/catalog-service-repo:latest
docker push [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/catalog-service-repo:latest

df -h
docker system prune -a --volumes -f
df -h

docker build -f orders-service/Dockerfile -t orders-service-repo ./orders-service
orders-service-repo:latest [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/orders-service-repo:latest
docker push [YOUR_ACCOUNT_ID].dkr.ecr.[REGION].amazonaws.com/orders-service-repo:latest

df -h
docker builder prune -f
df -h
df -hclear
cd ..
rm -rf AWS_Microservices_Demo_NodeJS
docker images
