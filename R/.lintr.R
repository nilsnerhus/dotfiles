# Lintr configuration for R diagnostics
# Keep linters that catch real errors, disable style/formatting linters
# Style/formatting is handled by air/styler via conform.nvim

linters <- lintr::linters_with_tags(
  tags = c("correctness", "common_mistakes")
)
