-- Desc: Multiple useful utility plugins in one
-- URL: https://github.com/folke/snacks.nvim

vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
            Snacks.debug.inspect(...)
        end
        _G.bt = function()
            Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has 'nvim-0.11' == 1 then
            vim._print = function(_, ...)
                dd(...)
            end
        else
            vim.print = _G.dd
        end

        -- Create some toggle mappings
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
        Snacks.toggle.diagnostics():map '<leader>td'
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
        Snacks.toggle.inlay_hints():map '<leader>th'
    end,
})

-- When moving Rename LSP file
vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPost',
    callback = function(event)
        local actions = event.data and event.data.actions

        if not actions or vim.tbl_isempty(actions) then
            return
        end

        local action = actions[1] or actions

        if action.type == 'move' then
            Snacks.rename.on_rename_file(action.src_url, action.dest_url)
        end
    end,
})

---@class FilterSpecBase
---@field key string keybind character for <M-t>{key}
---@field files? snacks.picker.files.Config filter options for the files finder
---@field grep? snacks.picker.grep.Config filter options for the grep finder

---@alias FilterSpec table<string, FilterSpecBase>

---@type FilterSpec
local filter_specs = {
    source = {
        key = 's',
        files = { ft = { 'c', 'cpp', 'h', 'hpp' }, exclude = { 'test' } },
        grep = { ft = { 'c', 'cpp' }, exclude = { '**/test/**' } },
    },

    test = {
        key = 't',
        files = { args = { '--full-path', '(^|/)test/' } },
        grep = { ft = { 'c', 'cpp' }, glob = { '**/test/**' } },
    },

    bazel = {
        key = 'b',
        files = { args = { '\\.(bazel|bzl|bazelrc)$|^(BUILD|WORKSPACE)$' } },
        grep = { ft = { 'bazel' } },
    },

    docs = { key = 'd', files = { ft = { 'md' } }, grep = { ft = { 'md' } } },

    reset = { key = 'r' },
}

local function clear_picker_filters(picker)
    picker.opts.ft = nil
    picker.opts.exclude = nil
    picker.opts.glob = nil
    picker.opts.args = nil
end

local function apply_picker_filter(picker, kind)
    -- Clear existing filter, if any, before picker filters before applying new ones
    clear_picker_filters(picker)

    -- Get relevant filter spec, files or grep
    local spec = filter_specs[kind] and filter_specs[kind][picker.opts.finder]
    if spec then
        for k, v in pairs(spec) do
            picker.opts[k] = vim.deepcopy(v)
        end
    end

    -- Refresh picker output with new filter applied
    picker:find { refresh = true }
end

-- Auto generate picker_actions, picker_input_keys, and picker_list_keys for each filter spec
local picker_actions = {}
local picker_input_keys = {}
local picker_list_keys = {}

for name, spec in pairs(filter_specs) do
    local action_name = 'filter_' .. name

    picker_actions[action_name] = function(picker)
        apply_picker_filter(picker, name)
    end
    picker_input_keys['<M-t>' .. spec.key] = { action_name, mode = { 'i', 'n' } }
    picker_list_keys['<M-t>' .. spec.key] = action_name
end

--- @type snacks.gitbrowse.Config
local git_browse_opts = {
    notify = false,
    open = function(url)
        vim.fn.setreg('+', url)
        vim.notify('Copied to clipboard: ' .. url, vim.log.levels.INFO)
    end,
}

-- HACK: Temporary as bug in snacks, remove once fixed. See: https://github.com/folke/snacks.nvim/issues/2814
local my_projects = {
    '~/dotfiles',
    '~/torc/git/CoFu/aurix-bsw',
    '~/torc/git/CoFu/aurix-contracts',
    '~/torc/git/CoFu/vehicle_control/capability-estimation',
    '~/torc/git/CoFu/vehicle_control/capability-estimation-library',
    '~/torc/git/CoFu/vehicle_control/capability-estimation-interfaces',
    '~/torc/git/CoFu/vehicle_control/motion-control-test-tool',
    '~/torc/git/CoFu/vehicle_control/motion-control',
    '~/torc/git/CoFu/vehicle_control/body-control',
    '~/torc/git/CoFu/vehicle_control/motion-control-common',
    '~/torc/git/CoFu/vehicle_control/motion-control-interfaces',
    '~/torc/git/CoFu/vehicle_control/body-control-interfaces',
}

