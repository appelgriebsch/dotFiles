require'fzf-lua'.setup {
  winopts = {
    win_height       = 0.80,            -- window height
    win_width        = 0.80,            -- window width
    win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    hl_normal        = 'Normal',        -- window normal color
    hl_border        = 'FloatBorder',   -- window border color
  },
  default_previewer   = "bat",
  previewers = {
    bat = {
      cmd             = "bat",
      args            = "--style=numbers,changes --color always",
      theme           = 'OneHalfDark', -- bat preview theme (bat --list-themes)
      config          = nil,            -- nil uses $BAT_CONFIG_PATH
    }
  },
  files = {
    previewer         = "bat"
  }
}

-- fzf colors matching theme
vim.cmd([[ let g:fzf_colors = { 'fg':    ['fg', 'Normal'], 'bg':      ['bg', 'Normal'], 'hl':      ['fg', 'Comment'], 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'], 'bg+':     ['bg', 'CursorLine', 'CursorColumn'], 'hl+':     ['fg', 'Statement'], 'info':    ['fg', 'PreProc'], 'border':  ['fg', 'Ignore'], 'prompt':  ['fg', 'Conditional'], 'pointer': ['fg', 'Exception'], 'marker':  ['fg', 'Keyword'], 'spinner': ['fg', 'Label'], 'header':  ['fg', 'Comment'] } ]])

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space>f', ':FzfLua files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>b', ':FzfLua buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>s', ':FzfLua grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>g', ':FzfLua git_files<CR>', {noremap = true, silent = true})

-- LSP
vim.api.nvim_set_keymap('n', '<space>d', ':FzfLua lsp_workspace_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>D', ':FzfLua lsp_document_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>o', ':FzfLua lsp_document_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>w', ':FzfLua lsp_live_workspace_symbols<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>a', ':FzfLua lsp_code_actions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>d', ':FzfLua lsp_definitions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>D', ':FzfLua lsp_declarations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>i', ':FzfLua lsp_implementations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':FzfLua lsp_typedefs<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':FzfLua lsp_references<CR>', {noremap = true, silent = true})
