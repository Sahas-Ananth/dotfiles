-- Desc: Nice git signs in the statuscolumn
-- URL: https://github.com/lewis6991/gitsigns.nvim

--- @type LazySpec
return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    opts = { word_diff = false, current_line_blame = false, current_line_blame_opts = { virt_text_pos = 'right_align' } },
    --- @type LazyKeys
    keys = {
        {
            ']c',
            function()
                local gs = package.loaded.gitsigns
                if vim.wo.diff then
                    return ']c'
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return '<Ignore>'
            end,
            expr = true,
            mode = { 'n', 'v' },
            desc = 'Next Hunk',
        },
        {
            '[c',
            function()
                local gs = package.loaded.gitsigns
                if vim.wo.diff then
                    return '[c'
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return '<Ignore>'
            end,
            expr = true,
            mode = { 'n', 'v' },
            desc = 'Previous Hunk',
        },
        {
            '<leader>hs',
            function()
                local gs = package.loaded.gitsigns
                if vim.fn.mode():match '[vV\22]' then
                    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                else
                    gs.stage_hunk()
                end
            end,
            mode = { 'n', 'v' },
            desc = 'Stage git hunk',
        },
        {
            '<leader>hr',
            function()
                local gs = package.loaded.gitsigns
                if vim.fn.mode():match '[vV\22]' then
                    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                else
                    gs.reset_hunk()
                end
            end,
            mode = { 'n', 'v' },
            desc = 'Reset git hunk',
        },
        {
            '<leader>hS',
            function()
                local gs = package.loaded.gitsigns
                gs.stage_buffer()
            end,
            mode = 'n',
            desc = 'Git Stage buffer',
        },
        {
            '<leader>hu',
            function()
                local gs = package.loaded.gitsigns
                gs.undo_stage_hunk()
            end,
            mode = 'n',
            desc = 'Undo stage hunk',
        },
        {
            '<leader>hR',
            function()
                local gs = package.loaded.gitsigns
                gs.reset_buffer()
            end,
            mode = 'n',
            desc = 'Git Reset buffer',
        },
        {
            '<leader>hp',
            function()
                local gs = package.loaded.gitsigns
                gs.preview_hunk()
            end,
            mode = 'n',
            desc = 'Preview git hunk',
        },
        {
            '<leader>hb',
            function()
                local gs = package.loaded.gitsigns
                gs.blame_line { full = false }
            end,
            mode = 'n',
            desc = 'Git blame line',
        },
        {
            '<leader>tb',
            function()
                local gs = package.loaded.gitsigns
                gs.toggle_current_line_blame()
            end,
            mode = 'n',
            desc = 'Toggle git blame line',
        },
        {
            '<leader>td',
            function()
                local gs = package.loaded.gitsigns
                gs.toggle_deleted()
            end,
            mode = 'n',
            desc = 'Toggle git show deleted',
        },
        {
            'ih',
            '<Cmd><C-U>Gitsigns select_hunk<CR>',
            mode = { 'o', 'x' },
            desc = 'Select git hunk',
        },
        --[[ {
            '<leader>hd',
            function()
                local gs = package.loaded.gitsigns
                gs.diffthis()
            end,
            mode = 'n',
            desc = 'Git diff against index',
        },
        {
            '<leader>hD',
            function()
                local gs = package.loaded.gitsigns
                gs.diffthis '~'
            end,
            mode = 'n',
            desc = 'Git diff against last commit',
        }, ]]
    },
}
