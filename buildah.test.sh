#!/usr/bin/env bash

IMAGE_NAME=buildah-digest-demo
IMAGE_TAG=latest

#enable xtrace
set -x
#make xtrace line more clear
PS4=$'+\e[33m buildah❯ \e[0m+  '
#enable errexit
set -e


# Create a container
container=$(buildah from docker.io/library/alpine:3.10)

# Labels
buildah config --label maintainer="荒野無燈 <i@ttys3.net>" $container

TZ="Asia/Shanghai"

# Env
buildah config --env TZ=${TZ} $container

buildah run --network host $container sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
buildah run --network host $container apk add --no-cache --update tzdata
buildah run --network host $container rm -rf /var/cache/apk/*
buildah run --network host $container rm -rf /tmp/*
buildah run --network host $container ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

#test timezone
buildah run --network host $container sh -c 'echo "container date: " && date'

buildah config --workingdir "/" $container

buildah run --network host $container echo "build successfully"

buildah config --entrypoint '/bin/sh -c "echo hello, current time: $(date)"' $container

# Finally saves the running container to an image
buildah commit --format docker $container ${IMAGE_NAME}:${IMAGE_TAG}

buildah rm ${container}