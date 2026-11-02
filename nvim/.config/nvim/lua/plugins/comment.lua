-- Desc: Comment plugin, that supports both line and block comments
-- URL: https://github.com/numToStr/Comment.nvim

--- @type LazySpec
return { 'numToStr/Comment.nvim', event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' }, config = true }
