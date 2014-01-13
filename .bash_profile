# Bash
alias vimbash="vim ~/.bash_profile"
alias rebash="source ~/.bash_profile"

# General
alias dr="docpad run"
alias dg="docpad generate"
alias cl="clear; pwd"
alias l="ls -lpGS"
alias ls='l'
alias h="history"
alias off="out"
alias fixgit="fix"

# Git Autocomplete
source ~/git-completion.bash

# Navigate to Sites
alias cds="cd ~/Sites/"

# Application
alias clearcache=""
alias pear="/Applications/MAMP/bin/php/php5.5.3/bin/pear"
alias drush="/Applications/MAMP/bin/php/php5.5.3/bin/drush"

# Update SLocate DB
alias uplocate="sudo /usr/libexec/locate.updatedb"

# Git
alias g="git"
alias ga="git add"
alias gs="git status"
alias gc="git commit"
#alias go="git checkout" # replaced by function
alias gd="git diff"
alias gf="git fetch"
alias gl="git log"
alias gh="git push"
alias gb="git branch"
alias gdc="git diff --cached"

# Tasks
alias gt="gettask"
alias st="settask"

old_rebash () {
	CURRENT_TASK=$TASK;
	source ~/.bash_profile
	TASK=$CURRENT_TASK;
}

# Checkout specified branch, or the current branch while setting task shortcut
go () {
	if [ $# -eq 1 ]; then
		git checkout $1;
	else
		git checkout $(getBranch);
	fi

	settask;
}

# Grep GIT logs for a certain task number
# $1 Jira task number
gitgrep () {
    git log --grep "$1" --name-status;
}

# Set current working task number
settask () {
        if [ $# -eq 1 ]; then
		TASK=$1;
	else
		TASK=`getCommitMessage`;
	fi
}

# Return current working task number
gettask () {
    echo $TASK;
}

# Do an amend
amend () {
    git commit --amend $1
}

# Do a commit based on value from setTask
commit () {
    git commit -m"$TASK $1";
}

# Fix a corrupt git index
fix () {
    rm -rf .git/index && git reset;
    #git fsck;
}

# Get the current working branch
getBranch () {
    BRANCH=`git rev-parse --abbrev-ref HEAD`
    echo $BRANCH;
}

# Get the commit message 'task #' delimiter
getCommitMessage () {
	IFS='/ ' read -a array <<< `getBranch`;
	myBranch="${array[1]}";
	IFS='- ' read -a array <<< ${myBranch};
        echo "${array[0]}-${array[1]}";
}

# Push to current working branch
push () {
    PROJECT=$(getBranch);
    echo "Pushing to $PROJECT";
    git push origin $PROJECT
}

# Pull from current working branch
pull () {
    PROJECT=$(getBranch)
    echo "Pulling from $PROJECT";
    git pull origin $PROJECT;
    git fetch;
}

# Fetch  & Rebase
fetch () {
    git fetch; git rebase;
}

# Retrieve a branch, pull its changes, run composer & bin/prep
get () {
    PROJECT=$(getBranch)

    if [ $# -eq 1 ]
        then
            PROJECT=$1
    fi

    git checkout $PROJECT && git pull origin $PROJECT && git fetch && ./composer.phar install --prefer-source --dev && binprep
}

# At set interval, repeatedly touch files
touchme () {
    while true
    do
        touch ~/application/$1
        sleep 3
    done
}

# Touch all SCSS files once
css () {
    touch `find . -name *.scss`
}

# Restart apache
restartapache () {
    sudo service apache2 restart;
}

diff_head () {
    git diff HEAD^1
}

commit_diff () {
    git log --color -p --full-diff
}


# backup $foldername: create a backup of this under ~/Documents/backups
backup () {
    # Define directory as a string/variable
    backupDir=~/Documents/backups/"nde-`date "+%d-%m-%H00"`";

    # Check to see if backup directory exists, if not then make the directory
    if [ -d $backupDir ]
        then
            backupDir=~/Documents/backups/"nde-`date "+%d-%m-%H%M"`";
            echo "Backup Already Exists, creating newer folder";
    fi

    mkdir `echo $backupDir`;
    echo "Directory created at $backupDir";

    scp -r www-data@192.168.56.100:~/site-steve/src $backupDir;
    echo "Backup completed at $backupDir";

    # Change to directory if "cd" is provided
    if [[ "$@" == "cd" ]]
                then
                        cd $backupDir;
            echo "Now in backup directory";
        fi

    # Echo output to user
    echo "Done";
}

# off: shutdown VM gracefully
out () { exit; }

# lsf: list folder content in full details
lsf () { ls -als $1; }

# searchfor: search for $@ string in the current directory but filter out svn files
searchfor () {
    echo -e "Searching for \033[1;33m$@\033[0m in \033[1;33m$PWD\033[0m";
    grep -rins "$@" . | grep -v svn | grep -rins "$@";
    echo "";
}

# detmp: recursively remove all files which their names start with ._ under the current directory
detemp() {
        echo "Recursively removing all files which their names start with ._ under the current directory:";
        rm -f `find . -type f -name "._*"`;
        echo "Done.";
}

# sad: search for $1 and replace by $2 in the current directory
sad() { grep -rls $1 . | grep -v svn | xargs sed -i -e "s/$1/$2/"; }

# bdiff: wrapper for comparing two folders with svn filtered out
bdiff() { diff -r $1 $2 | grep -v svn; }

# compare: find the difference between branch $1 and $2 in folder $3
compare() { diff -Naur ~/Projects/$1/branch/$3 ~/Projects/$2/branch/$3; }


# Searchings:
# ff:  to find a file in the current directory
ff () { /usr/bin/find . -name "$@" ; }

# ffs: to find a file whose name starts with a given string
ffs () { /usr/bin/find . -name "$@"'*' ; }

# ffe: to find a file whose name ends with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }

# findlarger: find all files larger than $1 byte under the current folder
findlarger() { find . -type f -size +${1}c ; }


# Terminal Colors
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad

# grep Colors
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

export EDITOR="vim"

#export PATH=/usr/local/bin:$PATH
#export PATH="/Applications/MAMP/Library/bin:/Applications/MAMP/bin/php5.4/bin:$PATH"
#export PATH="/usr/local/bin:$HOME/.rbenv/bin:$PATH:~/bin:/usr/local/php5/bin:/usr/local/git/bin:$PATH"
export PATH="$HOME:~/bin:/usr/local/php5/bin:/usr/local/git/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

if [[ ! -x $(which fink) && -d /sw/bin ]];then
    source /sw/bin/init.sh
fi

PS1="\[\e[1;30m\]#!\!\e[m \[\e[1;33m\]\u\[\e[m\] in \[\e[1;33m\]\w\[\e[m\] on \[\e[1;33m\]\h\[\e[m\]
\[\e[1;33m\]$\[\e[m\] "

# Initialize
git config --global color.ui true;
cds; cd neompd 
clear;
git status;

# Variables
#APP=~/application
#BRANCH=`git rev-parse --abbrev-ref HEAD`;
BRANCH=`getCommitMessage`;
TASK=`getCommitMessage`;
eval "$(rbenv init -)"

# {{{
# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
