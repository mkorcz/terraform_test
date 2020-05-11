#!/bin/sh

SERVICE_NAME="httpd"
SERVICE_TAG="latest"
ECR_REPO_URL="875836252453.dkr.ecr.eu-north-1.amazonaws.com/${SERVICE_NAME}"

if [ "$1" = "dockerize" ]; then

    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 875836252453.dkr.ecr.eu-north-1.amazonaws.com
    aws ecr create-repository --repository-name ${SERVICE_NAME:?} || true
    docker build -t ${SERVICE_NAME}:${SERVICE_TAG} .
    docker tag ${SERVICE_NAME}:${SERVICE_TAG} ${ECR_REPO_URL}:${SERVICE_TAG}
    docker push ${ECR_REPO_URL}:${SERVICE_TAG}
elif [ "$1" = "deploy" ]; then
    terraform init
    terraform apply -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}"
elif [ "$1" = "plan" ]; then
    terraform init
    terraform plan -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}"
elif [ "$1" = "destroy" ]; then
    terraform init
    terraform destroy -var "docker_image_url=${ECR_REPO_URL}:${SERVICE_TAG}"
fi