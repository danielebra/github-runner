#/usr/bin/env bash

docker build -t runner . --build-arg ORGANIZATION=$ORGANIZATION --build-arg TOKEN=$TOKEN
