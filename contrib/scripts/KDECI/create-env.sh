#!/bin/bash

if [ "x$1" == "x" ]; then
    echo "Usage: $0 PROJECT_NAME"
    exit -1
fi

echo "Creating environment as '$1.env' ..."
python2.7 tools/environment-generator.py --branchGroup kf5-qt5 --platform darwin-mavericks --project $1 >$1.env

echo "Environment variables set by $1:"
grep phonon $1.env | sed 's/^\(.*\)=.*$/\1/'
