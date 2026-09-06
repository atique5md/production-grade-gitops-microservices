#!/bin/bash

set -e

AWS_REGION="ap-south-1"
AWS_ACCOUNT_ID="703707151858"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
ECR_PREFIX="production-grade-gitops"

SERVICES=(
    "adservice"
    "checkoutservice"
    "currencyservice"
    "emailservice"
    "loadgenerator"
    "paymentservice"
    "productcatalogservice"
    "recommendationservice"
    "shippingservice"
)

echo "=========================================="
echo " Building and pushing microservices to ECR"
echo "=========================================="

for SERVICE in "${SERVICES[@]}"; do

    echo ""
    echo "=========================================="
    echo "Building: ${SERVICE}"
    echo "=========================================="

    docker build \
        -t "${ECR_PREFIX}/${SERVICE}:latest" \
        "./${SERVICE}"

    echo ""
    echo "Tagging: ${SERVICE}"

    docker tag \
        "${ECR_PREFIX}/${SERVICE}:latest" \
        "${ECR_REGISTRY}/${ECR_PREFIX}/${SERVICE}:latest"

    echo ""
    echo "Pushing: ${SERVICE}"

    docker push \
        "${ECR_REGISTRY}/${ECR_PREFIX}/${SERVICE}:latest"

    echo ""
    echo "✅ ${SERVICE} completed successfully"

done

echo ""
echo "=========================================="
echo " All services pushed successfully!"
echo "=========================================="
