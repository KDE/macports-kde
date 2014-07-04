#!/bin/bash

CORES=7

declare -i RETURN_VALUE

BUILD_DIR=/Users/marko/WC/KDETST-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1
	LOG=${BUILD_DIR}/logs/build/$1.log

#	[ -f ${LOG} ] && (echo "Removing old log file"; rm ${LOG})
	[ -f ${LOG} ] && rm ${LOG}

	echo "Calling build script"
	( cd ${BDIR}
		[ ! -d build ] && mkdir build || rm -rf build/*
		cd build; cmake ..; make -j $CORES; sudo make install ) &> ${LOG}
	grep -q "Installing" ${LOG}

	echo "=========================================="
	exit $?
else
	echo "Usage: $0 PROJECT_NAME"
	exit -1
fi
