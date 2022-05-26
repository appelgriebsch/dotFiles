local command_center = require("command_center")
local noremap = { noremap = true }
local silent_noremap = { noremap = true, silent = true }

command_center.add({
  {
    category = "file",
    description = "Files: Find",
    cmd = "<CMD>Telescope find_files<CR>",
    keybindings = { "n", "<space>ff", noremap },
  },
  {
    category = "file",
    description = "Files: Open project",
    cmd = "<CMD>Telescope project display_type=full<CR>",
    keybindings = { "n", "<space>fp", silent_noremap },
  },
  {
    category = "file",
    description = "Files: Open browser",
    cmd = "<CMD>Telescope file_browser<CR>",
    keybindings = { "n", "<space>fb", silent_noremap },
  },
  {
    category = "file",
    description = "Files: Grep",
    cmd = "<CMD>Telescope live_grep<CR>",
    keybindings = { "n", "<space>fs", silent_noremap },
  },
  {
    category = "file",
    description = "Files: Recent",
    cmd = "<CMD>Telescope oldfiles<CR>",
    keybindings = { "n", "<space>fh", silent_noremap },
  },
  {
    category = "file",
    description = "Files: Git",
    cmd = "<CMD>Telescope git_files<CR>",
    keybindings = { "n", "<space>fg", noremap },
  },
  {
    category = "buffer",
    description = "Buffers: Find",
    cmd = "<CMD>Telescope buffers<CR>",
    keybindings = { "n", "<space>bf", silent_noremap },
  },
  {
    category = "buffer",
    description = "Buffers: Bookmarks",
    cmd = "<CMD>Telescope marks<CR>",
    keybindings = { "n", "<space>bb", silent_noremap },
  },
  {
    category = "buffer",
    description = "Buffers: Diagnostics",
    cmd = "<CMD>Telescope diagnostics bufno=0<CR>",
    keybindings = { "n", "<space>bd", silent_noremap },
  },
  {
    category = "buffer",
    description = "Buffers: Symbols",
    cmd = "<CMD>Telescope lsp_document_symbols<CR>",
    keybindings = { "n", "<space>bs", silent_noremap },
  },
  {
    category = "buffer",
    description = "Buffers: Close current",
    cmd = "<CMD>lua require('close_buffers').delete({type = 'this'})<CR>",
    keybindings = { "n", "<space>bc", silent_noremap },
  },
  {
    category = "buffer",
    description = "Buffers: Close others",
    cmd = "<CMD>lua require('close_buffers').delete({type = 'other'})<CR>",
    keybindings = { "n", "<space>bo", silent_noremap },
  },
  {
    category = "workspace",
    description = "Workspace: Diagnostics",
    cmd = "<CMD>Telescope diagnostics<CR>",
    keybindings = { "n", "<space>wd", silent_noremap },
  },
  {
    category = "workspace",
    description = "Workspace: Symbols",
    cmd = "<CMD>Telescope lsp_workspace_symbols<CR>",
    keybindings = { "n", "<space>ws", silent_noremap },
  },
  {
    category = "lsp",
    description = "LSP: Code Actions",
    cmd = "<CMD>lua vim.lsp.buf.code_action()<CR>",
    keybindings = { "n", "<leader>ca", silent_noremap },
  },
  {
    category = "lsp",
    description = "LSP: Goto definition",
    cmd = "<CMD>Telescope lsp_definitions<CR>",
    keybindings = { "n", "<leader>gd", silent_noremap },
  },
  {
    category = "lsp",
    description = "LSP: Goto declaration",
    cmd = "<CMD>Telescope lsp_declarations<CR>",
    keybindings = { "n", "<leader>gD", silent_noremap },
  },
  {
    category = "lsp",
    description = "LSP: Goto references",
    cmd = "<CMD>Telescope lsp_references<CR>",
    keybindings = { "n", "<leader>gr", silent_noremap },
  },
  {
    category = "lsp",
    description = "LSP: Goto implementations",
    cmd = "<CMD>Telescope lsp_implementations<CR>",
    keybindings = { "n", "<leader>gi", silent_noremap },
  },
  {
    category = "lsp",
    description = "LSP: Goto type definition",
    cmd = "<CMD>Telescope lsp_typedefs<CR>",
    keybindings = { "n", "<leader>gt", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Pause",
    cmd = "<CMD>lua require'dap'.pause()<CR>",
    keybindings = { "n", "<space>dp", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Step into",
    cmd = "<CMD>lua require'dap'.step_into()<CR>",
    keybindings = { "n", "<space>dsi", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Step back",
    cmd = "<CMD>lua require'dap'.step_back()<CR>",
    keybindings = { "n", "<space>dsb", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Step over",
    cmd = "<CMD>lua require'dap'.step_over()<CR>",
    keybindings = { "n", "<space>dso", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Step out",
    cmd = "<CMD>lua require'dap'.step_out()<CR>",
    keybindings = { "n", "<space>dsu", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Commands",
    cmd = "<CMD>lua require'telescope'.extensions.dap.commands{}<CR>",
    keybindings = { "n", "<space>dc", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Run configurations",
    cmd = "<CMD>lua require'telescope'.extensions.dap.configurations{}<CR>",
    keybindings = { "n", "<space>dr", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Variables",
    cmd = "<CMD>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)<CR>",
    keybindings = { "n", "<space>dv", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Frames",
    cmd = "<CMD>lua require'telescope'.extensions.dap.frames{}<CR>",
    keybindings = { "n", "<space>df", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Expression",
    cmd = "<CMD>lua require('dap.ui.widgets').hover(require('dap.ui.widgets').expression)<CR>",
    keybindings = { "n", "<space>de", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Run to cursor",
    cmd = "<CMD>lua require'dap'.run_to_cursor()<CR>",
    keybindings = { "n", "<space>dgc", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Continue",
    cmd = "<CMD>lua require'dap'.run_to_cursor()<CR>",
    keybindings = { "n", "<space>dgr", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Clear breakpoints",
    cmd = "<CMD>lua require('dap.breakpoints').clear()<CR>",
    keybindings = { "n", "<space>dbc", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Breakpoints",
    cmd = "<CMD>lua require'telescope'.extensions.dap.list_breakpoints{}<CR>",
    keybindings = { "n", "<space>db", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Toggle breakpoint",
    cmd = "<CMD>lua require'dap'.toggle_breakpoint()<CR>",
    keybindings = { "n", "<space>dtb", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Toggle conditional breakpoint",
    cmd = "<CMD>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    keybindings = { "n", "<space>dtc", silent_noremap },
  },
  {
    category = "dap",
    description = "DAP: Toggle logpoint",
    cmd = "<CMD>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    keybindings = { "n", "<space>dtl", silent_noremap },
  },
  {
    category = "help",
    description = "Dash: Search word",
    cmd = "<CMD>DashWord<CR>",
  },
  {
    category = "help",
    description = "Dash: Search",
    cmd = "<CMD>Dash<CR>",
  },
  -- TODO: add to file type specific section if available
  {
    description = "Java: Execute test suite",
    cmd = "<CMD>lua require('jdtls').test_class()<CR>",
  },
  {
    description = "Java: Execute test method",
    cmd = "<CMD>lua require('jdtls').test_nearest_method()<CR>",
  },
  {
    description = "Java: Update project configurations",
    cmd = "<CMD>lua require('jdtls').update_project_config()<CR>",
  },
  {
    description = "Java: Organize imports",
    cmd = "<CMD>lua require'jdtls'.organize_imports()<CR>",
  },
  {
    description = "Java: Refresh run configurations",
    cmd = "<CMD>lua require('jdtls.dap').setup_dap_main_class_configs({ verbose = true })<CR>",
  },
})
require("telescope").setup({
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
    project = {
      base_dirs = {
        '~/Projects',
      }
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    file_browser = {
      theme = "ivy"
    },
    dash = {
      search_engine = 'ddg',
    },
    command_center = {
      components = {
        command_center.component.DESCRIPTION,
        command_center.component.KEYBINDINGS,
        -- command_center.component.COMMAND,
      },
      auto_replace_desc_with_cmd = false,
    }
  }
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension('command_center')
require("telescope").load_extension("dap")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("fzf")
require("telescope").load_extension("gh")
require("telescope").load_extension("notify")
require("telescope").load_extension("project")
require('telescope').load_extension("termfinder")
require("telescope").load_extension("yaml_schema")
require("dressing").setup({})

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space><space>', ':Telescope command_center<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>f', ':Telescope command_center category=file<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>b', ':Telescope command_center category=buffer<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>l', ':Telescope command_center category=lsp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>w', ':Telescope command_center category=workspace<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>d', ':Telescope command_center category=dap<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>h', ':Telescope command_center category=help<CR>', { noremap = true, silent = true })
