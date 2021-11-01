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

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space><space>', ':FzfLua builtin<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>f', ':FzfLua files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>h', ':FzfLua oldfiles<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>s', ':FzfLua live_grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>b', ':FzfLua buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>g', ':FzfLua git_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>m', ':FzfLua marks<CR>', {noremap = true, silent = true})

-- LSP
vim.api.nvim_set_keymap('n', '<leader>dw', ':FzfLua lsp_workspace_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':FzfLua lsp_document_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>sd', ':FzfLua lsp_document_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>sw', ':FzfLua lsp_live_workspace_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ca', ':CodeActionMenu<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gd', ':FzfLua lsp_definitions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gD', ':FzfLua lsp_declarations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gi', ':FzfLua lsp_implementations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gt', ':FzfLua lsp_typedefs<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gr', ':FzfLua lsp_references<CR>', {noremap = true, silent = true})
