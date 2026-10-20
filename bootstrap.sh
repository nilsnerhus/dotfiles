#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

sudo apt-get install build-essential procps curl file git

brew bundle

# Remove an existing plain ~/.bashrc so stow can symlink the managed one.
if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
  rm "$HOME/.bashrc"
fi

stow --target=$HOME */

echo "Done! Restart your terminal for the changes to take effect."
