local function set(mode, key, value, opts)
    local default = { silent = true }
    local merged = vim.tbl_deep_extend('force', default, opts or {})
    vim.keymap.set(mode, key, value, merged)
end

-- Make sure no maps are set to the leader key
set({ 'n', 'v' }, '<Space>', '<Nop>')

-- Dealing with word wrap
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Indent whilst keeping the selection
set('v', '<', '<gv')
set('v', '>', '>gv')

-- Move selected line / block of text in visual mode and indent
set('v', 'J', ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = 'Move selection down' })
set('v', 'K', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = 'Move selection up' })

-- Move current line in insert mode and indent
set('i', '<M-j>', '<Esc><cmd>execute "move .+" . v:count1<CR>==gi', { desc = 'Move line down' })
set('i', '<M-k>', '<Esc><cmd>execute "move .-" . (v:count1 + 1)<CR>==gi', { desc = 'Move line up' })

-- Move current line in normal mode and indent - I don't want this afaik
-- set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move line down' })
-- set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move line up' })

-- Append to end of line in normal mode but keep cursor in place
set('n', 'J', 'mzJ`z')

-- During vertical half page jumps keep cursor in the middle of the screen
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')

-- When searching:
-- - normal mode:
--      - Repeat search same direction as last search
--      - Keep cursor in the middle of the screen
--      - zv open fold at match
-- - Visual/operator n → Repeat search same way, no zv
set('n', 'n', "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = 'Next Search Result' })
set('n', 'N', "'nN'[v:searchforward].'zzzv'", { expr = true, desc = 'Prev Search Result' })
set({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
set({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Better window and buffer Navigation
set('n', '<M-s>', '<C-w>s', { nowait = true, noremap = true })
set('n', '<M-v>', '<C-w>v', { nowait = true, noremap = true })
set('n', '<M-q>', '<C-w>q', { nowait = true, noremap = true })
set('n', '<M-x>', '<C-w>x', { nowait = true, noremap = true })
set('n', '<M-o>', '<C-w>o', { nowait = true, noremap = true })
-- set('n', '<M-h>', '<C-w>h', { nowait = true, noremap = true })
-- set('n', '<M-j>', '<C-w>j', { nowait = true, noremap = true })
-- set('n', '<M-k>', '<C-w>k', { nowait = true, noremap = true })
-- set('n', '<M-l>', '<C-w>l', { nowait = true, noremap = true })
set('n', '<M-p>', '<cmd>bp<cr>', { noremap = true, nowait = true })
set('n', '<M-n>', '<cmd>bn<cr>', { noremap = true, nowait = true })
set('n', '<M-N>', '<cmd>enew<cr>', { nowait = true, noremap = true })

-- Resize with arrows
set('n', '<C-Up>', '<Cmd>resize -2<CR>', { noremap = true })
set('n', '<C-Down>', '<Cmd>resize +2<CR>', { noremap = true })
set('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', { noremap = true })
set('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', { noremap = true })

-- Restart nvim
set('n', '<leader>Er', '<cmd>restart<CR>', { noremap = true, desc = 'Restart' })

-- Map to toggle or open the undo tree panel
set('n', '<leader>u', '<cmd>Undotree<CR>', { desc = 'Toggle Undo Tree' })

-- Better yank and paste idea from reddit: (https://www.reddit.com/r/neovim/comments/1t9fjw4/comment/ol919sv/)
local function clip_or_reg(op)
    return function()
        local reg = vim.v.register
        if reg == '' or reg == '"' then
            return '"+' .. op
        end
        return '"' .. reg .. op
    end
end
set('n', 'y', clip_or_reg 'y', { expr = true })
set('n', 'p', clip_or_reg 'p', { expr = true })

-- Delete to void in normal and visual mode
set({ 'n', 'v', 'x' }, 'd', '"_d')

-- When pasting over selected text, replace it and do not copy it to the yank register.
set('v', 'p', [["_dp]])
set('n', 'd', [["_d]])

-- Remap signature help to M-k as C-k is taken by kitty and nvim window nav.
set('n', '<C-k>', vim.lsp.buf.signature_help, { nowait = true, noremap = true, desc = 'LSP Signature' })

-- Diagnostic Keymaps
set('n', '[d', function()
    vim.diagnostic.jump { count = -1 }
end, { desc = 'Previous diagnostic' })

set('n', ']d', function()
    vim.diagnostic.jump { count = 1 }
end, { desc = 'Next diagnostic ' })

set('n', '<leader>d', function()
    vim.diagnostic.open_float { scope = 'cursor', source = 'if_many' }
end, { desc = 'Open diagnostic' })

-- Make current file executable.
set('n', '<leader>cx', '<cmd>!chmod +x %<CR>', { desc = 'Make current file executable' })
