#!/bin/bash
# Simple dotfiles installation script

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Backup and create symlinks
mkdir -p "$BACKUP_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    mkdir -p "$(dirname "$target")"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$BACKUP_DIR/"
    fi
    
    ln -sf "$source" "$target"
    echo "Linked: $target → $source"
}

# Create symlinks
create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/bash/.profile" "$HOME/.profile"
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
create_symlink "$DOTFILES_DIR/supermaven/config.json" "$HOME/.supermaven/config.json"

echo "Dotfiles installed! Backups in: $BACKUP_DIR"