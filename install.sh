#!/usr/bin/env bash

# Stop at the first failed command so a partial setup is not reported as done.
set -e

# Homebrew needs these build and runtime tools on Linux. macOS provides its prerequisites through the system and does not need this apt step.
if [[ "$(uname -s)" == "Linux" ]]; then
	sudo apt-get update
	sudo apt-get install --yes build-essential procps curl file git locales
fi

# Install Homebrew only when it is not already available.
if ! which brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Avoid checking for Homebrew updates on every setup run; update at most weekly.
export HOMEBREW_AUTO_UPDATE_SECS=604800
export HOMEBREW_NO_ENV_HINTS=1

# Add Homebrew's tools to this shell so the remaining commands can use brew and the programs installed by it. This is the command Homebrew provides for its standard Linux installation.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install every dependency declared in the repository's Brewfile.
brew bundle

# Link each top-level repository directory into the home directory. GNU Stow treats those directories as packages and preserves the repository layout.
stow --target="$HOME" */

# The setup is complete; shell configuration changes take effect in a new terminal session.
echo "Done! Restart your terminal for the changes to take effect."
