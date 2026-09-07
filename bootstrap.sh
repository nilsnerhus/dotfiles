#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew bundle

# Install Quarto (not available via Homebrew for Linux)
QUARTO_VERSION="1.9.38"
if ! command -v quarto &>/dev/null; then
  echo "Installing Quarto $QUARTO_VERSION..."
  curl -fsSL "https://github.com/quarto-dev/quarto-cli/releases/download/v$QUARTO_VERSION/quarto-$QUARTO_VERSION-linux-amd64.tar.gz" \
    -o /tmp/quarto.tar.gz
  mkdir -p "$HOME/.local/share/quarto"
  tar -xzf /tmp/quarto.tar.gz -C "$HOME/.local/share/quarto" --strip-components=1
  mkdir -p "$HOME/.local/bin"
  ln -sf "$HOME/.local/share/quarto/bin/quarto" "$HOME/.local/bin/quarto"
  rm /tmp/quarto.tar.gz
fi

# Remove an existing plain ~/.bashrc so stow can symlink the managed one.
# (A backup is not created per your preference.)
if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
  rm "$HOME/.bashrc"
fi

stow --target=$HOME */

echo "Done! Restart your terminal for the changes to take effect."
