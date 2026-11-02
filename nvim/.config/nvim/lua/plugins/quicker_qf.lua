-- Desc: Edit QF list like a regular buffer
-- URL: https://github.com/stevearc/quicker.nvim

--- @type LazySpec
return {
    'stevearc/quicker.nvim',
    ft = 'qf',
    --- @type LazyKeys[]
    keys = {
        {
            '<leader>q',
            function()
                require('quicker').toggle()
            end,
            desc = 'Toggle quickfix context',
        },
    },
    ---@module "quicker"
    opts = {
        keys = {
            {
                '>',
                function()
                    require('quicker').expand { before = 2, after = 2, add_to_existing = true }
                end,
                desc = 'Expand quickfix context',
            },
            {
                '<',
                function()
                    require('quicker').collapse()
                end,
                desc = 'Collapse quickfix context',
            },
        },
    },
}
