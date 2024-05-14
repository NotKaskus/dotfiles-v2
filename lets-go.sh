#!/usr/bin/env bash

# If not already set, specify dotfiles destination directory and source repo
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documents/config/dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/NotKaskus/dotfiles.git}"

# Print starting message
echo -e "\033[1;35m""NotKaskus/Dotfiles Installation Script 🧰
\033[0;35mThis script will install or update specified dotfiles:
- From \033[4;35m${DOTFILES_REPO}\033[0;35m
- Into \033[4;35m${DOTFILES_DIR}\033[0;35m
Be sure you've read and understood the what will be applied.\033[0m\n"

# Run pre-installation script
echo -e "\033[1;35mRunning pre-installation script...\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NotKaskus/dotfiles/main/scripts/installation/pre-install.sh)

# If dotfiles not yet present then clone
if [[ ! -d "$DOTFILES_DIR" ]]; then
  mkdir -p "${DOTFILES_DIR}" && \
  git clone --recursive ${DOTFILES_REPO} ${DOTFILES_DIR}
fi

# Execute setup or update script
cd "${DOTFILES_DIR}" && \
chmod +x ./install.sh && \
./install.sh --no-clear