-- Desc: Which key shows a popup with possible keybindings of the command you started typing
-- URL: https://github.com/folke/which-key.nvim

--- @type LazySpec
return {
    'folke/which-key.nvim',
    event = { 'VeryLazy' },
    opts = {
        layout = {
            width = { min = 1 },
            spacing = 1,
        },
        keys = {
            scroll_down = '<c-n>',
            scroll_up = '<c-p>',
        },
        icons = {
            mappings = vim.g.have_nerd_font,
            keys = {
                C = 'C-',
                M = 'M-',
            },
        },
        spec = {
            { '<leader>g', group = '[G]it', mode = { 'n', 'v', 'x' } },
            { '<leader>h', group = '[H]unk', mode = { 'n', 'v', 'x' } },
            { '<leader>s', group = '[S]earch' },
            { '<leader>v', group = '[V]im Search' },
            { '<leader>n', group = '[N]otification' },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>E', group = '[E]ditor' },
            { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
            { 'gr', group = 'LSP' },
            -- Grapple
            { '<leader>m', group = 'Grapple' },
            { '<C-1>', hidden = true },
            { '<C-2>', hidden = true },
            { '<C-3>', hidden = true },
            { '<C-4>', hidden = true },
            { '<C-5>', hidden = true },
            { '<C-6>', hidden = true },
            { '<C-7>', hidden = true },
            { '<C-8>', hidden = true },
            { '<C-9>', hidden = true },
        },
    },
}
