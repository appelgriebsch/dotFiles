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
    },
    dash = {
      search_engine = 'ddg',
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      },
    },
    command_palette = {
      {"File",
        { "projects", ":lua require('telescope').extensions.project.project{}", 1 },
        { "find",     ":lua require('telescope.builtin').find_files()", 1 },
        { "git", ":lua require('telescope.builtin').git_files()", 1 },
        { "browser", ":lua require('telescope').extensions.file_browser.file_browser()", 1 },
        { "grep", ":lua require('telescope.builtin').live_grep()", 1 },
        { "quit", ':qa' },
      },
      {"Buffers",
        { "buffers", ":lua require('telescope.builtin').buffers()", 1 },
        { "marks", ":lua require('telescope.builtin').marks()", 1 },
        { "save current", ':w' },
        { "save all", ':wa' },
        { "close current", ":lua require('close_buffers').delete({type = 'this'})" },
        { "close others", ":lua require('close_buffers').delete({type = 'other'})" },
      },
      {"LSP",
        { "buffer diagnostics", ":lua require('telescope.builtin').diagnostics({bufno=0})" },
        { "buffer symbols", ":lua require('telescope.builtin').lsp_document_symbols()" },
        { "workspace diagnostics", ":lua require('telescope.builtin').diagnostics()" },
        { "workspace symbols", ":lua require('telescope.builtin').lsp_workspace_symbols()" },
      },
    }
  }
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("notify")
require("telescope").load_extension("project")
require("telescope").load_extension("command_palette")
require("telescope").load_extension("gh")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("dap")

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space><space>', ':Telescope command_palette<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>fb', ':Telescope file_browser<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>fd', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>fh', ':Telescope oldfiles<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>fs', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>fg', ':Telescope git_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>bb', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>bm', ':Telescope marks<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>ds', ':Dash<CR>', {noremap = true, silent = true})

-- LSP
vim.api.nvim_set_keymap('n', '<leader>dw', ':Telescope diagnostics<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':Telescope diagnostics bufno=0<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>sw', ':Telescope lsp_workspace_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>sb', ':Telescope lsp_document_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ca', ':lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>cd', ':DashWord<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gd', ':Telescope lsp_definitions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gD', ':Telescope lsp_declarations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gi', ':Telescope lsp_implementations<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gt', ':Telescope lsp_typedefs<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gr', ':Telescope lsp_references<CR>', {noremap = true, silent = true})
