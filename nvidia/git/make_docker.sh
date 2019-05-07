#!/bin/bash
set -e
LATEST_GIT_VERSION=`git ls-remote https://github.com/alsvinn/alsvinn.git HEAD | awk '{ print $1}'`
docker build .  -t alsvinn/alsvinn_cuda_git:latest -t alsvinn/alsvinn_cuda_git:${LATEST_GIT_VERSION} --build-arg ALSVINN_GIT_VERSION=${LATEST_GIT_VERSION}
docker login
docker push alsvinn/alsvinn_cuda_git:${LATEST_GIT_VERSION}
docker push alsvinn/alsvinn_cuda_git:latest
