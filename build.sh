#!/usr/bin/env bash
if [[ -d $1 ]]; then
    TAG=$1
else
    TAG="0.1.0"
fi

ACR="pmacreus"
REPO="container-app-playground"
IMG="${REPO}:${TAG}"
ACR_IMG="${ACR}.azurecr.io/${IMG}"

az acr login -n $ACR
docker buildx build --platform linux/amd64 -t $ACR_IMG ./src
docker push $ACR_IMG

echo ""
echo "======================"
echo ""
echo "Image pushed:"
echo ""
echo $ACR_IMG
echo ""
echo "======================"