-- nvim-treesitter `main` branch.
--
-- `main` is a full, incompatible rewrite of the deprecated `master` branch:
-- there is no `nvim-treesitter.configs`, no modules, and no `auto_install`.
-- The plugin only installs parsers and ships the queries that Neovim's own
-- treesitter runtime consumes; highlighting and indentation are turned on
-- per-buffer in the FileType autocommand below.
--
-- `master` is pinned to Nvim <= 0.11 and breaks on 0.12 (its custom query
-- directives still assume `match[id]` is a single node rather than a list).

local parsers = {
    "vimdoc",
    "javascript",
    "typescript",
    "c",
    "lua",
    "go",
    "rust",
    "python",
    "jsdoc",
    "html",
    "bash",
    "fish",
    "yaml",
    "toml",
    "json",
    "terraform",
    "dockerfile",
    "gitignore",
    "markdown",
    "markdown_inline",
    "hcl",
    "astro",
    "tsx",
    "css",
    "templ",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- `main` does not support lazy-loading
    build = ":TSUpdate",
    config = function()
        local nts = require("nvim-treesitter")

        nts.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- Asynchronous, and a no-op once the parsers are present.
        nts.install(parsers)

        -- `main` dropped `auto_install`, so rebuild it: on a miss, install in
        -- the background and attach once the compile finishes.
        local function auto_install(buf, lang)
            if not vim.list_contains(nts.get_available(), lang) then
                return
            end

            nts.install({ lang }):await(function()
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(buf) then
                        pcall(vim.treesitter.start, buf, lang)
                    end
                end)
            end)
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("NuxionTreesitter", { clear = true }),
            callback = function(ev)
                local lang = vim.treesitter.language.get_lang(ev.match)
                if not lang then
                    return
                end

                -- `start` throws when the parser is not installed yet.
                if not pcall(vim.treesitter.start, ev.buf, lang) then
                    auto_install(ev.buf, lang)
                    return
                end

                -- Treesitter indentation is still experimental upstream, so
                -- only take it over where the language ships an indents query.
                if vim.treesitter.query.get(lang, "indents") then
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end

                -- Replaces `additional_vim_regex_highlighting = { "markdown" }`
                if lang == "markdown" then
                    vim.bo[ev.buf].syntax = "on"
                end
            end,
        })
    end,
}
