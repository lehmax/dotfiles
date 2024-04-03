# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

zstyle ':z4h:' auto-update      'no'
zstyle ':z4h:' auto-update-days '28'
zstyle ':z4h:bindkey' keyboard  'mac'
zstyle ':z4h:' start-tmux command tmux -u new -A -D -t z4h
zstyle ':z4h:' prompt-at-bottom 'yes'
zstyle ':z4h:' term-shell-integration 'yes'
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'no'
zstyle ':z4h:direnv'         enable 'yes'
zstyle ':z4h:direnv:success' notify 'yes'
z4h init || return

# Source additional local files if they exist.
z4h source ~/.env.zsh
z4h source ~/.fzf-git.sh
z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
z4h bindkey redo Option+/            # redo the last undone command line change
z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

alias tree='tree -a -I .git'
alias ls="${aliases[ls]:-ls} -A"
alias kittye="nvim $HOME/.config/kitty/kitty.conf"
alias bupdate="brew update && brew upgrade && brew cleanup"
alias zshr="exec zsh"
alias zshe="nvim $HOME/.zshrc"
alias cw="cd $CURRENT_WORK_PATH"
alias gitui="gitui -t macchiato.ron"
