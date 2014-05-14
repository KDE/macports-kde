This directory keeps some important files for users and maintainers of MacPorts
installations.


It assumes that the user has installed ports:
 ---
  bash
  bash-completion
  autojump
 ---

In order to let bash-completion work properly one needs to make sure that
Terminal.app starts MacPorts' bash as the default shell. This can be configured
by enabling in Terminal.app's preferences

	Settings/Shell/Startup

and setting the "Run command" to

	/opt/local/bin/bash -l

and you may disable the "Run inside shell" option.


.bash_profile integrates functions trac-get and trac-patch are useful for port
maintainers [1].


.macports/profile makes sure that your bash always has the correct paths set for
your MacPorts installation. In principle this file allows to select from several
existing MacPorts installations on your local machine. For instance, creating 
aliases like this
 ---
  alias AAA='PORTPREFIX=/opt/macports-test; source ~/.profile; echo $PATH
  alias SSS='unset PORTPREFIX; source ~/.profile; echo $PATH
 ---
allows to quickly switch between two MacPorts installations on the command line.
(Thanks to Pixilla!)


.inputrc brings quick bash history search by using up and down arrows 


The files assume that the user has the local MacPorts repository in
/Users/kdemac/WC/ i.e. the path to the ports subfolder should be
/Users/kdemac/WC/MacPorts/dports/.


Be aware of that the PI alias in .alias needs to be modified if you use another
location for the MacPorts repository.



[1] https://trac.macports.org/wiki/CommittersTipsAndTricks
