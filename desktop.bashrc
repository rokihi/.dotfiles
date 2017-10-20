# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=10000
#HISTFILESIZE=10000
#HISTIGNORE="fg:bg:history:cd:ls:l:la"
#HISTTIMEFORMAT='%m/%d %T ';

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#-----

export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export RTM_JAVA_ROOT=/usr/include/openrtm-1.1


#-- Starting Setup Script of wasanbon --#
#source /usr/local/share/rtshell/shell_support
#export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/opt/local/lib/pkgconfig:$PKG_CONFIG_PATH
export RTM_ROOT=/usr/include/openrtm-1.1
#export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
#export CMAKE_PREFIX_PATH=/opt/local/lib/cmake:/usr/local/lib/cmake:$CMAKE_PREFIX_PATH
wasanbon-cd() {
  if [ ${#} -eq 0 ]; then
    wasanbon-admin.py package list 
  else
    cd `wasanbon-admin.py package directory ${1}` 
  fi
};


_wsb_svc_cmpl() {
    local cur prev pprev target subtarget subcmds subsubcmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    pprev=""
    if [[ $COMP_CWORD == 3 ]]
    then
        prev="${COMP_WORDS[COMP_CWORD-2]}"
        pprev="${COMP_WORDS[COMP_CWORD-1]}"
    fi
    subcmds=`wasanbon-admin.py -a`
    #target=( $(compgen -W "${subcmds}" -- $1) )    
    for val in ${subcmds[@]}; do
	if [[ ${val} == ${prev} ]]
	then
	    subsubcmds=`wasanbon-admin.py ${prev} ${pprev} -a`
	    subtarget=( $(compgen -W "${subsubcmds}" -- ${cur}) )
	    COMPREPLY=(${subtarget[@]})
            return 0
	fi
    done
    target=( $(compgen -W "${subcmds}" -- ${cur}) )
    COMPREPLY=(${target[@]})
    return 0
}

_mgr_svc_cmpl() {
    local cur prev pprev ppprev target subtarget subcmds subsubcmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    pprev=""
    ppprev=""
    if [[ $COMP_CWORD == 3 ]]
    then
        prev="${COMP_WORDS[COMP_CWORD-2]}"
        pprev="${COMP_WORDS[COMP_CWORD-1]}"
    fi
    if [[ $COMP_CWORD == 4 ]]
    then
        prev="${COMP_WORDS[COMP_CWORD-3]}"
        pprev="${COMP_WORDS[COMP_CWORD-2]}"
        ppprev="${COMP_WORDS[COMP_CWORD-1]}"
    fi

    subcmds=`./mgr.py -a`
    #target=( $(compgen -W "${subcmds}" -- $1) )    
    for val in ${subcmds[@]}; do
	if [[ ${val} == ${prev} ]]
	then
	    subsubcmds=`./mgr.py ${prev} ${pprev} ${ppprev}-a`
	    subtarget=( $(compgen -W "${subsubcmds}" -- ${cur}) )
	    COMPREPLY=(${subtarget[@]})
            return 0
	fi
    done
    target=( $(compgen -W "${subcmds}" -- ${cur}) )
    COMPREPLY=(${target[@]})
    return 0
}

_wcd_svc_cmpl() {
    local cur prev target subtarget subcmds subsubcmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    subcmds=`wasanbon-admin.py package list`
    target=( $(compgen -W "${subcmds}" -- ${cur}) )
    COMPREPLY=(${target[@]})
    return 0
}

complete -o nospace -F _wsb_svc_cmpl wasanbon-admin.py
complete -o nospace -F _mgr_svc_cmpl ./mgr.py
complete -o nospace -F _wcd_svc_cmpl wasanbon-cd

#-- Ending Setup Script of wasanbon --#


. /home/ogata/torch/install/bin/torch-activate

source /usr/local/lib/python2.7/dist-packages/rtshell/data/shell_support # enable rtcwd


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000
HISTIGNORE="fg:bg:history:ls:l:la"
HISTTIMEFORMAT='%m/%d %T ';

bind '"\e[A": history-search-backward'
bind '"\e[0A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[0B": history-search-forward'

bind '";5C": forward-word'
bind '";5D": backward-word'

alias ..='cd ..'
alias py=python
alias ipy=ipython
alias ge=gedit
alias em=emacs
alias ag='sudo apt-get'
alias agup='ag update'
alias op='xdg-open'
alias opn='xdg-open .'
alias lr='ls -CFR'
alias rmrf='rm -rf'
alias makehere='mkdir build; cd build; cmake ..; make'
alias cmakehere='mkdir build; cd build; cmake ..'
alias uloc='sudo updatedb; locate -i'
alias loc='locate -i'
alias findn="find ./ -name "
alias findword="find ./ -type f -print | xargs grep "

#rtcwd localhost/
#rtcwd fugendake.host_cxt/

#conda with pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
#export PATH="$PYENV_ROOT/versions/anaconda3-4.1.0/bin:$PATH"
alias activate="source /home/ogata/.pyenv/versions/anaconda3-4.3.1/bin/activate"
alias py3="activate py3"
alias deac="aource deactivate"


# ROS
source /opt/ros/kinetic/setup.bash
source /home/ogata/catkin_ws/devel/setup.bash
# Set ROS Network
#export ROS_HOSTNAME=148.21.128.150
#export ROS_MASTER_URI=http://${ROS_HOSTNAME}:11311 
# Set ROS alias command
alias cw='cd ~/catkin_ws'
alias cs='cd ~/catkin_ws/src'
alias cm='cd ~/catkin_ws && catkin_make'
