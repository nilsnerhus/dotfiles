# Wikilinks Filter for Quarto

## Overview
This Quarto extension converts Obsidian-style `[[wikilinks]]` to proper Markdown links during rendering, making them work on your published website while keeping the `[[...]]` syntax in your source files for LSP/editor support.

## Features
- **Title-based linking**: `[[utvikling]]` links to the file with H1 title "Utvikling"
- **ID-based linking**: `[[x7k9m2|Display Text]]` links directly to file `x7k9m2.qmd`
- **Marksman-compatible**: Uses the same slug normalization algorithm as Marksman LSP
- **Missing file warnings**: Shows warnings for broken links, renders as plain text
- **Works everywhere**: Correctly handles files in `src/` directory and at project root

## Installation

The filter is already configured in your `tunet/_quarto.yml`:

```yaml
filters:
  - /home/nilsn/prosjekter/dotfiles/quarto/extensions/wikilinks/wikilinks.lua
```

## How It Works

### Title-Based Links
When you write `[[utvikling]]`, the filter:
1. Normalizes "utvikling" to a slug (lowercase, spaces→hyphens, remove punctuation)
2. Searches all `.qmd` files in `src/` for one with matching H1 title
3. Creates link to that file

Example:
- File: `src/nsol79.qmd` with H1 `# Utvikling`
- Wikilink: `[[utvikling]]`
- Result: Links to `nsol79.qmd`

### ID-Based Links
When you write `[[nsol79|Utvikling]]`, the filter:
1. Uses the ID directly (nsol79)
2. Links to `src/nsol79.qmd`
3. Uses "Utvikling" as display text

### Marksman Slug Normalization
The filter uses marksman's algorithm:
- Lowercase: `Utvikling` → `utvikling`
- Spaces→hyphens: `Epistemiske fellesskap` → `epistemiske-fellesskap`
- Remove punctuation: `What?` → `what`
- Norwegian chars preserved: `økonomi` → `økonomi`

## Testing

Test with a file in src/:
```bash
cd /home/nilsn/prosjekter/tunet
quarto render src/10elxd.qmd --to html
```

Test with root file:
```bash
quarto render index.qmd --to html
```

## File Structure

```
dotfiles/quarto/extensions/wikilinks/
├── _extension.yml    # Extension metadata
└── wikilinks.lua     # The filter (this file)
```

## Notes
- The filter scans all `src/*.qmd` files once per render to build the title cache
- Files without H1 titles won't be found by title-based links
- Missing files show warnings and render as plain text
