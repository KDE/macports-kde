In order to make use of this MP software tree one simply has to clone it locally by e.g. 
---
$ mkdir ~/WC ; cd ~/WC
$ git clone git://anongit.kde.org/macports-kde MacPorts
$ cd MacPorts; ls
dports
README.txt
$ git log 47810c5 --oneline
47810c5 second part of rename: deleting original kde dir
cfdfc16 add dports subdir in order to isolate ports tree from other stuff
9e5752d new port konversation-devel for testing git revision f8205a08
$
---
and insert that repo's dports path in front of your default repo (assuming
/Users/USER as the user's home directory) into /opt/local/etc/macports/sources.conf:
---
$ (cd /opt/local/etc/macports/; diff -u sources.conf.old sources.conf)
--- sources.conf.old	2014-05-10 15:33:41.000000000 +0200
+++ sources.conf	2014-05-10 15:33:57.000000000 +0200
@@ -28,4 +28,5 @@
 # For proper functionality of various resources (port groups, mirror
 # sites, etc.), the primary MacPorts source must always be tagged
 # "[default]", even if switched from the default "rsync://" URL.
+file:///Users/USER/WC/MacPorts/dports
 rsync://rsync.macports.org/release/tarballs/ports.tar [default]
---
See [2] for more details. Don't forget to execute portindex in the directory
/Users/USER/WC/MacPorts/dports whenever you add or remove a Portfile to that tree.

See also contrib/user-setup for suggestions on how to set up a MacPorts bash
environment for users/maintainers.



[1] https://projects.kde.org/projects/playground/sdk/macports-kde/repository
[2] https://guide.macports.org/chunked/development.local-repositories.html
