#!/bin/bash

[ "$1" = "-q" ] && set +x || set -x
set -e

NODE_IMAGE="node:12.3.0"

function log_n_fail {
  echo $1
  exit 1
}

pwd | sed 's;.*/;;g' | grep studio-frontend || \
  log_n_fail "Make sure your working directory is the studio-frontend repo"

CONTAINER_NAME="node_$RANDOM"

docker run -it -d --name=$CONTAINER_NAME $NODE_IMAGE || \
  log_n_fail "Couldn't start container $NODE_IMAGE"

docker cp `pwd` $CONTAINER_NAME:/ || log_n_fail "Couldn't copy sources to container"

docker exec -it $CONTAINER_NAME sh -c "
  cd /studio-frontend && \
  npm install && \
  rm -rf dist && \
  npm run build
" || log_n_fail "Couldn't build studio-frontend package"

rm -rf dist

docker cp $CONTAINER_NAME:/studio-frontend/dist . || \
  log_n_fail "Couldn't copy dist folder from container"

docker stop $CONTAINER_NAME || log_n_fail "Couldn't stop the container"
docker rm $CONTAINER_NAME || log_n_fail "Couldn't remove the container"

echo "Build succeed!"

