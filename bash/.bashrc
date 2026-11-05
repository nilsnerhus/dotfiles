# --- Homebrew
# Package manager that installs everything to its own folder
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" # sets path to installs

# --- Starship
# Replaces bash *prompts* with better-looking ones
eval "$(starship init bash)" # initialises starship inside bash

# --- Flyline
# Replaces the bash *line editor* with a better-looking one.
enable -f "$(brew --prefix flyline)/lib/bash/flyline" flyline # loads a Bash builtin
