#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1

	(cd ~/scripts; ./prepare.sh $1 && ./build.sh $1 )
	exit $?
else
        echo "Usage: $0 PROJECT_NAME"
	exit false
fi
