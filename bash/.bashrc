# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

eval -- "$(/home/linuxbrew/.linuxbrew/bin/starship init bash --print-full-init)"

# Flyline replaces Bash's line editor with syntax highlighting, suggestions, and improved completion. Homebrew installs it as a loadable Bash builtin.
if command -v brew >/dev/null 2>&1; then
	flyline_path="$(brew --prefix flyline 2>/dev/null)/lib/bash/flyline"
	[[ -f "$flyline_path" ]] && enable -f "$flyline_path" flyline
fi
