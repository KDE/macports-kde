#!/bin/bash
#
# This builds all frameworks of a specific tier as defined in
# tier definition files ./tier[1-3].fw
# 
# (prepend a hash in front of framework name to disable it)
# 
###############################################################

# http://hacktux.com/bash/control/c
control_c()
# run if user hits control-c
{
    echo -en "\n*** Ouch! Exiting ***\n"
    exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

if [ -z "$1" ] || [ $1 -lt 1 ] || [ $1 -gt 5 ]; then
   echo "Usage: $0 TIER_LEVEL [rebuild]"
   exit
fi

FRAMEWORKS=~/scripts/tier$1.fw
FAILED_LOG=~/scripts/failed-tier$1.txt

if [ -f $FAILED_LOG ]; then
    rm $FAILED_LOG 
fi

echo ; echo "------------------------------------------"; echo

INSTALL_ECM=false
if [ INSTALL_ECM == "true" ]; then 
    echo "Installing ECM:"
    # avoid called shell script to read standard input
    # ( http://stackoverflow.com/questions/9393038/ssh-breaks-out-of-while-loop-in-bash )
    ./install.sh extra-cmake-modules < /dev/null
    if [ ! $? -eq 0 ]; then
        echo "extra-cmake-modules" > $FAILED_LOG
    fi
else
    echo "Ignoring ECM installation."
fi

echo ; echo "------------------------------------------"; echo

echo "Installing all tier $1 frameworks:"

old_IFS=$IFS  # save the field separator  
IFS=$'\n'     # new field separator, the end of line

while read -r LINE
do
    FW=`echo "$LINE" | awk {'print $1'}`
    if [ "$FW" != "#" ]; then
#	echo "Installing '$FW' ..."
        # avoid called shell script to read standard input
        ./install.sh $FW $2 < /dev/null
	if [ ! $? -eq 0 ]; then
#            echo "Installing '$FW' FAILED !!!"
            echo "$FW" >> $FAILED_LOG
	fi
    else
        FW=`echo "$LINE" | awk {'print $2'}`
        echo "------------------------------------------"
        echo "Ignoring framework '$FW'."
    fi
done < $FRAMEWORKS

IFS=$old_IFS  # restore default field separator 

echo ; echo "=========================================="; echo
echo "Finished installing all tier $1 frameworks."
echo ; echo "=========================================="; echo

if [ -f $FAILED_LOG ]; then
   echo "Failed frameworks:"
   echo
   cat $FAILED_LOG
else
   echo "No framework failed." 
fi

echo ; echo "=========================================="; echo

