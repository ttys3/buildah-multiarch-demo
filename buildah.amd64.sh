#!/usr/bin/env bash

IMAGE_NAME=buildah-multiarch-demo
IMAGE_TAG=amd64

#enable xtrace
set -x
#make xtrace line more clear
PS4=$'+\e[33m buildah❯ \e[0m+  '
#enable errexit
set -e


# Create a container
container=$(buildah from docker.io/80x86/base-alpine:3.11-amd64)

# Labels
buildah config --label maintainer="荒野無燈 <i@ttys3.net>" $container

TZ="Asia/Shanghai"

# Env
buildah config --env TZ=${TZ} $container

# demo: do the work
buildah run --network host $container sh -c 'date > /etc/amd64-build'

#test timezone
buildah run --network host $container sh -c 'echo "container date: " && date'

buildah config --workingdir "/" $container

buildah run --network host $container echo "build successfully"

buildah config --entrypoint '/bin/sh -c "echo hello, current time: $(date)"' $container

# Finally saves the running container to an image
buildah commit --format docker $container ${IMAGE_NAME}:${IMAGE_TAG}

buildah rm ${container}