return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- require("trouble").setup({
            --    icons = false,
            -- })
            require("trouble").setup({
                auto_fold = false,
                fold_open = " ",
                fold_closed = " ",
                height = 6,
                indent_str = " ┊   ",
                include_declaration = {
                    "lsp_references",
                    "lsp_implementations",
                    "lsp_definitions"
                },
                mode = "workspace_diagnostics",
                multiline = true,
                padding = false,
                position = "bottom",
                severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
                -- signs = require("utils.icons").diagnostics,
                use_diagnostic_signs = true,
            })
            vim.keymap.set("n", "<leader>tt", ":Trouble diagnostics toggle focus=true<cr>")
            --local r = require("utils.remaps")
            -- r.noremap("n", "<leader>lr", ":TroubleToggle lsp_references<cr>", "lsp references ")
            -- r.noremap("n", "<leader>le", ":TroubleToggle document_diagnostics<cr>", "diagnostics")
            -- r.noremap("n", "<leader>t", function()
                -- require("lsp_lines").toggle()
                -- vim.cmd [[TroubleToggle workspace_diagnostics]]
                -- end, "toggle trouble  ")

            -- vim.keymap.set("n", "<leader>t", function()
            --     require("trouble").toggle()
            -- end)

            -- vim.keymap.set("n", "[t", function()
            --     require("trouble").next({skip_groups = true, jump = true});
            -- end)

            -- vim.keymap.set("n", "]t", function()
            --     require("trouble").previous({skip_groups = true, jump = true});
            -- end)

        end
    },
}
