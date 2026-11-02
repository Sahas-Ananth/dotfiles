-- Desc: Better <c-a>/<c-x> behviour
-- URL: https://github.com/monaqa/dial.nvim

--- @type LazySpec
return {
    'monaqa/dial.nvim',
    config = function()
        local augend = require 'dial.augend'
        local months_full = augend.constant.new {
            elements = { 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' },
            word = true,
            cyclic = true,
        }

        local months = augend.constant.new {
            elements = { 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' },
            word = true,
            cyclic = true,
        }
        local default = {
            augend.integer.alias.decimal,
            augend.integer.alias.decimal_int,
            augend.integer.alias.hex,
            augend.integer.alias.octal,
            augend.integer.alias.binary,
            augend.constant.alias.bool,
            augend.constant.alias.Bool,
            augend.constant.alias.en_weekday,
            augend.constant.alias.en_weekday_full,
            augend.date.alias['%Y-%m-%d'],
            months,
            months_full,
        }
        require('dial.config').augends:register_group {
            default = default,
        }
    end,
    keys = {
        {
            '<C-a>',
            function()
                require('dial.map').manipulate('increment', 'normal')
            end,
            desc = 'Increment',
        },
        {
            '<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'normal')
            end,
            desc = 'Decrement',
        },
        {
            'g<C-a>',
            function()
                require('dial.map').manipulate('increment', 'gnormal')
            end,
            desc = 'Increment',
        },
        {
            'g<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'gnormal')
            end,
            desc = 'Decrement',
        },
        {
            '<C-a>',
            function()
                require('dial.map').manipulate('increment', 'visual')
            end,
            desc = 'Increment',
            mode = 'v',
        },
        {
            '<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'visual')
            end,
            desc = 'Decrement',
            mode = 'v',
        },
        {
            'g<C-a>',
            function()
                require('dial.map').manipulate('increment', 'gvisual')
            end,
            desc = 'Increment',
            mode = 'v',
        },
        {
            'g<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'gvisual')
            end,
            desc = 'Decrement',
            mode = 'v',
        },
    },
}
