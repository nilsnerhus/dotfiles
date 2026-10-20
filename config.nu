# Legg til Homebrew og opencode i PATH
$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/linuxbrew/.linuxbrew/bin' | prepend '/home/deck/.opencode/bin')

# Fjerne oppstartsbanneret
$env.config.show_banner = false

