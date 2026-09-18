# Neovim Keymaps

Every mapping in this config, grouped by feature. Each row says whether it is **stock Neovim** or comes from a **plugin**, and which file defines it.

Leader is `<Space>` (written as `<leader>` below).

**Legend**

| Badge | Meaning |
| --- | --- |
| 🟦 Neovim | Built-in default, not configured here |
| 🟪 Plugin | Comes from a plugin or a custom mapping in this repo |

Modes: `n` normal · `i` insert · `v` visual · `o` operator-pending · `c` command-line.

---

## Basics & leader

The leader key prefixes almost every custom mapping. Netrw is Neovim's built-in file explorer — only the shortcut to it is custom.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<Space>` | n | Leader key | 🟦 Neovim | `lua/nuxion/remap.lua:1` |
| `<leader>pv` | n | Open netrw file explorer (`:Ex`) | 🟦 Neovim (netrw) | `lua/nuxion/remap.lua:2` |
| `:` | n | Command line | 🟦 Neovim | built-in |
| `<leader>vh` | n | Search Neovim help tags | 🟪 telescope.nvim | `lua/nuxion/lazy/telescope.lua:32` |

---

## Files & search

Telescope is the fuzzy finder. `fzf-lua` is also installed but ships no keymaps here — call it with `:FzfLua <picker>`.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<leader>pf` | n | Find files in cwd | 🟪 telescope.nvim | `lua/nuxion/lazy/telescope.lua:14` |
| `<C-p>` | n | Find git-tracked files (untracked included) | 🟪 telescope.nvim | `lua/nuxion/lazy/telescope.lua:18` |
| `<leader>pb` | n | List open buffers, most recent first | 🟪 telescope.nvim | `lua/nuxion/lazy/telescope.lua:15` |
| `<leader>pg` | n | Grep — prompts for the search string | 🟪 telescope.nvim | `lua/nuxion/lazy/telescope.lua:29` |
| `<leader>pws` | n | Grep the word under the cursor (`<cword>`) | 🟪 telescope.nvim | `lua/nuxion/lazy/telescope.lua:21` |
| `<leader>pWs` | n | Grep the WORD under the cursor (`<cWORD>`, punctuation included) | 🟪 telescope.nvim | `lua/nuxion/lazy/telescope.lua:25` |
| `/` `?` `n` `N` | n | Search in buffer forward / backward, next / previous match | 🟦 Neovim | built-in |
| `*` `#` | n | Search word under cursor forward / backward | 🟦 Neovim | built-in |

> **Inside a Telescope prompt:** `<C-n>` / `<C-p>` move the selection, `<Enter>` opens, `<C-x>` / `<C-v>` open in a horizontal / vertical split, `<C-t>` in a tab, `<Esc>` closes. These are Telescope's defaults — this config passes an empty `setup({})`.

---

## Quick marks (Harpoon)

Harpoon v2 pins a short list of files you jump between. The menu is an editable buffer — delete a line to drop a file, then `:w`/`:q`.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<leader>a` | n | Add current file to the Harpoon list | 🟪 harpoon (harpoon2) | `lua/nuxion/lazy/harpoon.lua:9` |
| `<C-e>` | n | Toggle the Harpoon quick menu | 🟪 harpoon (harpoon2) | `lua/nuxion/lazy/harpoon.lua:10` |
| `m` + letter / `` ` `` + letter | n | Set / jump to a classic vim mark | 🟦 Neovim | built-in |
| `<C-o>` / `<C-i>` | n | Jumplist back / forward | 🟦 Neovim | built-in |

> **Not mapped:** harpoon's *jump to slot 1–4* (`harpoon:list():select(n)`) has no keymap in this config. Add it in `lua/nuxion/lazy/harpoon.lua` if you want `<leader>1`…`<leader>4`-style jumps.

---

## LSP

This config sets **no LSP keymaps of its own** — everything below is Neovim 0.11+'s built-in `LspAttach` defaults, active in any buffer with a language server.

Servers are installed by Mason and listed in `lua/nuxion/lazy/lsp.lua:57`: `lua_ls`, `gopls`, `pyright`, `ruff`, `astro`, `ts_ls`, plus `intelephense` enabled in `init.lua:3`.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `K` | n | Hover documentation | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.10 |
| `grn` | n | Rename symbol | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.11 |
| `gra` | n, v | Code action | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.11 |
| `grr` | n | List references | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.11 |
| `gri` | n | Go to implementation | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.11 |
| `grt` | n | Go to type definition | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.11 |
| `gO` | n | Document symbols | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.11 |
| `gd` | n | Go to definition — LSP-backed via `tagfunc` when a server is attached | 🟦 Neovim | built-in |
| `<C-s>` | i | Signature help | 🟦 Neovim (LSP default) | built-in, Nvim ≥ 0.11 |
| `<leader>ff` | n | Format buffer with the LSP server directly (`vim.lsp.buf.format`) | 🟪 custom mapping | `lua/nuxion/remap.lua:4` |

---

