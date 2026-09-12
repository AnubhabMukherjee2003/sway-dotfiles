# Minimal loader: everything else is owned by ~/.config/zsh/config.d/
if [[ -d ~/.config/zsh/config.d/ ]]; then
  setopt null_glob
  for config_file in ~/.config/zsh/config.d/*.zsh; do
    [[ -f "$config_file" ]] && source "$config_file"
  done
  unset config_file
fi

# Load XDG user directories if available
[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs

# Set terminal for SSH when the remote system is less capable.
alias ssh="TERM=xterm-256color ssh"
