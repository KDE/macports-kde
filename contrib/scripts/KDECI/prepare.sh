#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1

	[ ! -d ${BDIR} ] && (echo "Creating still missing build directory..."; mkdir $BDIR )

	(cd ~/scripts; \
		python2.7 tools/prepare-environment.py --project $1 --branchGroup kf5-qt5 \
		--platform darwin-mavericks --sources ${BDIR} )
else
	echo "Usage: $0 PROJECT_NAME"
fi
