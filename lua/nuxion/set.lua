vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- https://superuser.com/questions/1726375/how-can-i-always-yank-text-to-clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.smartindent = true

vim.opt.wrap = false

vim.filetype.add {
    extension = {
        tf = "terraform",
        tfvars = "terraform",
        mdx = "markdown",
        hcl = "hcl",
    },
    filename = {
        [".gitignore"] = "conf",
    },
    -- pattern = {
    --     [".*/playbooks/.*.yml"] = "yaml.ansible",
    -- }
}
