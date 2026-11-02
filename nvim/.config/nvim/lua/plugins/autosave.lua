-- Desc: Autosave plugin
-- URL: https://github.com/okuuva/auto-save.nvim

-- Most of these are usually set to non-modifiable, which prevents autosaving by default, but it doesn't hurt to be extra safe.
local excluded_filetypes = {
    'gitcommit', -- This one is especially useful if you use neovim as a commit message editor
    'TelescopePrompt',
    'lazygit',
    'oil',
    'prompt',
    'grapple',
    'qf',
}

local function save_condition(buf)
    if vim.tbl_contains(excluded_filetypes, vim.fn.getbufvar(buf, '&filetype')) then
        return false
    end
    return true
end

--- @type LazySpec
return {
    'okuuva/auto-save.nvim',
    event = { 'InsertLeave', 'TextChanged', 'FocusLost' },
    opts = {
        debounce_delay = 10000,
        condition = save_condition,
    },
}
