# p10k instant prompt — speeds up terminal startup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Oh My Zsh if available (optional, don't fail if missing)
if [[ -f /usr/share/oh-my-zsh/zshrc ]]; then
  source /usr/share/oh-my-zsh/zshrc
fi

# Fix for comment color if using zsh-syntax-highlighting
if [[ -v ZSH_HIGHLIGHT_STYLES ]]; then
  ZSH_HIGHLIGHT_STYLES[comment]='fg=blue'
fi

# Load zsh-autosuggestions if available
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Load zsh-syntax-highlighting if available
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load modular user configuration from config.d/
if [[ -d ~/.config/zsh/config.d/ ]]; then
  for config_file in ~/.config/zsh/config.d/*.zsh; do
    [[ -f "$config_file" ]] && source "$config_file"
  done
  unset config_file
fi

# Load XDG user directories if available
[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs

# Set terminal for SSH (foot terminfo may not be on all servers)
alias ssh="TERM=xterm-256color ssh"
