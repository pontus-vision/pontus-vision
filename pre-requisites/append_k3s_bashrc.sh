#!/bin/bash

echo '
alias kubectl='k3s kubectl'
source <(kubectl completion bash)
export SCREENDIR=$HOME/.screen
[ -d $SCREENDIR ] || mkdir -p -m 700 $SCREENDIR

complete -C '/usr/local/bin/aws_completer' aws

export PATH=$PATH:~/.local/bin:~/.yarn/bin:/mnt/c/Users/LeonardoMartins/go/bin/:$HOME/go/src/github.com/lexicality/wsl-relay/scripts
#PROMPT_COMMAND='echo -ne "\033k\033\0134\033k${HOSTNAME}[`basename ${PWD}`]\033\0134"'
#PROMPT_COMMAND='printf "\033k%s $\033\\" "${PWD/#$HOME/\~}"'
PS1='\u@\h [\w] \$ '

#if echo $TERM | grep ^screen -q; then
  #PS1='\[\033k\033\\\]'$PS1
#fi
if [[ "$TERM" == screen* ]]; then
  screen_set_window_title () {
  local HPWD="$PWD"
  case $HPWD in
    $HOME) HPWD="~";;
    $HOME/*) HPWD="~${HPWD#$HOME}";;
  esac
  printf '\ek%s\e\\' "$HPWD"
  }
  PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
fi
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export EDITOR=/usr/bin/vi
' >> ~/.bashrc

source ~/.bashrc
