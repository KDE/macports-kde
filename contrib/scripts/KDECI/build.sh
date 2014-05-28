#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1

	(cd ~/scripts; \
		python2.7 tools/perform-build.py --project $1 --branchGroup kf5-qt5 \
		--platform darwin-mavericks --sources ${BDIR} )
	exit $?
else
        echo "Usage: $0 PROJECT_NAME"
	exit false
fi