--- @type LazySpec
return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    --- @class snacks.Config
    opts = {
        bigfile = { enabled = true }, -- Deal with bigfiles
        ---@class snacks.explorer.Config
        explorer = { enabled = true },
        ---@class snacks.indent.Config
        indent = {
            enabled = true,
            ---@class snacks.indent.Scope.Config: snacks.scope.Config
            scope = {
                enabled = true,
                underline = true,
                hl = {
                    'MoonflyRed',
                    'MoonflyYellow',
                    'MoonflyBlue',
                    'MoonflyOrange',
                    'MoonflyGreen',
                    'MoonflyViolet',
                    'MoonflyTurquoise',
                },
            },
        },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 1000,
        },
        ---@class snacks.picker.Config
        picker = {
            enabled = true,
            formatters = {
                file = { filename_first = true, truncate = 'center' },
            },
            sources = {
                explorer = { focus = 'input', auto_close = true },
                projects = { projects = my_projects },
            },
            win = {
                input = { keys = picker_input_keys },
                list = { keys = picker_list_keys },
            },
            actions = picker_actions,
        },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        image = { enabled = true },
        words = { enabled = true },
        gitbrowse = { enabled = true },
        rename = { enabled = true },
        gh = { enabled = true },
        git = { enabled = true },
        lazygit = { enabled = true },
    },
    keys = {
        -- stylua: ignore start
        -- Delete buffer Keys:
        { '<M-c>', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },

        -- Git Browse Keys:
        { '<leader>hl', function() Snacks.gitbrowse(git_browse_opts) end, mode = { 'n', 'v', 'x' }, desc = '[L]ink Copy' },
        { '<leader>ho', function() Snacks.gitbrowse() end, mode = { 'n', 'v', 'x' }, desc = 'Link [O]pen' },

        -- Lazygit
        { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },

        -- Words Keys:
        { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' }, desc = 'Next Reference' },
        { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' }, desc = 'Prev Reference' },

        -- Rename Keys:
        { '<leader>cr', function() Snacks.rename.rename_file() end, desc = 'Rename File' },

        -- Picker Keys:
        { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart' },
        { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
        { '<leader>sf', function() Snacks.picker.files() end, desc = 'Files' },
        { '<leader>sb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Word Grep', mode = { 'n', 'x' } },
        { '<leader>sl', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
        { '<leader>sr', function() Snacks.picker.resume() end, desc = 'Resume' },
        { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
        { '<leader>sh', function() Snacks.picker.search_history() end, desc = 'History' },
        { '<leader>sm', function() Snacks.picker.man() end, desc = 'Man Pages' },
        { '<leader>sp', function() Snacks.picker.projects() end, desc = 'Projects' },
        { '<leader>sP', function() Snacks.picker() end, desc = 'Picker' },
        { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },

        -- LSP
        { 'grd', function() Snacks.picker.lsp_definitions() end, desc = '[d]efinition' },
        { 'grD', function() Snacks.picker.lsp_declarations() end, desc = '[D]eclaration' },
        { 'grr', function() Snacks.picker.lsp_references() end, nowait = true, desc = '[R]eferences' },
        { 'grt', function() Snacks.picker.lsp_type_definitions() end, desc = '[T]ype Definition' },
        { 'gri', function() Snacks.picker.lsp_implementations() end, desc = '[I]mplementation' },
        { 'grc', function() Snacks.picker.lsp_incoming_calls() end, desc = 'In[c]oming Calls' },
        { 'gro', function() Snacks.picker.lsp_outgoing_calls() end, desc = '[O]utgoing Calls' },
        { 'grs', function() Snacks.picker.lsp_symbols() end, desc = 'Document [S]ymbols' },
        { 'grw', function() Snacks.picker.lsp_workspace_symbols() end, desc = '[W]orkspace Symbols' },

        -- Editor
        { '<leader>Ec', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Config File' },

        -- Explorer
        -- { '-', function() Snacks.explorer() end, desc = 'File Explorer' },

        -- Git
        { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Branches' },
        { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'L[o]g' },
        { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'L[o]g Line' },
        { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Status' },
        { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Stash' },
        { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Log File' },

        -- GitHub
        { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'PR Open' },
        { '<leader>gP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'PR All' },

        -- Notification
        { '<leader>nh', function() Snacks.picker.notifications() end, desc = 'Notification History' },
        { '<leader>ns', function() Snacks.notifier.show_history() end, desc = 'Notification Show' },

        -- Vim searchs
        { '<leader>vr', function() Snacks.picker.registers() end, desc = 'Registers' },
        { '<leader>va', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
        { '<leader>vC', function() Snacks.picker.commands() end, desc = 'Commands' },
        { '<leader>vc', function() Snacks.picker.command_history() end, desc = 'Command History' },
        { '<leader>vh', function() Snacks.picker.help() end, desc = 'Help Pages' },
        { '<leader>vm', function() Snacks.picker.marks() end, desc = 'Marks' },
        { '<leader>vk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
        -- stylua: ignore end
    },
}
