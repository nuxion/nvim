require("nuxion")
vim.lsp.config.intelephense = {}
vim.lsp.enable("intelephense")

if vim.env.WAYLAND_DISPLAY then
    vim.g.clipboard = {
        name = 'wl-clipboard',
        copy = {
            ['+'] = 'wl-copy',
            ['*'] = 'wl-copy',
        },
        paste = {
            ['+'] = 'wl-paste --no-newline',
            ['*'] = 'wl-paste --no-newline',
        },
        cache_enabled = 0,
    }
else
    vim.g.clipboard = {
        name = 'xclip',
        copy = {
            ['+'] = 'xclip -selection clipboard',
            ['*'] = 'xclip -selection primary',
        },
        paste = {
            ['+'] = 'xclip -selection clipboard -o',
            ['*'] = 'xclip -selection primary -o',
        },
        cache_enabled = 0,
    }
end
