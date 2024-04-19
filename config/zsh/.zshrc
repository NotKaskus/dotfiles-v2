# ~/.config/zsh/.zshrc      

# Directory for all-things ZSH config
zsh_dir=${${ZDOTDIR}:-$HOME/.config/zsh}
utils_dir="${XDG_CONFIG_HOME}/utils"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Sourcing the Oh-My-ZSH source:
source "$ZSH/oh-my-zsh.sh"

# Import utility functions (if present)
if [[ -d $utils_dir ]]; then
  source ${utils_dir}/transfer.sh
  source ${utils_dir}/matrix.sh
  source ${utils_dir}/hr.sh
  source ${utils_dir}/am-i-online.sh
  source ${utils_dir}/welcome-banner.sh
  source ${utils_dir}/color-map.sh
fi

# Import P10k config for command prompt TODO: Change this to oh-my-posh
# [[ ! -f ${zsh_dir}/.p10k.zsh ]] || source ${zsh_dir}/.p10k.zsh

# Add Brew to path, if it's installed
export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:$BREW_HOME"

# Source all ZSH config files (if present)
if [[ -d $zsh_dir ]]; then
  # Import alias files
  source ${zsh_dir}/aliases/general.zsh
  source ${zsh_dir}/aliases/git.zsh
  source ${zsh_dir}/aliases/node.zsh
  source ${zsh_dir}/aliases/tmux.zsh
  source ${zsh_dir}/aliases/alias-tips.zsh

  # Setup Antigen, and import plugins
  source ${zsh_dir}/helpers/setup-antigen.zsh
  source ${zsh_dir}/helpers/import-plugins.zsh
  source ${zsh_dir}/helpers/misc-stuff.zsh

  # Configure ZSH stuff
  source ${zsh_dir}/lib/colors.zsh
  source ${zsh_dir}/lib/cursor.zsh
  source ${zsh_dir}/lib/history.zsh
  source ${zsh_dir}/lib/surround.zsh
  source ${zsh_dir}/lib/completion.zsh
  source ${zsh_dir}/lib/term-title.zsh
  source ${zsh_dir}/lib/navigation.zsh
  source ${zsh_dir}/lib/expansions.zsh
  source ${zsh_dir}/lib/key-bindings.zsh
fi

# If using Pyenv, import the shell integration if availible
if [[ -d "$PYENV_ROOT" ]] && \
  command -v pyenv >/dev/null 2>&1 && \
  command -v pyenv-virtualenv-init >/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Append Cargo to path, if it's installed
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Add Zoxide (for cd, quick jump) to shell
if hash zoxide 2> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# If not running in nested shell, then show welcome message :)
if [[ "${SHLVL}" -lt 2 ]] && \
  { [[ -z "$SKIP_WELCOME" ]] || [[ "$SKIP_WELCOME" == "false" ]]; }; then
  welcome
fi