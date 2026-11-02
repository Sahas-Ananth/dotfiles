-- Desc: Plugin to format code
-- URL: https://github.com/stevearc/conform.nvim

--- @type LazySpec
return {
    'stevearc/conform.nvim',
    lazy = true,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    init = function()
        vim.g.disable_autoformat = false
        vim.b.disable_autoformat = false
    end,
    --- @type LazyKeys[]
    keys = {
        {
            '<leader>cf',
            function()
                require('conform').format { async = false, lsp_fallback = true }
            end,
            desc = 'Code Format',
        },
        {
            '<leader>tf',
            function()
                vim.b.disable_autoformat = not vim.b.disable_autoformat
            end,
            desc = 'Format on save buffer',
        },
        {
            '<leader>tF',
            function()
                vim.g.disable_autoformat = not vim.g.disable_autoformat
            end,
            mode = '',
            desc = 'Format on save Global',
        },
    },
    opts = {
        formatters_by_ft = {
            -- python = { 'isort', 'black', 'docformatter' },
            bib = { 'bibtex-tidy' },
            bzl = { 'buildifier' },
            c = { 'clang_format' },
            h = { 'clang_format' },
            cpp = { 'clang_format' },
            hpp = { 'clang_format' },
            cuda = { 'clang_format' },
            tex = { 'latexindent' },
            lua = { 'stylua' },
            ['*'] = { 'trim_whitespace', 'trim_newlines' },
        },
        format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return { lsp_fallback = true, async = false, timeout_ms = 500 }
        end,
        -- Modifying Latex Indent to take search for a local formatting specs
        -- See: https://ctan.uib.no/support/latexindent/documentation/latexindent.pdf#page=98&zoom=264
        formatters = {
            latexindent = { prepend_args = { '-l', '-m' } },
            docformatter = { prepend_args = { '--black' } },
        },
    },
}
