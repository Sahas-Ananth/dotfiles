-- Desc: Copilot Plugin
-- URL: https://github.com/zbirenbaum/copilot.lua

--- @type LazySpec
return {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = 'Copilot',
    build = ':Copilot auth',
    dependencies = { { 'fang2hou/blink-copilot', event = 'InsertEnter' } },
    keys = {
        -- TODO: Make this a snacks toggle
        {
            '<leader>tc',
            function()
                if require('copilot.client').is_disabled() then
                    require('copilot.command').enable()
                else
                    require('copilot.command').disable()
                end
            end,
            desc = 'Toggle Copilot',
        },
    },
    opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
    },
}
