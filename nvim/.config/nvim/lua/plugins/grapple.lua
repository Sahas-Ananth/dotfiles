-- Desc: An alternative to Harpoon.nvim
-- URL: https://www.github.com/cbochs/grapple.nvim

--- @type LazySpec
return {
    'cbochs/grapple.nvim',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    opts = {
        scope = 'git_branch', -- also try out "git_branch"
    },
    cmd = 'Grapple',
    keys = function()
        --- @type LazyKeys[]
        local keys = {
            { '<leader>ma', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
            { '<leader>mm', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
            { '<C-n>', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
            { '<C-p>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
        }
        for i = 1, 9 do
            table.insert(keys, {
                '<C-' .. i .. '>',
                '<cmd>Grapple select index=' .. i .. '<cr>',
            })
        end
        return keys
    end,
}
