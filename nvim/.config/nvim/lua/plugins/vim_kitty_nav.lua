-- Navigate seamlessly between neovim and kitty windows
-- URL: https://github.com/knubie/vim-kitty-navigator

--- @type LazySpec
return {
    'knubie/vim-kitty-navigator',
    build = 'cp ./*.py ~/.config/kitty/',
    init = function()
        vim.g.kitty_navigator_no_mappings = 1
    end,
    keys = {
        {
            '<M-h>',
            '<cmd>KittyNavigateLeft<cr>',
            noremap = true,
        },
        {
            '<M-j>',
            '<cmd>KittyNavigateDown<cr>',
            noremap = true,
        },
        {
            '<M-k>',
            '<cmd>KittyNavigateUp<cr>',
            noremap = true,
        },
        {
            '<M-l>',
            '<cmd>KittyNavigateRight<cr>',
            noremap = true,
        },
    },
}
