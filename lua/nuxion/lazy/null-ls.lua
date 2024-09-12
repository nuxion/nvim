return {
    "jose-elias-alvarez/null-ls.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local null_ls = require("null-ls")
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        null_ls.setup({
            sources = {
                null_ls.builtins.diagnostics.ruff,
                null_ls.builtins.formatting.ruff,
            },
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
            -- on_attach = function(client, bufnr)
            --     if client.supports_method("textDocument/formatting") then
            --         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            --         vim.api.nvim_create_autocmd("BufWritePre", {
            --             group = augroup,
            --             buffer = bufnr,
            --             callback = function()
            --                 -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
            --                 -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
            --                 vim.lsp.buf.formatting_sync()
            --             end,
            --         })
            --     end
            -- end,
        })

        -- vim.keymap.set('n', '<leader>ff', null_ls.builtins.formatting.ruff, {})
    end

}
