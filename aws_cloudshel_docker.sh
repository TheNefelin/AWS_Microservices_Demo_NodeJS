# chmod +x aws_cloudshel_docker.sh
# ./aws_cloudshel_docker.sh

REGION=us-east-1
YOUR_ACCOUNT_ID=123456789012

df -h
docker system prune -a --volumes -f
df -h

git clone https://github.com/TheNefelin/AWS_Microservices_Demo_NodeJS.git
cd AWS_Microservices_Demo_NodeJS

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${YOUR_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

docker build -f auth-service/Dockerfile -t auth-service-repo ./auth-service
docker tag auth-service-repo:latest ${YOUR_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/auth-service-repo:latest
docker push ${YOUR_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/auth-service-repo:latest

docker build -f orders-service/Dockerfile -t orders-service-repo ./orders-service
docker tag orders-service-repo:latest ${YOUR_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/orders-service-repo:latest
docker push ${YOUR_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/orders-service-repo:latest

docker build -f products-service/Dockerfile -t products-service-repo ./products-service
docker tag products-service-repo:latest ${YOUR_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/products-service-repo:latest
docker push ${YOUR_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/products-service-repo:latest

aws eks update-kubeconfig --name node-microservices-demo --region ${REGION}

kubectl get nodes

kubectl apply -f aws-auth-service.yaml
kubectl apply -f aws-orders-service.yaml
kubectl apply -f aws-products-service.yaml

kubectl get all

df -h
docker builder prune -f
df -h

cd ..
rm -rf AWS_Microservices_Demo_NodeJS
docker images

# kubectl delete all --all
# kubectl delete configmap --all
# kubectl delete secret --all

# =========================================================================
# docker rmi auth-service-repo products-service-repo orders-service-repo
# docker system prune -a --volumes -f
# kubectl delete deployment auth-service
# kubectl delete deployment orders-service
# kubectl delete deployment products-service
# kubectl delete svc auth-service
# kubectl delete svc orders-service
# kubectl delete svc products-service
# kubectl delete pod <pod-name>

# kubectl delete all --all
# # Borrar Deployments
# kubectl delete deployments --all
# # Borrar Pods
# kubectl delete pods --all
# # Borrar Services (incluye los LoadBalancers en AWS)
# kubectl delete svc --all
# # Borrar ReplicaSets
# kubectl delete rs --all
