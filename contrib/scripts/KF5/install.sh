#!/bin/bash

declare -i counter
declare -i last_project
declare -i RET

SUCCESS_LOG=succeeded.txt

REBUILD=""
last_project=$#

if [ $# -gt 1 -a "${!#}" == "rebuild" ]; then
    REBUILD=y
    last_project=$#-1
elif [ $# -eq 1 -a  "$1" == "rebuild" ] || [ $# -eq 0 ]; then
    echo "Usage: $0 LIST_OF_PROJECT_NAMES [rebuild]"
    exit -1
fi

PROJECTS_ALL=projects-all.fw
rm $PROJECTS_ALL 2>/dev/null

for (( counter=0; counter <= 5; counter=counter+1 )); do
    egrep -v "^#.*" mp-osx-ci/tier${counter}.fw >> $PROJECTS_ALL
done

for (( counter=1; counter <= last_project; counter=counter+1 )); do
    egrep -q "^${!counter}$" $PROJECTS_ALL || echo "${!counter}" >> $PROJECTS_ALL
done

old_IFS=$IFS  # save the field separator
IFS=$'\n'     # new field separator, the end of line

RET=0

while read -r LINE
do
    PROJECT=`echo "$LINE" | awk {'print $1'}`
    if [ "$PROJECT" != "#" ]; then
        for (( counter=1; counter <= last_project; counter=counter+1 )); do
            if [ "$PROJECT" == "${!counter}" ]; then
                echo -n "kf5-$PROJECT: "
                (
                    PORTDIR=../../../dports/kde/kf5-${PROJECT}
                    if [ ! -d $PORTDIR ]; then
                        mkdir $PORTDIR
                    fi
                    pushd $PORTDIR >/dev/null
                    (
                        echo -n "Faking Portfile... "
                        cat > Portfile <<EOF
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# \$Id\$

PortSystem          1.0
EOF
                        echo -n "as porting aid? ..."
                        if ( grep -q "${PROJECT}" ../../../contrib/scripts/KF5/mp-osx-ci/tier4.fw ); then
                           echo "set kf5.portingAid yes" >> Portfile
                        fi
                        cat >> Portfile <<EOF
set KF5_PROJECT     $PROJECT
PortGroup           kf5 1.0

checksums           rmd160  abcdef \\
                    sha256  abcdef
EOF
                        sudo port -d checksum > checksum.log 2>/dev/null
                        sudo port clean >/dev/null

                        RMD160=`grep "Distfile checksum: .* rmd160" checksum.log | sed 's/.*rmd160 \(.*\)$/\1/'`
                        SHA256=`grep "Distfile checksum: .* sha256" checksum.log | sed 's/.*sha256 \(.*\)$/\1/'`
                        rm checksum.log

                        echo -n "creating correct one... "
                        cat > Portfile <<EOF
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# \$Id\$

PortSystem          1.0
EOF
                        echo -n "as porting aid? ..."
                        if ( grep -q "${PROJECT}" ../../../contrib/scripts/KF5/mp-osx-ci/tier4.fw ); then
                           echo "set kf5.portingAid yes" >> Portfile
                        fi
                        cat >> Portfile <<EOF
set KF5_PROJECT     $PROJECT
PortGroup           kf5 1.0

checksums           rmd160  $RMD160 \\
                    sha256  $SHA256

EOF
                    )
                    popd >/dev/null
                    pushd kde-build-metadata/tools >/dev/null
                    echo -n "appending dependencies... "
                    ./list_dependencies -d $PROJECT >deps.log
                    if ( ! grep -q "Error: Couldn't find the following modules:" deps.log ); then
                        DEPS=`egrep "frameworks/" deps.log | egrep -v "frameworks/$PROJECT" | sed 's#.*frameworks/\(.*\)$#port:kf5-\1 #' | awk '{printf "\\\\\n                    %s ", $1}'`
                        if [ -n "$DEPS" ]; then
                            echo -n "depends_lib-append $DEPS" >> ../../${PORTDIR}/Portfile
                        fi
                        PHONON=`egrep "kdesupport/phonon/phonon" deps.log`
                        if [ -n "$PHONON" ]; then
                            if [ -z "$DEPS" ]; then
                                echo -n "depends_lib-append " >> ../../${PORTDIR}/Portfile
                            fi
                            echo -e "\\" >> ../../${PORTDIR}/Portfile
                            echo -n "                    port:phonon-qt5 " >> ../../${PORTDIR}/Portfile
                        fi
                    fi
                    popd >/dev/null
                    MPDEPS=`grep "kf5-${PROJECT}: " dependencies-MacPorts | sed 's#^.*: \(.*\)$#\1#' | awk '{printf "\\\\\n                    %s ", $1}'`
                    if [ -n "$MPDEPS" ]; then
                        if [ -z "$DEPS" -a -z "$PHONON" ]; then
                            echo -n "depends_lib-append " >> ${PORTDIR}/Portfile
                        fi
                        echo -n "$MPDEPS" >> ${PORTDIR}/Portfile
                    fi

                    echo "installing... "
                    pushd $PORTDIR >/dev/null
                    (
                        sudo port install
                    )
                    popd >/dev/null
                )
                if [ $last_project -eq 1 ]; then
                    IFS=$old_IFS  # restore default field separator
                    rm $PROJECTS_ALL
                    # See allowed exit codes in http://tldp.org/LDP/abs/html/exitcodes.html#FTN.AEN23629
                    exit $RET
                fi
            fi
        done
    fi
done < $PROJECTS_ALL

IFS=$old_IFS  # restore default field separator

rm $PROJECTS_ALL
