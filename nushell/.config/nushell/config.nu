# Add Homebrew and opencode to PATH.
$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/linuxbrew/.linuxbrew/bin' | prepend '/home/deck/.opencode/bin')

# Disable the startup banner.
$env.config.show_banner = false
