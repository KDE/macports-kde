#!/bin/bash
#
# This builds all tiers.
# 
###############################################################

# http://hacktux.com/bash/control/c
control_c()
# run if user hits control-c
{
#    echo -en "\n*** Ouch! Exiting ***\n"
    exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

if [ -n "$1" -a "X$1" != "Xrebuild"  ]; then
   echo "Usage: $0 [rebuild]"
   exit
fi

echo ; echo "------------------------------------------"; echo

echo "Installing all tiers:"

echo ; echo "------------------------------------------"; echo

declare -i counter

for (( counter=1; counter <=5; counter=counter+1 )); do
    ./tier-install.sh ${counter} $1
done

echo ; echo "=========================================="; echo

