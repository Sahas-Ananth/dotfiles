local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local in_mathzone = function()
    -- The `in_mathzone` function requires the VimTeX plugin
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local opts = { condition = in_mathzone }

local underbrace = s(
    { trig = 'ub', dscr = 'Makes a definition env' },
    fmta('\\underbrace{<>}_{<>}<>', {
        i(1),
        c(2, {
            i(2),
            fmta('\\text{<>}', i(1)),
        }),
        i(0),
    }),
    opts
)
local txt = s({ trig = 'tx', dscr = 'Enters text mode in math envs' }, fmta('\\text{<>}<>', { i(1), i(0) }), opts)

local TS = {
    underbrace,
    txt,
}

return TS
