#!/bin/bash
#
# This assumes the existence of branch mp-osx-ci branched off from production branch.
#
# The diff to current production will be put into the corresponding patch file in the MacPorts/KDE git clone.
#
# Only the included files/directories are considered.
#

INCLUDES="config tools"

git checkout mp-osx-ci
git diff production $INCLUDES >~/WC/GIT/macports-kde/contrib/scripts/KDECI/patch_mp-osx-ci.diff