## Completion & snippets

nvim-cmp with LuaSnip. Sources: LSP, LuaSnip, buffer words. These mappings only apply in insert mode.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<C-Space>` | i | Trigger completion | 🟪 nvim-cmp | `lua/nuxion/lazy/lsp.lua:81` |
| `<C-n>` | i | Select next completion item | 🟪 nvim-cmp | `lua/nuxion/lazy/lsp.lua:79` |
| `<C-p>` | i | Select previous completion item | 🟪 nvim-cmp | `lua/nuxion/lazy/lsp.lua:78` |
| `<Enter>` | i | Confirm the selected item | 🟪 nvim-cmp | `lua/nuxion/lazy/lsp.lua:80` |
| `<C-e>` | i | Abort the completion popup | 🟪 nvim-cmp (preset default) | `cmp.mapping.preset.insert`, `lsp.lua:77` |
| `<C-x><C-f>` / `<C-x><C-o>` | i | Built-in path / omni completion | 🟦 Neovim | built-in |

---

## Diagnostics

Trouble gives the list view; jumping and the float are stock Neovim. Diagnostic floats are configured with a rounded border in `lua/nuxion/lazy/lsp.lua:91`.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<leader>tt` | n | Toggle the Trouble diagnostics list and focus it | 🟪 trouble.nvim | `lua/nuxion/lazy/trouble.lua:28` |
| `]d` / `[d` | n | Jump to next / previous diagnostic | 🟦 Neovim | built-in, Nvim ≥ 0.10 |
| `<C-w>d` | n | Show the diagnostic under the cursor in a float | 🟦 Neovim | built-in, Nvim ≥ 0.10 |
| `]q` / `[q` | n | Next / previous quickfix entry | 🟦 Neovim | built-in |

> **Inside the Trouble window:** `<Enter>` jumps to the item, `o` jumps and closes, `q` closes, `<Tab>`/`<S-Tab>` fold. Trouble's own defaults — this config only changes appearance (`mode = "workspace_diagnostics"`, bottom position, height 6).

---

## Formatting

Format-on-save is on with a 500 ms timeout (`lua/nuxion/lazy/conform.lua:36`). Per filetype: `stylua` for Lua, `ruff` for Python, `prettierd`→`prettier` for JS/TS/TSX/Astro/CSS/HTML, falling back to the LSP formatter otherwise.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<leader>f` | n, v, o | Format the buffer asynchronously with conform | 🟪 conform.nvim | `lua/nuxion/lazy/conform.lua:8` |
| `<leader>ff` | n | Format via the LSP server, bypassing conform | 🟪 custom mapping | `lua/nuxion/remap.lua:4` |
| `gq` + motion | n, v | Format the motion — routed to conform via `formatexpr` | 🟦 Neovim + conform | `lua/nuxion/lazy/conform.lua:46` |
| `=` + motion | n, v | Re-indent — uses treesitter indent | 🟦 Neovim | `lua/nuxion/lazy/treesitter.lua:41` |

---

## Git

Fugitive drives the workflow. **Three of these are buffer-local** — they only exist inside the Fugitive status buffer, set by an autocmd at `lua/nuxion/lazy/fugitive.lua:9`. gitsigns is installed with defaults (signs in the gutter, no custom keymaps).

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<leader>gs` | n | Open the Fugitive git status buffer | 🟪 vim-fugitive | `lua/nuxion/lazy/fugitive.lua:4` |
| `<leader>p` | n | *Fugitive buffer only* — `git push` | 🟪 vim-fugitive | `lua/nuxion/lazy/fugitive.lua:19` |
| `<leader>P` | n | *Fugitive buffer only* — `git pull --rebase` | 🟪 vim-fugitive | `lua/nuxion/lazy/fugitive.lua:24` |
| `<leader>t` | n | *Fugitive buffer only* — prefills `:Git push -u origin ` for you to finish | 🟪 vim-fugitive | `lua/nuxion/lazy/fugitive.lua:30` |
| `gu` | n | Merge conflict: take the change from the **target** branch (`diffget //2`) | 🟪 vim-fugitive | `lua/nuxion/lazy/fugitive.lua:35` |
| `gh` | n | Merge conflict: take the change from the **merge** branch (`diffget //3`) | 🟪 vim-fugitive | `lua/nuxion/lazy/fugitive.lua:36` |
| `]c` / `[c` | n | Next / previous diff hunk in diff mode | 🟦 Neovim | built-in |

> **Inside the Fugitive status buffer** (plugin defaults, not configured here): `s` stage, `u` unstage, `-` toggle stage, `=` inline diff, `cc` commit, `ca` amend, `dv` vertical diff split, `g?` for the full list.
>
> **gitsigns commands** (no keymaps set): `:Gitsigns preview_hunk`, `reset_hunk`, `stage_hunk`, `blame_line`.

---

## Windows & buffers

