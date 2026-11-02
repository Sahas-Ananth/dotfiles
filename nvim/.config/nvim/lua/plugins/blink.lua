-- Desc: Better completion plugin
-- URL: https://github.com/saghen/blink.cmp
-- URL: https://github.com/fang2hou/blink-copilot

--- @type LazySpec
return {
    'saghen/blink.cmp',
    version = '1.*',
    enabled = true,
    -- event = { 'InsertEnter' },
    event = { 'InsertEnter', 'CmdlineEnter' },
    -- event = { 'InsertEnter', 'CmdwinEnter' },
    dependencies = {
        -- { 'L3MON4D3/LuaSnip', event = 'InsertEnter' },
        -- { 'fang2hou/blink-copilot', event = 'InsertEnter', dependencies = { 'zbirenbaum/copilot.lua' } },
        -- 'folke/lazydev.nvim',
    },
    ---@module 'blink.cmp'
    opts = {
        keymap = {
            preset = 'default',
            ['<Tab>'] = { 'fallback' },
            ['<S-Tab>'] = { 'fallback' },
            ['<C-j>'] = { 'snippet_forward', 'fallback' },
            ['<C-k>'] = { 'snippet_backward', 'fallback' },
        },
        snippets = { preset = 'luasnip' },
        sources = {
            default = {
                --[[ 'lazydev', ]]
                'snippets',
                'lsp',
                'copilot',
                'path',
                'buffer',
            },
            providers = {
                -- lazydev = {
                --     name = 'LazyDev',
                --     module = 'lazydev.integrations.blink',
                --     -- make lazydev completions top priority (see `:h blink.cmp`)
                --     score_offset = 100,
                -- },
                copilot = {
                    name = 'copilot',
                    module = 'blink-copilot',
                    score_offset = -2,
                    async = true,
                },
                -- Increase snippet priority
                snippets = { score_offset = 2 },
                path = {
                    opts = {
                        -- Show hidden dirs by default
                        show_hidden_files_by_default = true,
                        -- Start at cwd of the vim instance, not the buffer
                        get_cwd = function(_)
                            return vim.fn.getcwd()
                        end,
                    },
                },
            },
        },
        completion = {
            keyword = { range = 'full' },
            documentation = { auto_show = true, auto_show_delay_ms = 0 },
            ghost_text = { enabled = true },
            trigger = { show_on_insert_on_trigger_character = true, show_on_x_blocked_trigger_characters = { "'", '"', '(', '{', '[' } },
            menu = { draw = { columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } } } },
        },
        signature = { enabled = true, trigger = { enabled = true } },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        cmdline = { keymap = { preset = 'inherit' }, completion = { menu = { auto_show = true }, ghost_text = { enabled = true } } },
    },
    opts_extend = { 'sources.default' },
}
