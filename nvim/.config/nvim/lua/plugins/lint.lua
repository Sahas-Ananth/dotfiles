-- Desc: Linter plugin
-- URL: https://github.com/mfussenegger/nvim-lint

--- @type LazySpec
return {
    'mfussenegger/nvim-lint',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' }, -- to disable, comment this out
    config = function()
        local lint = require 'lint'
        lint.linters_by_ft = {
            cpp = { 'clangtidy' },
            c = { 'clangtidy' },
            h = { 'clangtidy' },
            hpp = { 'clangtidy' },
            cuda = { 'clangtidy' },
            cmake = { 'cmakelint' },
        }
        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

        vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufWritePost', 'InsertLeave' }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
    keys = {
        {
            '<leader>cl',
            function()
                require('lint').try_lint()
            end,
            mode = '',
            desc = '[C]ode [L]int',
        },
    },
}
