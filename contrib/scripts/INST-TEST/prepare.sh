#!/bin/bash

BUILD_DIR=/Users/marko/WC/KDETST-builds

if [ "x$1" != "x" ]; then
	BDIR=${BUILD_DIR}/$1
	LOG=${BUILD_DIR}/logs/prepare/$1.log
	GITREPO=git://anongit.kde.org/$1.git

	echo "------------------------------------------"
	echo "Project: $1"

#	[ -f ${LOG} ] && (echo "Removing old log file"; rm ${LOG})
	[ -f ${LOG} ] && rm ${LOG}

	echo "Calling prepare script"
	(
		cd ~/scripts;
#		echo "Writing log to '${LOG}' ..."
		(
			[ ! -d ${BDIR} ] && git clone ${GITREPO} ${BDIR}
			cd ${BDIR}; git pull
			(git branch --remote | grep frameworks) && git checkout frameworks
		) &> ${LOG}
	)
	# We assume always successful (clon|pull)ing for now:
	exit 0
else
	echo "Usage: $0 PROJECT_NAME"
	exit -1
fi
