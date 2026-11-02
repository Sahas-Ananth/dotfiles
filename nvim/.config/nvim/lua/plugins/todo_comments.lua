-- Desc: Highlight TODO, Notes etc. comments in code
-- URL: https://github.com/folke/todo-comments.nvim

--- @type LazySpec
return {
    'folke/todo-comments.nvim',
    -- dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    keys = {
        {
            ']t',
            function()
                require('todo-comments').jump_next()
            end,
            desc = 'Next TODO comment',
        },
        {
            '[t',
            function()
                require('todo-comments').jump_prev()
            end,
            desc = 'Previous TODO comment',
        },
    },
}
