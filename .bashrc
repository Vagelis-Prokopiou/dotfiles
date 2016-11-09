# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

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
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1)\$ "
else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\$(__git_ps1)\$ "
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

# You may uncomment the following lines if you want `ls' to be colorized:
eval "`dircolors`";
# alias ls='ls --color=auto';
# alias ll='ls --color=auto -l';
alias l='ls --color=auto -lA';

# Colored searching.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# My aliases:
alias phpstorm='sudo sh /home/va/Downloads/jetbrains/PhpStorm-162.1121.38/bin/phpstorm.sh';
alias localhost='cd /var/www/html';
alias tsini='cd /var/www/html/vhosts/tsinikopoulos/public_html/';
alias tsinigulp='cd /var/www/html/vhosts/tsinikopoulos/public_html/sites/all/themes/tsinikopoulos && sudo find /usr/lib/node_modules -type f -name "*.info" -exec sudo rm "{}" \+ && modules=$(ls /usr/lib/node_modules) && npm link $modules && gulp';
alias drupaland='cd /var/www/html/vhosts/drupaland/public_html/';
alias drupalandgulp='cd /var/www/html/vhosts/drupaland/public_html/themes/drupaland && sudo find /usr/lib/node_modules -type f -name "*.info" -exec sudo rm "{}" \+ && modules=$(ls /usr/lib/node_modules) && npm link $modules && gulp';

alias rs='cd /var/www/html/vhosts/rigging/public_html/';
alias rsgulp='cd /var/www/html/vhosts/rigging/public_html/sites/all/themes/skeletontheme_testing && sudo find /usr/lib/node_modules -type f -name "*.info" -exec sudo rm "{}" \+ && modules=$(ls /usr/lib/node_modules) && npm link $modules && gulp';
alias bnspro='cd /var/www/html/vhosts/ci_bootstrap_3/public_html/';
alias update='sudo bash ~/bin/update.sh';
alias code='sudo code --user-data-dir="~/.vscode"';

# Git stuff:
alias gc='git commit -m ';
# alias gl='git log --pretty=format:"%h, %ar: %s"'
alias gl='git log --oneline';
alias gcf='git checkout -- ';
alias gs='git status';
alias grh='git reset --hard';
alias ga='git add ';
# Add git completion.
source ~/git-completion.bash;

# Site audit stuff:
alias siteaudit7='rm -r ~/.drush/commands/site_audit && unzip ~/.drush/commands/site_audit-7*.zip -d ~/.drush/commands/';
alias siteaudit8='rm -r ~/.drush/commands/site_audit && unzip ~/.drush/commands/site_audit-8*.zip -d ~/.drush/commands/';

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
# Include Drush bash customizations.
if [ -f "/root/.drush/drush.bashrc" ] ; then
  source /root/.drush/drush.bashrc
fi

# Include Drush completion.
if [ -f "/root/.drush/drush.complete.sh" ] ; then
  source /root/.drush/drush.complete.sh
fi

# Include Drush prompt customizations.
if [ -f "/root/.drush/drush.prompt.sh" ] ; then
  source /root/.drush/drush.prompt.sh
fi

