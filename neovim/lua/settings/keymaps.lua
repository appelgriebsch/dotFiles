local opts = { noremap = true, silent = true }
local opts_exp = { noremap = true, expr = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap , as leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Y yank until the end of line
keymap('n', 'Y', 'y$', opts)
keymap("v", "p", '"_dP', opts)

-- buffer navigation
keymap('n', '<Tab>', ':bnext<CR>', opts)
keymap('n', '<S-Tab>', ':bprevious<CR>', opts)
keymap('n', '<leader>q', ':Bdelete!<CR>', opts)

-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", opts_exp)
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", opts_exp)
keymap('n', '0', "v:count == 0 ? 'g0' : '0'", opts_exp)
keymap('n', '$', "v:count == 0 ? 'g$' : '$'", opts_exp)

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)
