#!/usr/bin/env bash

# Stop at the first failed command so a partial setup is not reported as done.
set -e

# --- Sudo
# Install the correct packages in the Ubuntu package manager
sudo apt-get update                                                     # check for updates
sudo apt-get install --yes build-essential procps curl file git locales # install homebrew dependencies
sudo apt-get upgrade                                                    # upgrade outdated packages
sudo apt-get autoremove                                                 # remove unused dependencies
sudo apt-get autoclean                                                  # remove obsolete packages

# --- Homebrew
# Install Homebrew, the package manager used in these dotfiles
if ! which brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Avoid checking for Homebrew updates on every setup run; update at most weekly.
export HOMEBREW_AUTO_UPDATE_SECS=604800
export HOMEBREW_NO_ENV_HINTS=1

# Add Homebrew's tools to this shell so the remaining commands can use brew and the programs installed by it. This is the command Homebrew provides for its standard Linux installation.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install every dependency declared in the repository's Brewfile and remove those who are not in the Brewfile

brew bundle --force-cleanup # install programs in Brewfile, and remove all others
brew upgrade                # upgrade all installed programs

# --- Stow
# Link each top-level repository directory into the home directory. GNU Stow treats those directories as packages and preserves the repository layout.
stow --target="$HOME" */

# The setup is complete; shell configuration changes take effect in a new terminal session.
echo "Done! Restart your terminal for the changes to take effect."
