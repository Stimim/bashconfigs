# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth:erasedups

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '

# append to the history file, don't overwrite it
shopt -s histappend

G_HISTORY="$HOME/.bash_history"
G_HISTORY_SIZE=5000
L_HISTORY="$HOME/.$$_history"

G_HISTORY_TMP="$HOME/.bash_history.$$"


touch $L_HISTORY

export HISTFILE=$L_HISTORY

alias lh="history"
alias gh=show_global_history
alias glh=grep_local_history
alias ggh=grep_global_history

grep_global_history() {
  history -c
  history -r $G_HISTORY
  history | grep $*
  history -c
  history -r $L_HISTORY
}

grep_local_history() {
  history | grep $*
}

show_global_history() {
  history -c
  history -r $G_HISTORY
  history
  history -c
  history -r $L_HISTORY
}

log_history() {
  history -a $L_HISTORY
  cat $G_HISTORY $L_HISTORY | sed '$!N;s/\n/ /' | tac | \
    sort -k2 -u | sort -k1 | tail -n $G_HISTORY_SIZE | sed 's/ /\n/' > ${G_HISTORY_TMP}
  mv ${G_HISTORY_TMP} $G_HISTORY
  history -c
  history -r $L_HISTORY
}

clear_process_history() {
  rm $L_HISTORY
}

clear_global_history() {
  rm $G_HISTORY
  touch $G_HISTORY
}

# remove $L_HISTORY on exit
trap clear_process_history EXIT

PROMPT_COMMAND="log_history; $PROMPT_COMMAND"
