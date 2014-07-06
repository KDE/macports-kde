Shell scripts
=============

Shell scripts for easier building of Qt5/KF5 projects/frameworks:

These scripts are meant to call the KDE/CI scripts.

 prepare.sh       -  create build dir if not existing, clean it and check out code

 build.sh         -  start configure/build/deploy/test/cppcheck sequence

 install.sh       -  runs build.sh after prepare.sh signals that git pulled changes

 tier-install.sh  -  run install.sh for all frameworks specified in tier[1-4].fw

The current status of Qt5/KF5 builds is documented in [1].





Tools
=====

Figuring out which branch of a project has to be checked out for a specific
build configuration:
---
 $ ~/scripts/dependencies/tools/list_preferred_repo_branch kf5-qt5 kde/phonon
 frameworks
 $
---


Determine environment for running an application of a specific project by the
CI system:
---
 $ python2.7 tools/environment-generator.py --project kate --branchGroup kf5-qt5 --platform darwin-mavericks
---




People
======

This is a little list of people to be contacted for specific frameworks:

 phonon: apachelogger
 plasma-framework: notmart






[1] https://trac.macports.org/wiki/KDEProblems/KDEMacPortsCI/Status 
