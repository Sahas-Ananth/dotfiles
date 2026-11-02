-- Desc: Automatically detect indent settings and expand tabs to spaces based on file content
-- URL: https://github.com/tpope/vim-sleuth

--- @type LazySpec
return { 'tpope/vim-sleuth', event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' } }
