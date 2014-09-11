#!/bin/bash

# http://hacktux.com/bash/control/c
control_c()
# run if user hits control-c
{
    cd ~/scripts
    exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

# Grab all ports needed for installation from the commented list:
PORTS=`cat ports-list.txt | egrep -v "^(#.*|\w*)$" | xargs`
sudo port install $PORTS
