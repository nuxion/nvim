# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration based on ThePrimeagen's setup. Uses **lazy.nvim** as the plugin manager. Leader key is `<Space>`.

## Architecture

- `init.lua` — Entry point, loads `nuxion` module and sets up intelephense (PHP LSP)
- `lua/nuxion/init.lua` — Loads settings, remaps, and lazy.nvim initialization in order
- `lua/nuxion/set.lua` — Vim options (4-space tabs, relative line numbers, system clipboard, custom filetypes for terraform/hcl/mdx)
- `lua/nuxion/remap.lua` — Global keymaps (leader mappings, file path copy)
- `lua/nuxion/lazy_init.lua` — Bootstraps lazy.nvim, loads plugin specs from `lua/nuxion/lazy/`
- `lua/nuxion/lazy/` — Each file returns a lazy.nvim plugin spec table

## Plugin Configuration Pattern

Each file in `lua/nuxion/lazy/` returns a table (or list of tables) following the lazy.nvim spec format. Plugin-specific keymaps are defined inside each plugin's `config` function, not centralized.

## Key Plugins and Their Configs

- **LSP** (`lsp.lua`): Mason manages LSP servers. Ensured: `lua_ls`, `gopls`, `pyright`, `ruff`. Completion via nvim-cmp with LuaSnip. Pyright delegates linting/imports to Ruff.
- **Formatting** (`conform.lua`): Format-on-save enabled (500ms timeout). Ruff for Python, stylua for Lua. `<leader>f` for async format.
- **Colorscheme** (`colors.lua`): rose-pine with transparent background
- **Navigation**: Telescope (`<leader>pf` find files, `<C-p>` git files, `<leader>pg` grep), Harpoon v2 (`<leader>a` add, `<C-e>` menu)
- **Git**: Fugitive (`<leader>gs` status, `<leader>p` push, `<leader>P` pull --rebase), gitsigns
- **Diagnostics**: Trouble (`<leader>tt` toggle)

## System Dependencies

Required on the system: `tree-sitter-cli` (>= 0.26.1 — nvim-treesitter `main` shells out to it
to compile every parser), `tree-sitter`, `luarocks`, plus `tar`, `curl`, and a C compiler.

## Working With This Config

- Plugin specs auto-discovered from `lua/nuxion/lazy/` — add a new file there to add a plugin
- After changing plugin specs, lazy.nvim picks up changes on next Neovim start
- `lazy-lock.json` is the lockfile — commit it to pin plugin versions
- `lua/nuxion/packer.lua` is a legacy file (config migrated to lazy.nvim)
