require('fzf_lsp').setup()

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space>f', ':Files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>b', ':Buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>g', ':Rg<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>b', ':Bookmarks<CR>', {noremap = true, silent = true})

-- LSP
vim.api.nvim_set_keymap('n', '<space>d', ':DiagnosticsAll<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>D', ':Diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>o', ':DocumentSymbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>s', ':WorkspaceSymbols<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<space>a', ':CodeActions<CR>', {noremap = true, silent = true})
