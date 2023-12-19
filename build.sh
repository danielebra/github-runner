#/usr/bin/env bash

docker build -t runner . --build-arg ORGANIZATION=$ORGANIZATION --build-arg TOKEN=$TOKEN --build-arg DOCKER_GID=$(getent group docker | cut -d ':' -f 3)
