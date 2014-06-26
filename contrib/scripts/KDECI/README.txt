Shell scripts for easier building of Qt5/KF5 projects/frameworks:

These scripts are meant to call the KDE/CI scripts.

 prepare.sh       -  create build dir if not existing, clean it and check out code

 build.sh         -  start configure/build/deploy/test/cppcheck sequence

 install.sh       -  runs build.sh after prepare.sh signals that git pulled changes

 tier-install.sh  -  run install.sh for all frameworks specified in tier[1-4].fw

The current status of Qt5/KF5 builds is documented in [1].



[1] https://trac.macports.org/wiki/KDEProblems/KDEMacPortsCI/Status 
