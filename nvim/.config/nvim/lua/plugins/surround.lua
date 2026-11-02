-- Desc: Surround text objects with pairs of delimiters
-- URL: https://github.com/kylechui/nvim-surround

-- C++ Autocmds
local surround_group = vim.api.nvim_create_augroup('Custom-Surround', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = surround_group,
    pattern = { 'cpp', 'cuda' },
    callback = function()
        require('nvim-surround').buffer_setup {
            surrounds = {
                ['C'] = {
                    add = function()
                        local type = require('nvim-surround.config').get_input 'Enter cast type: '
                        return { { 'static_cast<' .. type .. '>(' }, { ')' } }
                    end,
                },
            },
        }
    end,
})

--- @type LazySpec
return { 'kylechui/nvim-surround', version = '*', event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' }, config = true }
