#!/bin/sh

sudo HTTP_PROXY=http://127.0.0.1:7070 buildah login --authfile /etc/containers/auth.json docker.io

sudo HTTP_PROXY=http://127.0.0.1:7070 buildah push --digestfile /tmp/amd64.txt --authfile /etc/containers/auth.json buildah-multiarch-demo:amd64 docker://docker.io/80x86/buildah-multiarch-demo:amd64

sudo HTTP_PROXY=http://127.0.0.1:7070 buildah push --digestfile /tmp/arm64.txt --authfile /etc/containers/auth.json buildah-multiarch-demo:arm64 docker://docker.io/80x86/buildah-multiarch-demo:arm64

