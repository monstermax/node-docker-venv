#!/bin/bash

cd `dirname $0`


ENV_DIR=$(realpath ./../..)
#echo ENV_DIR=$ENV_DIR
PROJECT_NAME=$(basename $ENV_DIR)


# Build
#echo $PROJECT_NAME
docker build -t sandbox_${PROJECT_NAME} .