All stock Neovim — nothing in this config remaps window or buffer handling. A window is a viewport onto a buffer; `<C-w>` is the prefix for all of it.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `<C-w>v` | n | Vertical split | 🟦 Neovim | built-in |
| `<C-w>s` | n | Horizontal split | 🟦 Neovim | built-in |
| `<C-w>c` | n | Close the window, keep the buffer | 🟦 Neovim | built-in |
| `<C-w>o` | n | Close every other window | 🟦 Neovim | built-in |
| `<C-w>h` `j` `k` `l` | n | Move focus left / down / up / right | 🟦 Neovim | built-in |
| `<C-w>r` | n | Rotate windows | 🟦 Neovim | built-in |
| `<C-w>=` | n | Equalise split sizes | 🟦 Neovim | built-in |
| `<C-^>` | n | Toggle to the alternate buffer | 🟦 Neovim | built-in |
| `:ls` · `:b N` · `:bd` | c | List buffers · switch to buffer N · delete buffer | 🟦 Neovim | built-in |

---

## Editing & clipboard

`clipboard = "unnamedplus"` (`lua/nuxion/set.lua:11`) means every yank and delete already goes to the system clipboard — no `"+` prefix needed. The provider is picked at startup in `init.lua:5`: `wl-clipboard` under Wayland, `xclip` otherwise.

| Keys | Mode | Action | Source | Defined in |
| --- | --- | --- | --- | --- |
| `cp` | n | Copy the current file's absolute path to the system clipboard and the unnamed register | 🟪 custom mapping | `lua/nuxion/remap.lua:7` |
| `y` / `d` / `p` | n, v | Yank / delete / paste — system clipboard by default here | 🟦 Neovim | `lua/nuxion/set.lua:11` |
| `gcc` / `gc` + motion | n, v | Toggle comment on the line / motion | 🟦 Neovim | built-in, Nvim ≥ 0.10 |
| `u` / `<C-r>` | n | Undo / redo | 🟦 Neovim | built-in |
| `>>` / `<<` | n, v | Indent / outdent by 4 spaces (`expandtab`, `shiftwidth=4`) | 🟦 Neovim | `lua/nuxion/set.lua:6-9` |

---

## Conflicts & gotchas

- **`<leader>f` vs `<leader>ff`** — conform waits for `timeoutlen` (default 1000 ms) before firing `<leader>f`, because `<leader>ff` is a longer mapping. Pause deliberately, or drop one of them.
- **`<leader>t` vs `<leader>tt`** — same story inside a Fugitive buffer: `<leader>t` (push -u origin) delays until the timeout because Trouble owns `<leader>tt`.
- **`<leader>p` vs `<leader>pf`/`pg`/…** — inside a Fugitive buffer, `<leader>p` (push) shadows the Telescope `<leader>p…` prefix until the timeout elapses. Outside Fugitive, the Telescope maps work normally.
- **`<C-p>`** means git-files in normal mode, but *previous completion item* in insert mode. No real conflict — different modes.
- **`<C-e>`** is Harpoon's menu in normal mode and cmp's abort in insert mode. Also different modes.
- **Format on save can fight `<leader>ff`** — `vim.lsp.buf.format` and conform may disagree for filetypes where both are available (Python: ruff via both paths).

---

## Where things live

| File | What it defines | Mappings |
| --- | --- | --- |
| `init.lua` | Entry point, intelephense LSP, clipboard provider | — |
| `lua/nuxion/set.lua` | Vim options: tabs, relative numbers, clipboard, filetypes | — |
| `lua/nuxion/remap.lua` | Leader key and global mappings | 3 |
| `lua/nuxion/lazy_init.lua` | Bootstraps lazy.nvim, loads specs from `lazy/` | — |
| `lua/nuxion/lazy/telescope.lua` | Fuzzy finding | 7 |
| `lua/nuxion/lazy/harpoon.lua` | Quick file marks | 2 |
| `lua/nuxion/lazy/fugitive.lua` | Git — 3 of its maps are buffer-local | 6 |
| `lua/nuxion/lazy/trouble.lua` | Diagnostics list | 1 |
| `lua/nuxion/lazy/conform.lua` | Formatters, format-on-save | 1 |
| `lua/nuxion/lazy/lsp.lua` | Mason, LSP servers, nvim-cmp | 4 (cmp) |
| `lua/nuxion/lazy/gitsigns.lua` | Git gutter signs — defaults only | 0 |
| `lua/nuxion/lazy/fzf.lua` | fzf-lua — installed, no keymaps | 0 |
| `lua/nuxion/lazy/treesitter.lua` | Parsers, highlight, indent | 0 |
| `lua/nuxion/lazy/colors.lua` | rose-pine, transparent background | 0 |
| `lua/nuxion/lazy/web-devicons.lua` | Icons for telescope / trouble / fzf | 0 |

---

Generated from the config in `~/.config/nvim`. Neovim defaults reflect 0.11+ — check `:help lsp-defaults` and `:help default-mappings` for your version, and `:verbose map <keys>` to see what actually owns a binding.

An HTML version with a live filter and light/dark theming is at [`keymaps.html`](./keymaps.html).
