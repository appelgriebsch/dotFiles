require('fzf_lsp').setup()

-- size of the floating window
vim.cmd([[ let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } } ]])
vim.cmd([[ let g:fzf_lsp_layout = { 'window': { 'width': 0.8, 'height': 0.8 } } ]])

-- fzf colors matching theme
vim.cmd([[ let g:fzf_colors = { 'fg':    ['fg', 'Normal'], 'bg':      ['bg', 'Normal'], 'hl':      ['fg', 'Comment'], 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'], 'bg+':     ['bg', 'CursorLine', 'CursorColumn'], 'hl+':     ['fg', 'Statement'], 'info':    ['fg', 'PreProc'], 'border':  ['fg', 'Ignore'], 'prompt':  ['fg', 'Conditional'], 'pointer': ['fg', 'Exception'], 'marker':  ['fg', 'Keyword'], 'spinner': ['fg', 'Label'], 'header':  ['fg', 'Comment'] } ]])

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space>f', ':Files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>b', ':Buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>s', ':Rg<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>g', ':GFiles<CR>', {noremap = true, silent = true})

-- LSP
vim.api.nvim_set_keymap('n', '<space>d', ':DiagnosticsAll<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>D', ':Diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>o', ':DocumentSymbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>w', ':WorkspaceSymbols<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<space>a', ':CodeActions<CR>', {noremap = true, silent = true})
