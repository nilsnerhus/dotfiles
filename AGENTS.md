# AI Assistant Guidelines for Dotfiles Repository

## Overview

This is a dotfiles repository for a multiplexer-first data science and note-taking workflow in Neovim, designed for WSL and remote server usage. The user is a beginner learning to code, with this being their first experience with structured development environments.

## Philosophy

### Multiplexer-First Architecture

- **Zellij is the primary organizational layer** for all work
- Each project or task should live in its own Zellij session or tab
- REPLs run in Zellij panes, NOT Neovim buffers (this enables remote server work)
- OpenCode and other tools should integrate with Zellij, not just Neovim
- Window and pane management should prefer Zellij over Neovim splits when appropriate

### Simplicity Over Complexity

**CRITICAL: Always prefer the simplest solution.**

Before suggesting ANY plugin or custom code, check if the problem can be solved with:
1. Quarto markdown native features (YAML, code chunks, built-in extensions)
2. Simple R/Python code chunks for data visualization and interactive elements
3. Built-in Neovim features (check `:help` first)
4. Existing installed plugins (configure, don't add)

**Example of what NOT to do:**
- User wants to view metadata from note frontmatter
- ❌ DON'T: Create a custom Neovim plugin to parse YAML and display in buffers
- ✅ DO: Write an R code chunk in a Quarto document using `yaml` package and display with Shiny or a simple table

**Code chunks can solve most dashboard/visualization needs:**
- Todo lists → R Shiny app in code chunk
- Note metadata overview → R dataframe with DT package
- Data visualization → R/Python plotting in code chunk
- Interactive elements → Shiny/Dash in code chunk

### Plugin Organization

- Each plugin gets its own file in `nvim/lua/plugins/`
- File naming: `pluginname.lua` (e.g., `telescope.lua`, `obsidian.lua`)
- Keep `init.lua` minimal - it should mainly set basic options and load the plugin system
- Plugins are auto-loaded via `{ import = 'plugins' }` (already configured)

### Server-Compatible Design

- All configurations must work on remote servers via SSH
- Avoid solutions that require local rendering or GUI elements
- Prefer terminal-based tools and workflows
- Heavy computation should be able to run on servers while editing locally

## Current User Goals

**IMPORTANT: Check `/home/nilsn/prosjekter/dotfiles/README.md` for the user's current goals and priorities.**

The README (written in Norwegian) contains the user's active task list, ideas, and priorities. Review it before making significant changes to understand what the user is working toward.

## Tool Stack

| Tool | Purpose | Notes |
|------|---------|-------|
| **Neovim** | Text editor | Based on kickstart.nvim, keep it understandable |
| **Zellij** | Terminal multiplexer | Primary organizational layer, session management |
| **Quarto** | Document format | Primary interface for notes and data science work |
| **R** | Data science language | Primary language, R LSP configured |
| **iron.nvim** | REPL integration | Needs modification to launch REPLs in Zellij panes |
| **Obsidian.nvim** | Note linking | For wiki-style note connections |
| **render-markdown.nvim** | Markdown preview | In-editor markdown rendering |
| **bash** | Shell | WSL environment |

## File Structure

```
dotfiles/
├── nvim/
│   ├── init.lua                    # Minimal setup, loads plugins
│   └── lua/
│       └── plugins/                # One file per plugin
│           ├── telescope.lua
│           ├── lspconfig.lua
│           ├── obsidian.lua
│           ├── quarto.lua
│           ├── iron.lua
│           ├── autopairs.lua
│           ├── debug.lua
│           ├── gitsigns.lua
│           ├── indent_line.lua
│           ├── lint.lua
│           ├── neo-tree.lua
│           ├── notes.lua
│           ├── repl.lua
│           └── zen.lua
├── zellij/
│   └── config.kdl                  # Zellij configuration
├── bash/
│   ├── .bashrc
│   └── .profile
├── git/
│   └── .gitconfig
├── Maler/                          # Templates (Norwegian)
│   ├── Mal for notater.md
│   ├── Mal for gjøremål.md
│   └── Mal for importer.md
├── install.sh                      # Symlink installation script
├── README.md                       # User's personal notes and goals (Norwegian)
└── AGENTS.md                       # This file (English)
```

## Instructions for AI Assistants

### Before Making Any Changes

1. **Check README.md** - Review the user's current goals and priorities (written in Norwegian)
2. **Consider Native Solutions** - Can this be solved with native features? (See Philosophy section)
3. **Ask Permission** - For the following, explain the approach clearly and ask for approval:
   - Adding new plugins
   - Creating complex Lua functions or abstractions
   - Modifying core workflow patterns
   - Major configuration restructuring
   - Removing existing functionality

### When to Ask Permission

**ALWAYS ask before:**
- Adding a new plugin
- Creating functions longer than 10 lines
- Modifying keybindings (unless fixing bugs)
- Changing the fundamental workflow
- Restructuring configuration files

**You can proceed without asking for:**
- Bug fixes that don't change behavior
- Documentation improvements
- Simple configuration tweaks (changing existing values)
- Code comments and explanations

### When Adding or Modifying Plugins

**File Organization:**
1. Create or edit file in `nvim/lua/plugins/` named after the plugin
2. Use this structure:
```lua
return {
  'author/plugin-name',
  dependencies = { ... },
  config = function()
    -- Configuration here
  end,
}
```

**Documentation Requirements:**
- Add a comment at the top explaining what problem this solves
- Comment any non-obvious configuration choices
- Explain "why" not just "what"
- Keep it beginner-friendly

**Server Compatibility Check:**
- Does it require GUI elements? (If yes, reconsider)
- Does it work over SSH? (Must be yes)
- Does it depend on local file paths? (Should be relative or configurable)

### Priority Order for Solutions

When the user requests a feature or solution:

1. **Native Quarto/R Markdown** - Check if Quarto's built-in features solve it
2. **Code Chunks** - Can R/Python code chunks handle it? (data viz, dashboards, interactivity)
3. **Built-in Neovim** - Use `:help` to check for existing functionality
4. **Existing Plugins** - Configure what's already installed
5. **Zellij Features** - Can Zellij's panes/tabs solve the organizational need?
6. **Simple New Plugins** - Ask permission, explain thoroughly
7. **Complex Custom Solutions** - Last resort, ask permission with detailed explanation

### Multiplexer-First Workflow

**Designing for Zellij Integration:**

- REPLs should launch in Zellij panes, not Neovim buffers
- Think about cross-session workflows
- Consider how features work when SSH'd into a server
- Use Zellij for project organization, Neovim for editing

**Example REPL Workflow:**
```
Zellij Session: "data-project"
├── Pane 1: Neovim editing analysis.qmd
├── Pane 2: R REPL for experimentation
└── Pane 3: Shell for git, file operations
```

**Why this matters:**
- Server computation: REPL runs on server, not local machine
- Persistence: Zellij sessions survive disconnections
- Organization: Each project is a session, easy context switching

### Code Style Guidelines

**Lua Code:**
- Keep it simple and readable
- Prefer explicit over clever
- Use comments to explain "why"
- Follow existing patterns from kickstart.nvim
- Avoid deep nesting and abstractions

**Comments:**
- Explain the reasoning, not just the action
- Target a beginner audience
- Link to relevant `:help` documentation

**Example:**
```lua
-- We use split vertical instead of buffer because this allows
-- the REPL to persist across Neovim sessions and work on remote servers
-- See :help terminal for more info
repl_open_cmd = view.split.vertical.botright(50),
```

### Language Conventions

- **Configuration code**: English (comments, variable names, docs)
- **AGENTS.md**: English (this file)
- **User's README.md**: Norwegian (DO NOT translate or modify language)
- **User's templates**: Norwegian (leave as-is)

### Understanding the User's Context

**The user is a beginner:**
- First experience with code, structure, and development workflows
- Learning as they go
- Values understanding over efficiency
- Prefers explicit, clear solutions

**What this means:**
- Explain your reasoning
- Avoid jargon without explanation
- Suggest learning resources when relevant
- Don't assume knowledge of vim, lua, or unix tools

**User's Background:**
- Coming from MS Office, Google Workspace, Obsidian, and RStudio
- Goal: Consolidate everything into one knowledge base
- Focus: Becoming an effective consultant who produces high-quality work
- Primary use case: Note-taking, data analysis, report writing

## Common Workflows

### Note-Taking Workflow

1. Write in Quarto markdown (`.qmd` files)
2. Use YAML frontmatter for metadata
3. Link notes with Obsidian.nvim wiki-links
4. Templates available in `Maler/` directory
5. Preview with render-markdown.nvim
6. Render to final format with Quarto CLI

### Data Science Workflow

1. Create Quarto document for analysis
2. Write narrative in markdown
3. Add R code chunks for computation
4. Use REPL in Zellij pane for experimentation
5. Send code from Neovim to REPL with keybinds
6. Preview rendered output
7. Heavy computation runs on server if needed

### Multi-Project Workflow

1. Each project gets a Zellij session (or tab)
2. Session contains: Neovim, REPL, shell panes
3. Switch between projects with Zellij keybinds (`Ctrl+t`)
4. Sessions persist across disconnections
5. Easy to resume work exactly where you left off

## Example Decision Tree

### Scenario: Display Interactive Overview of Note Metadata

**❌ WRONG Approach:**
- Create custom Neovim plugin
- Parse YAML frontmatter with Lua
- Build custom UI in Neovim buffers
- Add complex keybindings and commands

**✅ CORRECT Approach:**
- Create a Quarto document called `notes-overview.qmd`
- Add R code chunk that uses `yaml` package to read frontmatter
- Display results with DT package or Shiny app
- User can filter, sort, and explore interactively
- Renders to HTML for sharing

**Why the correct approach is better:**
- Uses tools user already knows (R, Quarto)
- More powerful (full R ecosystem available)
- Easier to customize and extend
- Works the same on servers
- Produces shareable output

### Scenario: Run R Code Interactively

**❌ WRONG Approach:**
- Complex buffer management in Neovim
- Capture output and display in custom windows
- Build custom REPL interface

**✅ CORRECT Approach:**
- Use iron.nvim configured to open R in Zellij pane
- Send code with simple keybinds (already configured: `<CR>`)
- REPL persists in Zellij pane
- Works identically on servers

### Scenario: Navigate Between Related Notes

**❌ WRONG Approach:**
- Build custom linking system
- Create database of note relationships
- Custom fuzzy finder for links

**✅ CORRECT Approach:**
- Use Obsidian.nvim (already installed)
- Standard wiki-link syntax `[[note-name]]`
- Built-in completion and navigation
- Standard format compatible with other tools

## Remote Server Workflow

The configuration must support this workflow:

1. SSH into remote server
2. Attach to or create Zellij session
3. Open Neovim in a pane
4. Work exactly as on local machine
5. Heavy computation runs on server resources
6. REPL in adjacent Zellij pane (also on server)
7. Disconnect and reconnect without losing state

**This means configurations should:**
- Have no dependencies on local tools
- Work in pure terminal environments
- Use server clipboard through Zellij
- Not require local rendering or GUI
- Handle relative paths properly

## Known Areas for Improvement

Based on the user's README, these are active goals:

1. **Migrate plugins to individual files** - Current init.lua is monolithic from kickstart.nvim
2. **REPL in Zellij panes** - iron.nvim currently opens in Neovim buffers, should use Zellij
3. **Integrate OpenCode with Zellij** - Enable AI assistance within multiplexer workflow
4. **Supermaven setup** - Autocomplete configuration needed
5. **File navigation** - Possibly implement harpoon or similar
6. **Color scheme** - User wants readable colors in light theme for Radian and Zellij

When the user asks about these topics, check the README for their current thinking and plans.

## Anti-Patterns to Avoid

**Don't:**
- Build features that Quarto already provides
- Create custom dashboards (use R/Python code chunks)
- Add plugins without checking if existing ones can be configured
- Make complex abstractions for simple tasks
- Assume the user knows vim/terminal/programming concepts
- Modify the user's Norwegian-language files
- Create solutions that only work locally

**Do:**
- Start with the simplest possible solution
- Explain your reasoning
- Provide learning resources
- Respect the multiplexer-first architecture
- Keep beginner-friendliness as a priority
- Ask permission for significant changes
- Test ideas against remote server workflow

## Questions to Ask Yourself

Before proposing a solution, ask:

1. Can Quarto's native features do this?
2. Can an R/Python code chunk solve this?
3. Does this work over SSH on a remote server?
4. Would a beginner understand this?
5. Is this the simplest possible approach?
6. Have I checked if an existing plugin can be configured for this?
7. Does this fit the multiplexer-first philosophy?
8. Have I explained why, not just what?

## Getting Started

When you first start working with this repository:

1. Read the user's README.md to understand current goals
2. Review the existing plugin configurations
3. Ask the user what they're trying to accomplish
4. Propose the simplest solution
5. Explain your reasoning
6. Ask permission if adding complexity

## Summary

**Core Principle: Simplicity through native solutions.**

The user spent significant time building a complex plugin for viewing frontmatter, when a simple R code chunk would have solved it. This is the anti-pattern to avoid.

**Remember:**
- Quarto and R are powerful - use them first
- Zellij is for organization, Neovim is for editing
- Server compatibility is non-negotiable
- Beginner-friendly explanations are essential
- Ask permission for complexity
- Check README.md for user's current goals

The goal is a workflow that's simple, powerful, understandable, and works identically whether on local WSL or a remote server.
