require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    lsp_handlers = {
      code_action = {
        telescope = require('telescope.themes').get_dropdown({}),
      },
    },
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require('telescope').load_extension('lsp_handlers')

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space>f', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>h', ':Telescope oldfiles<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>s', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>b', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>g', ':Telescope git_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>m', ':Telescope marks<CR>', {noremap = true, silent = true})

-- LSP
vim.api.nvim_set_keymap('n', '<space>d', ':Telescope lsp_workspace_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>D', ':Telescope lsp_document_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>o', ':Telescope lsp_document_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>w', ':Telescope lsp_workspace_symbols<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>a', ':Telescope lsp_code_actions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>d', ':Telescope lsp_definitions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>D', ':Telescope lsp_declarations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>i', ':Telescope lsp_implementations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':Telescope lsp_typedefs<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':Telescope lsp_references<CR>', {noremap = true, silent = true})
