#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if ! grep -q "brew shellenv" ~/.profile 2>/dev/null; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
fi
if ! grep -q "brew shellenv" ~/.bashrc 2>/dev/null; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
fi

brew bundle

echo "Done! Restart your terminal for the changes to take effect."
