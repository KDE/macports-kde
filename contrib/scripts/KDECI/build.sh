#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1
	LOG=${BUILD_DIR}/build/$1.log

	[ -f ${LOG} ] && (echo "Removing old log file"; rm ${LOG})

	echo "Calling build script"
	(cd ~/scripts; \
		python2.7 tools/perform-build.py --project $1 --branchGroup kf5-qt5 \
		--platform darwin-mavericks --sources ${BDIR} ) > ${LOG}

	if [ $? ]; then
		if [ "$1" == "kdoctools" ]; then
			echo "Copying kdoctools' files to /Library/Application Support/ ..."
			rm -rf /Library/Application\ Support/kf5/kdoctools/
			cp -Rp /opt/kde/install/darwin/mavericks/clang/kf5-qt5/frameworks/kdoctools/inst/Library/Application\ Support/kf5 /Library/Application\ Support
		fi
	fi
	exit $?
else
	echo "Usage: $0 PROJECT_NAME"
	exit -1
fi
