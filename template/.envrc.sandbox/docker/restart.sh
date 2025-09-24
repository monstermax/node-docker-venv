#!/bin/bash

cd `dirname $0`


if [ "$VENV_CONTAINER" = "" ]; then
    echo "Error missing VENV_CONTAINER"
    exit 1
fi


./stop.sh

./run.sh

