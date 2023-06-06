# Put in .bash_aliases and make terminal ls after you cd

cdls() {
  builtin cd "$*"
  RESULT=$?
  if [ "$RESULT" -eq 0 ]; then
    cls
  fi
}
alias cd='cdls'
