local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local r = ls.restore_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep
local ai = require 'luasnip.nodes.absolute_indexer'

local function rep_w_ins(pos, repeat_index)
    return d(pos, function(args)
        return sn(nil, {
            t(args[1][1]),
            i(1),
        })
    end, { repeat_index })
end

local newfile = s(
    { trig = 'tnewf', dscr = 'A new CPP file with Torc license.' },
    fmta(
        [[// CONFIDENTIAL - do not disclose, distribute, or alter without express permission by TORC Robotics.
// All use subject to express agreement only. No implied use or license.
//
// Software copyrights by TORC Robotics, Inc as of initial publish date.
//
// Unless required by applicable law or agreed in writing, use of software is on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// Initial Publish Date: <>
// Initial Author: Sahasrajit Anantharamakrishnan

<>
// Component
<>

// Library
<>

// Standard
<>

<>
]],
        {
            t(os.date '%d %B %Y'),
            c(1, {
                fmta(
                    [[
                #ifndef <>
                #define <>
                ]],
                    {
                        d(1, function(args, parent)
                            return sn(nil, {
                                i(1, parent.snippet.env.TM_FILENAME_BASE:gsub('(%u)', '_%1'):gsub('^_', ''):upper() .. '_HPP'),
                            })
                        end, {}),
                        rep(1),
                    }
                ),
                t '',
            }),
            i(2),
            i(3),
            i(0),
            f(function(args)
                ---@type string
                local value = args[1][1]
                local name = ''
                if string.find(value, '#ifndef') then
                    local words = {}
                    for word in value:gmatch '%S+' do
                        table.insert(words, word)
                    end
                    if words[2] then
                        name = words[2]
                    end
                    return '#endif // ' .. name
                end
                return name
            end, { 1 }),
        }
    )
)
local std_class = s(
    { trig = 'mccla', dscr = 'Generic Class in Vehicle Control Repos' },
    fmta(
        [[
        class <>
        {
        public:
            /// @brief Constructor for `<>` class
            explicit <>(<>)<>

            /// @brief Default Destructor for the `<>` class
            ~<>() = default;

            /// @brief Delete move and copy functions and operators
            /// @{
            <>(<>&&) = delete;
            <>(const <>&) = delete;
            <>& operator=(<>&&) = delete;
            <>& operator=(const <>&) = delete;
            /// @}

            <>

        private:
            <>
        };<>
        ]],
        {
            i(1, 'ClassName'),
            rep(1),
            rep(1),
            i(2),
            c(3, { t ' = default;', t ';', i(3, ' // Insert Text') }),
            rep(1),
            rep(1),
            rep(1),
            rep(1),
            rep(1),
            rep(1),
            rep(1),
            rep(1),
            rep(1),
            rep(1),
            i(4),
            i(5),
            i(0),
        }
    )
)

local test_fixture = s(
    { trig = 'testf', dscr = 'Generic Test Fixture' },
    fmta(
        [[
        class <> : public ::testing::Test
        {
        protected:
            <>

            void SetUp() override
            {
            <>
            }
        };<>
        ]],
        { i(1, 'TestFixtureName'), i(2, '// TF Common variable'), i(3, '// Setup Code'), i(0) }
    )
)

local test_doxy_comment = s(
    { trig = 'ttdoxy', dscr = 'Doxygen Comment for Test Case' },
    fmta(
        [[
    /// @test Tests the <>
    /// @details
    /// Unit test type: unit test
    /// Description: Tests <>
    /// Setup: <>
    /// Action: <>
    /// Assertion: <>
    ]],
        {
            i(1, 'What does this Test test?'),
            rep_w_ins(2, 1),
            i(3, 'What do you do to setup the test?'),
            i(4, 'What action are you taking in the test?'),
            i(5, 'What are you asserting in the test?'),
        }
    )
)

local TORC_SNIPS = {
    newfile,
    std_class,
    test_fixture,
    test_doxy_comment,
}

return TORC_SNIPS
