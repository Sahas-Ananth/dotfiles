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


local def = s(
    { trig = 'def', dscr = 'Makes a definition env' },
    fmta(
        [[
    \begin{definition}[<>]
        <>
    \end{definition}
    ]],
        {
            i(1),
            c(2, {
                f(function(name)
                    return '\\label{def:' .. (string.gsub(string.lower(name[1][1]), '[^%a]+', '_') or '') .. '}'
                end, { 1 }),
                i(0),
            }),
        }
    )
)

local TS = {
    def,
}

return TS
