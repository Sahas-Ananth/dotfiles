local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Load the built-in undotree plugin automatically
vim.cmd 'packadd nvim.undotree'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Add ROS MESSAGE as filetype
vim.filetype.add {
    extension = {
        msg = 'rosmsg',
        srv = 'rossrv',
        action = 'rosaction',
        j2 = 'jinja',
        jinja2 = 'jinja',
    },
}

-- Experimental UI2
-- See: https://www.reddit.com/r/neovim/comments/1sfmgkb/comment/oeyrgua
-- See: https://neovim.io/doc/user/lua/#ui2
autocmd('FileType', {
    pattern = 'msg',
    callback = function()
        local ui2 = require 'vim._core.ui2'
        local win = ui2.wins and ui2.wins.msg
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_option_value('winhighlight', 'Normal:NormalFloat,FloatBorder:FloatBorder', { scope = 'local', win = win })
        end
    end,
})

local ui2 = require 'vim._core.ui2'
local msgs = require 'vim._core.ui2.messages'
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
    orig_set_pos(tgt)
    if (tgt == 'msg' or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
        pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
            relative = 'editor',
            anchor = 'NE',
            row = 1,
            col = vim.o.columns - 1,
            border = 'rounded',
        })
    end
end
