vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { remap = false })
-- Copy current filepath to system clipboard
-- If you'd prefer the absolute path, change "%" to "%:p".
vim.keymap.set("n", "cp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.fn.setreg('"', path)
    print("Copied: " .. path)
end)
