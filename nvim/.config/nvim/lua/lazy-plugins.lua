require('lazy').setup('plugins', {
    defaults = { lazy = true },
    change_detection = {
        enabled = true,
        notify = false,
    },
    profiling = {
        -- Enables extra stats on the debug tab related to the loader cache.
        -- Additionally gathers stats about all package.loaders
        loader = true,
        -- Track each new require in the Lazy profiling tab
        require = true,
    },
    ui = {
        border = 'rounded',
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        icons = { cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙', keys = '🗝', lazy = '💤 ', plugin = '🔌', require = '🌙', runtime = '💻', source = '📄', start = '🚀', task = '' },
    },
})
