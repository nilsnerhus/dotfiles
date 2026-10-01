# Posit Public Package Manager - Ubuntu 26.04 (Resolute) binaries
Sys.setenv(RENV_CONFIG_REPOS_OVERRIDE = "https://packagemanager.posit.co/cran/__linux__/resolute/latest")
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/resolute/latest"))

# Use pak as renv backend
options(renv.config.pak.enabled = TRUE)

# Ignore nvimcom in all renv projects (installed into project libraries by the R.nvim plugin)
options(renv.settings.ignored.packages = "nvimcom")
