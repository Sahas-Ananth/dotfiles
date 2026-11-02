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

local betterForLoop = s(
    { trig = 'forb', dscr = 'A custom for loop' },
    fmta(
        [[
        for(<> <> = <>; <> <> <>; <><>){
            <>;
        }
    ]],
        {
            c(1, {
                t 'auto',
                t 'std::size_t',
                t 'int',
                i(1, 'iter_type'),
            }),
            i(2, 'iter_name'),
            c(3, {
                t '0',
                i(3),
                t '.begin()',
            }),
            rep(2),
            i(4, 'condition'),
            c(5, {
                i(5),
                t '.end()',
            }),
            c(6, { t '++', t '--' }),
            rep(2),
            i(0),
        }
    )
)

local CPP_S = {
    betterForLoop,
}

return CPP_S
