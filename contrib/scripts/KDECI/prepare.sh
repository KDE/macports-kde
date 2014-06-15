#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1
	LOG=${BDIR}/KDECI-build.log

	[ ! -d ${BDIR} ] && (echo "Creating still missing build directory..."; mkdir $BDIR )
	[ ! -f ${LOG} ] && rm ${LOG}

	(cd ~/scripts; \
		python2.7 tools/prepare-environment.py --project $1 --branchGroup kf5-qt5 \
		--platform darwin-mavericks --sources ${BDIR} > ${LOG})

	grep "Receiving objects:" ${LOG} > /dev/null

	exit $?
else
	echo "Usage: $0 PROJECT_NAME"
	exit false
fi
