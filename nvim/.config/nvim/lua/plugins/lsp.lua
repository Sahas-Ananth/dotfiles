-- Desc: LSP configurations, Auto server and tools installer and configurer
-- URL: https://github.com/neovim/nvim-lspconfig
-- URL: https://github.com/mason-org/mason.nvim
-- URL: https://github.com/mason-org/mason-lspconfig.nvim
-- URL: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim

--- @type table<string, vim.lsp.Config>
local lsps = {
    clangd = {
        cmd = {
            'clangd',
            '--background-index',
            '--offset-encoding=utf-16',
            '--clang-tidy',
            '--all-scopes-completion',
            '--cross-file-rename',
            '--completion-style=detailed',
            '--header-insertion-decorators',
            '--header-insertion=never',
            '--pch-storage=memory',
            '--query-driver=**',
        },
    },
    lua_ls = {
        --- @type lspconfig.settings.lua_ls
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        '/usr/local/share/awesome/lib',
                        (vim.fn.expand '~') .. '/.config/awesome',
                    },
                    -- Or pull in all of 'runtimepath'.
                    -- NOTE: this is a lot slower and will cause issues when working on your own configuration
                    -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                    -- library = vim.api.nvim_get_runtime_file('', true),
                },
                telemetry = { enable = false },

                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                diagnostics = { disable = { 'missing-fields' } },
            },
        },
    },
    -- Jinja
    jinja_lsp = {},

    -- Python stuff
    --[[ 'basedpyright',  ]]
}
local tools = {
    'stylua',
    'buildifier',
    'bibtex-tidy',
    'latexindent',
    -- Python stuff
    --[[ 'isort', 'black', 'docformatter', ]]
}

local install = vim.tbl_keys(lsps)
vim.list_extend(install, tools)

-- Single global group for the primary LSP hooks
local lsp_attach_group = vim.api.nvim_create_augroup('Custom-LSP', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_attach_group,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
            return
        end

        -- 1. Document Highlights
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_group = vim.api.nvim_create_augroup('Custom-LSP-Highlight', { clear = false })

            vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_group,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_group,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                buffer = event.buf,
                callback = function()
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
                end,
            })
        end

        -- 2. Inlay Hints
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set('n', '<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
            end, { buffer = event.buf, desc = '[T]oggle Inlay [H]ints' })

            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
        end

        -- 3. LSP based folding (Using win_findbuf to resolve lua-ls field warnings)
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
            local wins = vim.fn.win_findbuf(event.buf)
            for _, win in ipairs(wins) do
                vim.wo[win].foldmethod = 'expr'
                vim.wo[win].foldexpr = 'v:lua.vim.lsp.foldexpr()'
            end
        end
    end,
})

vim.api.nvim_create_autocmd({ 'LspDetach' }, {
    group = vim.api.nvim_create_augroup('Custom-LSP-Cleanup', { clear = true }),
    desc = 'Stop LSP client when its last buffer dies',
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client or not client.attached_buffers then
            return
        end

        for bufnr in pairs(client.attached_buffers) do
            if bufnr ~= ev.buf then
                return
            end
        end

        -- Revert window folding expressions back to Treesitter right before killing the client
        local target_wins = vim.fn.win_findbuf(ev.buf)
        for _, win in ipairs(target_wins) do
            vim.wo[win].foldmethod = 'expr'
            vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end

        -- Force stop client
        client:stop(true)
    end,
})

--- @type LazySpec[]
return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufWritePost', 'BufNewFile' },
    dependencies = {
        { 'j-hui/fidget.nvim', config = true },
        {
            'mason-org/mason-lspconfig.nvim',
            dependencies = {
                { 'mason-org/mason.nvim', config = true },
                { 'WhoIsSethDaniel/mason-tool-installer.nvim', opts = { ensure_installed = install } },
            },
            --- @type MasonLspconfigSettings
            opts = { automatic_enable = { exclude = { 'stylua' } } }, -- I want stylua for formatting only
        },
    },
    config = function()
        -- HACK: Patch this in cause it wasn't loaded at that point
        -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
        -- local lspconfig_path = vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1]
        local lspconfig_path = vim.api.nvim_get_runtime_file('', true)
        if lspconfig_path then
            -- table.insert(lsps.lua_ls.settings.Lua.workspace.library, lspconfig_path)
            vim.list_extend(lsps.lua_ls.settings.Lua.workspace.library, lspconfig_path)
        end
        -- Iterate over the lsp keys and values and set up each server with its config
        for server, config in pairs(lsps) do
            vim.lsp.config(server, config)
        end
    end,
    keys = {
        {
            '<leader>cs',
            '<cmd>LspClangdSwitchSourceHeader<cr>',
            desc = '[S]witch Header and Source files',
            ft = { 'c', 'cpp', 'cuda' },
        },
    },
}
