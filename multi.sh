#!/bin/sh

IMAGE_NAME=80x86/buildah-multiarch-demo

sudo HTTP_PROXY=http://127.0.0.1:7070 buildah rmi ${IMAGE_NAME}:latest

sudo HTTP_PROXY=http://127.0.0.1:7070 buildah manifest create ${IMAGE_NAME}:latest

sudo buildah manifest add --os linux --arch amd64 ${IMAGE_NAME}:latest docker://docker.io/${IMAGE_NAME}:amd64
sudo buildah manifest add --os linux --arch arm64 ${IMAGE_NAME}:latest docker://docker.io/${IMAGE_NAME}:arm64

#sudo HTTP_PROXY=http://127.0.0.1:7070 buildah manifest annotate --arch amd64 --os linux ${IMAGE_NAME}:latest $(cat /tmp/amd64.txt)
#sudo HTTP_PROXY=http://127.0.0.1:7070 buildah manifest annotate --arch arm64 --os linux ${IMAGE_NAME}:latest $(cat /tmp/arm64.txt)

sudo HTTP_PROXY=http://127.0.0.1:7070 buildah manifest push --authfile /etc/containers/auth.json --purge ${IMAGE_NAME}:latest docker://docker.io/${IMAGE_NAME}:latest