#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1
	LOG=${BUILD_DIR}/logs/prepare/$1.log

	echo "Project: $1"
	echo "------------------------------------------"

	[ ! -d ${BDIR} ] && (echo "Creating still missing build directory..."; mkdir ${BDIR})
	[ -f ${LOG} ] && (echo "Removing old log file"; rm ${LOG})

	echo "Calling prepare script"
	(
		cd ~/scripts;
		echo "Writing log to '${LOG}' ..."
		( python2.7 tools/prepare-environment.py --project $1 --branchGroup kf5-qt5 \
			--platform darwin-mavericks --sources ${BDIR} ) 2> ${LOG}
	)

	if [ $? ]; then
		grep "From git" ${LOG} > /dev/null
		exit $?
	else
		exit 1
	fi
else
	echo "Usage: $0 PROJECT_NAME"
	exit -1
fi
