#!/bin/bash

FRAMEWORKS=~/scripts/tier1.fw
FAILED_LOG=~/scripts/failed-tier1.txt

if [ -f $FAILED_LOG ]; then
    rm $FAILED_LOG 
fi

echo "Installing ECM:"
#./install.sh extra-cmake-modules
if [ ! $? -eq 0 ]; then
    echo "extra-cmake-modules" > $FAILED_LOG
fi

echo "Installing all tier 1 frameworks:"

old_IFS=$IFS  # save the field separator  
IFS=$'\n'     # new field separator, the end of line

while read LINE
do
    FW=`echo "$LINE" | awk {'print $1'}`
    if [ "$FW" != "#" ]; then
	echo "Installing '$FW' ..."
        ./install.sh $FW
	if [ ! $? -eq 0 ]; then
            echo "Installing '$FW' FAILED !!!"
            echo "$FW" > $FAILED_LOG
	fi
    else
        FW=`echo "$LINE" | awk {'print $2'}`
        echo "Ignoring framework '$FW'."
    fi
done < $FRAMEWORKS

IFS=$old_IFS  # restore default field separator 

echo "Finished installing all tier 1 frameworks."
echo ; echo "======================================================"; echo

if [ -f $FAILED_LOG ]; then
   echo "Failed frameworks:"
   cat $FAILED_LOG
else
   echo "No framework failed." 
fi

