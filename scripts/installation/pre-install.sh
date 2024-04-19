#!/usr/bin/env bash

BLUE=$(printf '\033[34m')
GREEN=$(printf '\033[32m')
RESET=$(printf '\033[0m')

# Check if a given package is installed
command_exists () {
	hash "$1" 2> /dev/null
}

echo "${BLUE}Checking for dependencies...${RESET}"

# Update apt-get
echo "${BLUE}Updating apt command...${RESET}"
sudo apt update && sudo apt-get update

# Install build essential
echo "${BLUE}Installing build-essentials...${RESET}"
sudo apt-get install build-essential

# Check if curl is installed
if ! command_exists curl; then
	echo "${BLUE}Installing curl...${RESET}"
	sudo apt install curl -y
else
	echo "${GREEN}Curl already installed, skipping...${RESET}"
fi

# Check if oh-my-zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "${BLUE}Installing oh-my-zsh...${RESET}"
	bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
	echo "${GREEN}oh-my-zsh already installed, skipping...${RESET}"
fi

# Check if git is installed
if ! command_exists git; then
	echo "${BLUE}Installing git...${RESET}"
	sudo apt install git -y
else
	echo "${GREEN}Git already installed, skipping...${RESET}"
fi

# Check if homebrew is installed
if ! command_exists brew || [ ! -d "/home/linuxbrew/.linuxbrew/bin" ]; then
	echo -en "🍺 ${BLUE}Installing Homebrew...${RESET}\n"
	brew_url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
	/bin/bash -c "$(curl -fsSL $brew_url)"
	
	# Add Path
  export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
  export PATH="$PATH:$BREW_HOME"

  if [ -f "$HOME/.bashrc" ]; then
      (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$HOME/.bashrc"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  if [ -f "$HOME/.zshrc" ]; then
      (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$HOME/.zshrc"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
else
	echo "${GREEN}Homebrew already installed, loading environment...${RESET}"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
