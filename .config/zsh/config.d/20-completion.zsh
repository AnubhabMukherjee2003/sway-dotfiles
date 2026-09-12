# Completion settings
autoload -Uz compinit

if [[ -d "$HOME/.zsh/completions" ]]; then
  fpath=("$HOME/.zsh/completions" $fpath)
fi

compinit
