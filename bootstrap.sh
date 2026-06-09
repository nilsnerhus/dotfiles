#!/bin/bash
set -e

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if ! grep -q ".local/bin" ~/.profile 2>/dev/null; then
  cat >> ~/.profile << 'EOF'
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
EOF
fi

if ! grep -q "brew shellenv" ~/.bashrc 2>/dev/null; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
fi

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle

echo "Done! Restart your terminal for the changes to take effect."
