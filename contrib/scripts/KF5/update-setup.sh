#!/bin/bash

# Checkout mp-osx-ci
if [ ! -d mp-osx-ci ]; then
        mkdir -p mp-osx-ci
fi
pushd mp-osx-ci
(
    if [ ! -d .git ]; then
        git clone git://anongit.kde.org/clones/websites/build-kde-org/kaning/mp-osx-ci.git .
    fi
    git fetch origin
    git checkout mp-osx-ci
)
popd

# Checkout kde-build-metadata
if [ ! -d kde-build-metadata ]; then
        mkdir -p kde-build-metadata
fi
pushd kde-build-metadata
(
    if [ ! -d .git ]; then
        git clone git://anongit.kde.org/kde-build-metadata.git .
    fi
    git fetch origin
    git checkout master
)
popd
