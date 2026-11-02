-- Desc: Statusline plugin for Neovim
-- URL: https://github.com/nvim-lualine/lualine.nvim

-- Map from long mode names to short ones for display in the statusline
local mode_map = {
    ['NORMAL'] = 'N',
    ['O-PENDING'] = 'N?',
    ['INSERT'] = 'I',
    ['VISUAL'] = 'V',
    ['V-BLOCK'] = 'VB',
    ['V-LINE'] = 'VL',
    ['V-REPLACE'] = 'VR',
    ['REPLACE'] = 'R',
    ['COMMAND'] = '!',
    ['SHELL'] = 'SH',
    ['TERMINAL'] = 'T',
    ['EX'] = 'X',
    ['S-BLOCK'] = 'SB',
    ['S-LINE'] = 'SL',
    ['SELECT'] = 'S',
    ['CONFIRM'] = 'Y?',
    ['MORE'] = 'M',
}

--- @type LazySpec
return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- Set an empty statusline till lualine loads
            vim.o.statusline = ' '
        else
            -- Hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    -- See `:help lualine.txt`
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = '|',
            section_separators = ' ',
        },
        sections = {
            lualine_a = { {
                'mode',
                fmt = function(s)
                    return mode_map[s] or s
                end,
            } },
            lualine_b = {
                'branch',
                'diff',
                {
                    function()
                        local grapple = package.loaded['grapple']
                        return grapple.statusline()
                    end,
                    cond = function()
                        return package.loaded['grapple'] ~= nil
                    end,
                },
            },
            lualine_c = { 'buffers' },
            lualine_x = { 'tabs', 'fileformat', 'filetype' },
            lualine_y = { 'encoding', 'filetype' },
            lualine_z = { 'searchcount', 'selectioncount', 'location' },
        },
    },
}
