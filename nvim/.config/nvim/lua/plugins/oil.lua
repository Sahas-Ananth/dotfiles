-- Desc: File explorer modify file tree like vim-buffers
-- URL: https://github.com/stevearc/oil.nvim

-- Feat: Show the cwd in the winbar of oil buffers
-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
    local dir = require('oil').get_current_dir()
    if dir then
        return vim.fn.fnamemodify(dir, ':~')
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

-- Feat: High gitignored files but show ignored files that are tracked by git
-- helper function to parse output
local function parse_output(proc)
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
        for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub('/$', '')
            ret[line] = true
        end
    end
    return ret
end

-- build git status cache
local function new_git_status()
    return setmetatable({}, {
        __index = function(self, key)
            local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, {
                cwd = key,
                text = true,
            })
            local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, {
                cwd = key,
                text = true,
            })
            local ret = {
                ignored = parse_output(ignore_proc),
                tracked = parse_output(tracked_proc),
            }

            rawset(self, key, ret)
            return ret
        end,
    })
end

--- @type LazySpec
return {
    'stevearc/oil.nvim',
    lazy = false,
    -- Optional dependencies
    dependencies = { { 'nvim-tree/nvim-web-devicons', lazy = true } },
    keys = {
        {
            '_',
            '<cmd>Oil --float<CR>',
            mode = 'n',
            desc = 'Oil',
        },
    },
    config = function()
        -- Initialize git status cache
        local git_status = new_git_status()

        -- Clear git status cache on refresh
        local refresh = require('oil.actions').refresh
        local orig_refresh = refresh.callback
        refresh.callback = function(...)
            git_status = new_git_status()
            orig_refresh(...)
        end

        -- Custom function to determine if a file should be hidden
        local custom_show_hidden = function(name, bufnr)
            local dir = require('oil').get_current_dir(bufnr)
            local is_dotfile = vim.startswith(name, '.') and name ~= '..'
            -- if no local directory (e.g. for ssh connections), just hide dotfiles
            if not dir then
                return is_dotfile
            end
            -- dotfiles are considered hidden unless tracked
            if is_dotfile then
                return not git_status[dir].tracked[name]
            else
                -- Check if file is gitignored
                return git_status[dir].ignored[name]
            end
        end

        -- Regular options
        local opts = {
            default_file_explorer = true,
            columns = { 'icon' },
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            prompt_save_on_new_entry = false,
            watch_for_changes = true,
            -- win_options = { wrap = true, winbar = '%!v:lua.get_oil_winbar()' },
            float = {
                padding = 1,
                max_width = 0.5,
                max_height = 0.5,
                border = 'rounded',
                win_options = {
                    winblend = 10,
                },
                override = function(conf)
                    return conf
                end,
            },
            keymaps = {
                ['gd'] = {
                    desc = 'Toggle file detail view',
                    callback = function()
                        OilDetail = not OilDetail
                        if OilDetail then
                            require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
                        else
                            require('oil').set_columns { 'icon' }
                        end
                    end,
                },
                ['q'] = { 'actions.close', mode = 'n' },
                ['<esc>'] = { 'actions.close', mode = 'n' },
            },
            lsp_file_methods = { enabled = true, autosave_changes = true },
            git = {
                add = function()
                    return false
                end,
                mv = function()
                    return true
                end,
                rm = function()
                    return true
                end,
            },
            view_options = { is_hidden_file = custom_show_hidden },
        }

        require('oil').setup(opts)
    end,
}
