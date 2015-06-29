#!/bin/bash
#
# This builds all projects of a specific tier as defined in
# tier definition files ./tier[0-5].fw
# 
# (prepend a hash+space in front of project name to disable it)
# 
###############################################################

# We need this result for exit_function()
RES=1

# http://hacktux.com/bash/control/c
control_c()
# run if user hits control-c
{
    echo -en "\n*** $0 interrupted: Exiting ***\n"
    exit_function
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

if [ -z "$1" ] || [ $1 -lt 0 ] || [ $1 -gt 5 ]; then
    echo "Usage: $0 TIER_LEVEL [START_PROJECT] [rebuild]"
    exit
fi

TIER=$1

exit_function()
{
    IFS=$old_IFS  # restore default field separator 

    echo "--------------------------------------------------"; echo
    echo "Finished installing all tier $TIER projects."
    echo ; echo "=================================================="; echo

    if [ -f $FAILED_LOG ]; then
        echo "Failed projects:"
        echo
        cat $FAILED_LOG
    else
        echo "No project failed."
    fi
    echo ; echo "--------------------------------------------------"; echo
    if [ -f $SUCCESS_LOG ]; then
        echo "Succeeded projects:"
        echo
        cat $SUCCESS_LOG
    fi

    echo ; echo "=================================================="; echo

    exit $RES
}

PROJECTS=mp-osx-ci/tier$1.fw
FAILED_LOG=failed-tier$1.txt
SUCCESS_LOG=succeeded.txt

if [ -f $FAILED_LOG ]; then
    rm $FAILED_LOG
fi
if [ -f $SUCCESS_LOG ]; then
    rm $SUCCESS_LOG
fi

echo ; echo "--------------------------------------------------"; echo

echo "Installing all tier $1 projects:"

REBUILD=""
START_PROJECT=""

if [ $# -eq 2 -a "$2" == "rebuild" ]; then
    REBUILD=$2
elif [ $# -eq 3 -a "$3" == "rebuild" ]; then
    REBUILD=$3
    START_PROJECT=$2
elif [ $# -eq 2 ]; then
    START_PROJECT=$2
fi

if [ -n "$START_PROJECT" ]; then
    echo "Starting at project '$START_PROJECT'"
fi

old_IFS=$IFS  # save the field separator  
IFS=$'\n'     # new field separator, the end of line

while read -r LINE
do
    PROJECT=`echo "$LINE" | awk {'print $1'}`
    if [ "$PROJECT" != "#" ]; then
        if [ -z "$START_PROJECT" ] || [ -n "$START_PROJECT" -a "$PROJECT" == "$START_PROJECT" ]; then
            START_PROJECT=""
            # avoid called shell script to read standard input
            # ( http://stackoverflow.com/questions/9393038/ssh-breaks-out-of-while-loop-in-bash )
            ./install.sh $PROJECT $REBUILD < /dev/null
            RES=$?
            # Do not append failed project to list if it was not on branch-group (code 201)
            if [ ! $RES -eq 0 ] && [ $RES -ne 201 ]; then
                echo " $PROJECT" >> $FAILED_LOG
            fi
            # Error code 202 are LOOKUP errors:
            [ $RES -eq 202 ] && exit $RES
        fi
    else
        PROJECT=`echo "$LINE" | awk {'print $2'}`
        echo "--------------------------------------------------"
        echo "Ignoring '$PROJECT'."
    fi
done < $PROJECTS

exit_function
