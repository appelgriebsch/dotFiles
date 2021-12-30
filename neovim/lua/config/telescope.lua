require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        preview_cutoff = 0.2,
        preview_height = 0.4
      },
      height = 0.9,
      width = 0.9
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    file_browser = {
      theme = "ivy"
    }
  }
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require("telescope").load_extension('file_browser')
require('telescope').load_extension('notify')

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space><space>', ':Telescope builtin<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>r', '<cmd>lua require \'telescope\'.extensions.file_browser.file_browser()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>f', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>h', ':Telescope oldfiles<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>s', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>b', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>g', ':Telescope git_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>m', ':Telescope marks<CR>', {noremap = true, silent = true})

-- LSP
vim.api.nvim_set_keymap('n', '<leader>dw', ':Telescope lsp_workspace_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':Telescope lsp_document_diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>sd', ':Telescope lsp_document_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>sw', ':Telescope lsp_workspace_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ca', ':CodeActionMenu<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gd', ':Telescope lsp_definitions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gD', ':Telescope lsp_declarations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gi', ':Telescope lsp_implementations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gt', ':Telescope lsp_typedefs<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gr', ':Telescope lsp_references<CR>', {noremap = true, silent = true})
