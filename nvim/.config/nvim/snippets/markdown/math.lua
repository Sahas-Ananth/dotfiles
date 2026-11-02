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

local mathcal = s({ trig = 'mc', dscr = 'mathcal' }, fmta('\\mathcal{<>}<>', { i(1), i(0) }, {}))
local mathbb = s({ trig = 'mb', dscr = 'mathbb' }, fmta('\\mathbb{<>}<>', { i(1), i(0) }, {}))
local pwr = s({ trig = 'pwr', dscr = 'Raised to the pwr' }, fmta('{<>}^{<>}<>', { i(1), i(2), i(0) }, {}))
local sub = s({ trig = 'sub', dscr = 'Subscript' }, fmta('{<>}_{<>}<>', { i(1), i(2), i(0) }, {}))
local mat = s({ trig = 'mat', dscr = 'Matrix' }, fmta('\\begin{bmatrix}<>\\end{bmatrix}<>', { i(1), i(0) }, {}))

local MDS = {
    mathcal,
    mathbb,
    pwr,
    sub,
    mat,
    --
}

return MDS
