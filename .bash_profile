function __git__branch {
    git branch 2> /dev/null| sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(__git_status)) /"
}

function __git_status {
    [[ $(LC_ALL=C git status 2> /dev/null | tail -n1) != *"nothing to commit"* ]] && echo " [*]"
}

function __virtual_env {
    [[ $VIRTUAL_ENV != "" ]] && echo env:$(basename $VIRTUAL_ENV)" "
}

#string
if [[ ${EUID} == 0 ]] ; then
    PS1='\
\[\033[0;31m\]┌[ \[\033[0;31m\]\H\[\033[0;34m\]: \w \[\033[0;32m\]]\[\033[0m\]
\[\033[0;31m\]└[ \[\033[0m\]\[\033[0;31m\]$(__virtual_env)$(__git__branch)\[\033[0;31m\]\[\033[0m\]\[\033[0;31m\]\u\[\033[0;31m\] ]-> \[\033[0m\]';
else
    PS1='\
\[\033[0;32m\]┌[ \[\033[0;32m\]\H\[\033[0;34m\]: \w \[\033[0;32m\]]\[\033[0m\]
\[\033[0;32m\]└[ \[\033[0m\]\[\033[0;31m\]$(__virtual_env)$(__git__branch)\[\033[0;31m\]\[\033[0m\]\[\033[0;32m\]\u\[\033[0;32m\] ]-> \[\033[0m\]';
fi


#alias
alias ll='ls -la';
alias rm='rm -i';
alias mv='mv -i';


#some env variables
unset use_color safe_term match_lhs
export HISTCONTROL=ignoreboth
HISTFILESIZE=2500
export HISTIGNORE="ls:pwd:ll:cd:history"
export HISTTIMEFORMAT="%h %d %H:%M:%S "
PATH=$PATH:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

#ssh autocomplete string
_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh
