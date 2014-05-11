
# MacPorts Installer addition on 2014-04-06_at_12:58:31: adding an appropriate PATH variable for use with MacPorts.
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

#instead use Brad's approach:
if [ -f ~/.macports/profile ]; then
  . ~/.macports/profile
fi

