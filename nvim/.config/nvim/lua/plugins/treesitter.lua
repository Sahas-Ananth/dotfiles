-- Desc: Tree sitter configurations and it's related plugins
-- URL: https://github.com/nvim-treesitter/nvim-treesitter
-- URL: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- URL: https://github.com/windwp/nvim-ts-autotag
-- URL: https://github.com/Wansmer/treesj

-- TODO: maybe add these if you miss them:
-- https://github.com/nvim-treesitter/nvim-treesitter-context
-- https://github.com/andymass/vim-matchup

local ts_setup = function()
    local ignore_install = { latex = false }

    -- Syntax highlight printf formats
    require('nvim-treesitter').install {
        'bash',
        'c',
        'cpp',
        'css',
        'diff',
        'dockerfile',
        'html',
        'javascript',
        'latex',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'printf',
        'python',
        'query',
        'regex',
        'scss',
        'starlark',
        'svelte',
        'toml',
        'tsx',
        'typst',
        'vim',
        'vimdoc',
        'vue',
        'xml',
        'yaml',
    }

    -- Start tree-sitter when opening a file of the specified filetype
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('tree-sitter-enable', { clear = true }),
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match)

            -- 1. nvim doesn't know this filetype → do nothing
            if not lang then
                vim.notify('[TS] lang nil for ft=' .. args.match .. ', skipping...', vim.log.levels.INFO)
                return
            end

            local is_ignored = ignore_install[lang] == true
            local has_parser = vim.treesitter.language.add(lang)

            -- 2. No parser on system → install unless ignored
            if not has_parser then
                if not is_ignored and require('nvim-treesitter.parsers')[lang] ~= nil then
                    vim.notify('[TS] installing parser: ' .. lang, vim.log.levels.INFO)
                    require('nvim-treesitter').install({ lang }):wait(300000)
                elseif is_ignored then
                    vim.bo[args.buf].syntax = args.match
                    return
                else
                    return
                end
            end

            -- Parser available but ignored → regex highlight only, skip TS features
            if is_ignored then
                vim.bo[args.buf].syntax = args.match
                return
            end

            -- 3. Highlighting: TS
            if vim.treesitter.query.get(lang, 'highlights') then
                vim.treesitter.start(args.buf)
            end

            -- 4. Indentation
            if vim.treesitter.query.get(lang, 'indents') then
                vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
            end

            -- 5. Folding
            if vim.treesitter.query.get(lang, 'folds') then
                vim.opt_local.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
                vim.opt_local.foldcolumn = 'auto:2' -- '0' is not bad
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldlevelstart = 99
                vim.opt_local.foldenable = true
                vim.opt_local.foldmethod = 'expr'
                vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            end
        end,
    })
end

local ts_textobjects_setup = function()
    -- Lookahead: Automatically jump forward to textobj, similar to targets.vim
    require('nvim-treesitter-textobjects').setup { select = { lookahead = true }, move = { set_jumps = true }, include_surrounding_whitespace = true }
    local ts_select = require 'nvim-treesitter-textobjects.select'
    local ts_swap = require 'nvim-treesitter-textobjects.swap'
    local ts_move = require 'nvim-treesitter-textobjects.move'
    local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

    -- Select keymaps
    vim.keymap.set({ 'x', 'o' }, 'af', function()
        ts_select.select_textobject('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'if', function()
        ts_select.select_textobject('@function.inner', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ac', function()
        ts_select.select_textobject('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ic', function()
        ts_select.select_textobject('@class.inner', 'textobjects')
    end)

    -- Swap keymaps
    vim.keymap.set('n', '<leader>a', function()
        ts_swap.swap_next '@parameter.inner'
    end, { desc = 'Swap next parameter' })
    vim.keymap.set('n', '<leader>A', function()
        ts_swap.swap_previous '@parameter.outer'
    end, { desc = 'Swap previous parameter' })

    -- Move keymaps
    -- -- function jumps
    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        ts_move.goto_next_start('@function.outer', 'textobjects')
    end, { desc = 'Next function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        ts_move.goto_next_end('@function.outer', 'textobjects')
    end, { desc = 'Next function end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        ts_move.goto_previous_start('@function.outer', 'textobjects')
    end, { desc = 'Previous function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        ts_move.goto_previous_end('@function.outer', 'textobjects')
    end, { desc = 'Previous function end' })

    -- -- class jumps
    vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        ts_move.goto_next_start('@class.outer', 'textobjects')
    end, { desc = 'Next class start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        ts_move.goto_next_end('@class.outer', 'textobjects')
    end, { desc = 'Next class end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        ts_move.goto_previous_start('@class.outer', 'textobjects')
    end, { desc = 'Previous class start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        ts_move.goto_previous_end('@class.outer', 'textobjects')
    end, { desc = 'Previous class end' })

    -- Repeat TS moves
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

    -- f, F, t, T expr remap
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
end

--- @type LazyKeys
local tsj_keys = {
    {
        '<c-j>',
        function()
            require('treesj').toggle()
        end,
        desc = 'Toggle Split/Join',
    },
    {
        '<c-j>s',
        function()
            require('treesj').split()
        end,
        desc = 'Toggle TSJ Split',
    },
    {
        '<c-j>j',
        function()
            require('treesj').join()
        end,
        desc = 'Toggle TSJ Join',
    },
}

--- @type LazySpec
return {
    'nvim-treesitter/nvim-treesitter',
    build = '<Cmd>TSUpdate',
    config = ts_setup,
    event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
    --- @type LazySpec[]
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main', config = ts_textobjects_setup },
        { 'windwp/nvim-ts-autotag', config = true },
        { 'Wansmer/treesj', opts = { use_default_keymaps = false, max_join_length = 9999 }, keys = tsj_keys },
        { 'geigerzaehler/tree-sitter-jinja2', config = true }, -- TS parser for Jinja2
    },
}
