-- Desc: Snippet engine for neovim
-- URL: https://github.com/L3MON4D3/LuaSnip

--- @type LazySpec
return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    lazy = true,
    event = { 'InsertEnter' },
    build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
        end
        return 'make install_jsregexp'
    end)(),
    -- Adds a number of user-friendly snippets
    dependencies = { { 'rafamadriz/friendly-snippets', lazy = true } },
    keys = {
        {
            '<C-h>',
            function()
                if require('luasnip').choice_active() then
                    require('luasnip').change_choice(-1)
                end
            end,
            mode = { 'i', 's' },
            desc = 'luasnip prev choice',
            silent = true,
        },
        {
            '<C-l>',
            function()
                if require('luasnip').choice_active() then
                    require('luasnip').change_choice(1)
                end
            end,
            mode = { 'i', 's' },
            desc = 'luasnip next choice',
            silent = true,
        },
        -- TODO: Look into: :help |luasnip-extras-select_choice|
    },
    opts = {
        keep_roots = true,
        link_roots = true,
        link_children = true,
        exit_roots = false,
        update_events = { 'TextChanged', 'TextChangedI' },
        enable_autosnippets = true,
    },
    config = function(_, opts)
        local ls = require 'luasnip'
        ls.setup(opts)
        require('luasnip.loaders.from_vscode').lazy_load()
        require('luasnip.loaders.from_lua').lazy_load {
            paths = vim.fn.stdpath 'config' .. '/snippets/',
        }
    end,
}
