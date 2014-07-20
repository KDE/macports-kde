#!/bin/bash

declare -i RETURN_VALUE

BUILD_DIR=/Users/marko/WC/KDECI-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1
	LOG=${BUILD_DIR}/logs/build/$1.log

#	[ -f ${LOG} ] && (echo "Removing old log file"; rm ${LOG})
	[ -f ${LOG} ] && rm ${LOG}

	echo "Calling build script"
	(cd ~/scripts; \
		python2.7 tools/perform-build.py --project $1 --branchGroup kf5-qt5 \
		--platform darwin-mavericks --sources ${BDIR} ) &> ${LOG}

	RETURN_VALUE=$?
#	echo "Return value = $RETURN_VALUE"
	if [ $RETURN_VALUE -eq 0 ]; then
		if [ "$1" == "kdoctools" -o "$1" == "kdelibs4support" ]; then
			echo "Copying $1's files to /Library/Application Support/ ..."

# We can't remove this anymore, since files might come from two frameworks
#			rm -rf /Library/Application\ Support/kf5/kdoctools/

			cp -Rp /opt/kde/install/darwin/mavericks/clang/kf5-qt5/frameworks/$1/inst/Library/Application\ Support/kf5 /Library/Application\ Support
		fi
	else
		echo "BUILD FAILED"
	fi
	echo "=========================================="
	exit $RETURN_VALUE
else
	echo "Usage: $0 PROJECT_NAME"
	exit -1
fi
