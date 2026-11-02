-- Desc: Adds rainbow delimiters
-- URL: https://github.com/hiphish/rainbow-delimiters.nvim

--- @type LazySpec
return {
    'hiphish/rainbow-delimiters.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    config = function()
        require('rainbow-delimiters.setup').setup {
            highlight = { 'MoonflyRed', 'MoonflyYellow', 'MoonflyBlue', 'MoonflyOrange', 'MoonflyGreen', 'MoonflyViolet', 'MoonflyTurquoise' },
        }
    end,
}
