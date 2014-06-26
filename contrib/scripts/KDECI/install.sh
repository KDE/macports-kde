#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1

	(
		cd ~/scripts;
		if ( ./prepare.sh $1 || [ "x$2" == "xrebuild" ] ); then
			./build.sh $1
			exit $?
		else
			exit 0
		fi
	)
else
        echo "Usage: $0 PROJECT_NAME [rebuild]"
	exit -1
fi
