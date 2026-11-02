-- Desc: Autopair plugin
-- URL: https://github.com/windwp/nvim-autopairs

--- @type LazySpec
return { 'windwp/nvim-autopairs', lazy = true, event = 'InsertEnter', opts = { fast_wrap = {} } }
