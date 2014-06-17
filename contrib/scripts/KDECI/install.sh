#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1

	(
		cd ~/scripts;
		if ( ./prepare.sh $1 ); then
			./build.sh $1
			exit $?
		else
			exit 0
		fi
	)
else
        echo "Usage: $0 PROJECT_NAME"
	exit -1
fi
