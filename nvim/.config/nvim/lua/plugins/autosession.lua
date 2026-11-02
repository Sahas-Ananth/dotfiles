-- Desc: Auto saves session, keeps tabs, windows, buffers etc.
-- URL: https://github.com/rmagatti/auto-session

--- @type LazySpec
return {
    'rmagatti/auto-session',
    lazy = false,
    init = function()
        vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
    end,
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        suppressed_dirs = { '/' },
    },
}
