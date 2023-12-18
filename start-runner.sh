#/usr/bin/env bash

docker run -it --name runner -v /var/run/docker.sock:/var/run/docker.sock --net=host --restart unless-stopped runner
