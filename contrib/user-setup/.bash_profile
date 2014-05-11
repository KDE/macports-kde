[ -f ~/.profile ] && . ~/.profile

[ -f ~/.alias ] && . ~/.alias

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi
export CLICOLOR=

set completion-ignore-case on

export HISTSIZE=500000
export HISTFILESIZE=500000
PROMPT_COMMAND='history -a'
export HISTCONTROL="ignoredups"
export HISTIGNORE="&:ls:[bf]g:exit"

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
