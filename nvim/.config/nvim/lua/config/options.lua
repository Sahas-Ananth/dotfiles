-- Set number and relative number
vim.opt.number = true
vim.opt.relativenumber = true

-- UI opts:
-- Don't redraw when running a macro
vim.opt.lazyredraw = true
-- Border for Floating windows
vim.opt.winborder = 'rounded'

-- Experimental UI2
-- See: https://www.reddit.com/r/neovim/comments/1sfmgkb/comment/oeyrgua
-- See: https://neovim.io/doc/user/lua/#ui2
vim.opt.cmdheight = 1
require('vim._core.ui2').enable {
    enable = true,
    msg = {
        targets = {
            [''] = 'msg',
            empty = 'cmd',
            bufwrite = 'msg',
            confirm = 'cmd',
            emsg = 'pager',
            echo = 'msg',
            echomsg = 'msg',
            echoerr = 'pager',
            completion = 'cmd',
            list_cmd = 'pager',
            lua_error = 'pager',
            lua_print = 'msg',
            progress = 'pager',
            rpc_error = 'pager',
            quickfix = 'msg',
            search_cmd = 'cmd',
            search_count = 'cmd',
            shell_cmd = 'pager',
            shell_err = 'pager',
            shell_out = 'pager',
            shell_ret = 'msg',
            undo = 'msg',
            verbose = 'pager',
            wildlist = 'cmd',
            wmsg = 'msg',
            typed_cmd = 'cmd',
        },
        cmd = {
            height = 0.5,
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.3,
            timeout = 5000,
        },
        pager = {
            height = 0.5,
        },
    },
}

-- Set highlight on search
vim.opt.hlsearch = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'auto'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 750

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- Turn on 24-bit color
vim.opt.termguicolors = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Number of spaces that Tab in the file counts for.
vim.opt.tabstop = 4

-- Number of spaces that a <Tab> counts for while performing editing operations, like
-- inserting a <Tab> or using <BS>.
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- No need for swap or backup files
vim.opt.swapfile = false
vim.opt.backup = false

-- Have 2 colorcolumn
vim.opt.colorcolumn = { 88, 120 }

-- Always show tabs
vim.opt.showtabline = 2

-- Schedule set the clipboard option as otherwise the startup is slow
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Spell language(s)
vim.opt.spelllang = { 'en_us' }

-- Fold options:
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldcolumn = 'auto:2' -- '0' is not bad
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Vim Diagnostic options
vim.diagnostic.config {
    float = true,
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        },
    },
}
