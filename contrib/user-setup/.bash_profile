[ -f ~/.profile ] && . ~/.profile

[ -f ~/.alias ] && . ~/.alias

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ -d ~/bin/arcanist/ ]; then
    export PATH=$PATH:~/bin/arcanist/bin/
    . ~/bin/arcanist/resources/shell/bash-completion
fi

export CLICOLOR=

set completion-ignore-case on

export HISTSIZE=500000
export HISTFILESIZE=500000
PROMPT_COMMAND='history -a'
export HISTCONTROL="ignoredups"
export HISTIGNORE="&:ls:[bf]g:exit"

#echo "Exporting PYTHONPATH..."
#export PYTHONPATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/

# -- shopt options, see shopt -p for all options --
shopt -s cdspell # Automatic spelling correction for `cd`
shopt -s cmdhist # Save multi-line cmd's as single line
shopt -s histappend # history list is appended to the file named by the value of the HISTFILE

# MacPorts trac
function trac-get {
    local url=$1
    local dir=$2

    if [ -z $dir ]; then
        dir=.
    fi

    curl "$url?format=raw" --create-dirs -o $dir/$(basename $1)
}

function trac-patch {
    local cmd=""
    while [[ $1 == -* ]]; do
        if [ "$1" == "--" ]; then
            break
        fi

        cmd="$cmd $1"
        shift
    done

    if [ -z $cmd ]; then
        cmd="-p0"
    fi

    trac-get $1
    patch $cmd < $(basename $1)
}


# autojump:
if [ -f /opt/local/etc/profile.d/autojump.sh ]; then
    . /opt/local/etc/profile.d/autojump.sh
fi





# SSH agent setup from http://stackoverflow.com/questions/18880024/start-ssh-agent-on-login

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
