local command_center = require("command_center")
local noremap = { noremap = true }
local silent_noremap = { noremap = true, silent = true }

command_center.add({
  {
    description = "Files: Find",
    command = "Telescope find_files",
    keybindings = { "n", "<space>ff", noremap },
  },
  {
    description = "Files: Open project",
    command = "Telescope project display_type=full",
    keybindings = { "n", "<space>fp", silent_noremap },
  },
  {
    description = "Files: Open browser",
    command = "Telescope file_browser",
    keybindings = { "n", "<space>fb", silent_noremap },
  },
  {
    description = "Files: Grep",
    command = "Telescope live_grep",
    keybindings = { "n", "<space>fs", silent_noremap },
  },
  {
    description = "Files: Recent",
    command = "Telescope oldfiles",
    keybindings = { "n", "<space>fh", silent_noremap },
  },
  {
    description = "Files: Git",
    command = "Telescope git_files",
    keybindings = { "n", "<space>fg", noremap },
  },
  {
    description = "Buffers: Find",
    command = "Telescope buffers",
    keybindings = { "n", "<space>bf", silent_noremap },
  },
  {
    description = "Buffers: Bookmarks",
    command = "Telescope marks",
    keybindings = { "n", "<space>bb", silent_noremap },
  },
  {
    description = "Buffers: Diagnostics",
    command = "Telescope diagnostics bufno=0",
    keybindings = { "n", "<space>bd", silent_noremap },
  },
  {
    description = "Buffers: Symbols",
    command = "Telescope lsp_document_symbols",
    keybindings = { "n", "<space>bs", silent_noremap },
  },
  {
    description = "Buffers: Close current",
    command = "lua require('close_buffers').delete({type = 'this'})",
    keybindings = { "n", "<space>bc", silent_noremap },
  },
  {
    description = "Buffers: Close others",
    command = "lua require('close_buffers').delete({type = 'other'})",
    keybindings = { "n", "<space>bo", silent_noremap },
  },
  {
    description = "Workspace: Diagnostics",
    command = "Telescope diagnostics",
    keybindings = { "n", "<space>wd", silent_noremap },
  },
  {
    description = "Workspace: Symbols",
    command = ":Telescope lsp_workspace_symbols",
    keybindings = { "n", "<space>ws", silent_noremap },
  },
  {
    description = "LSP: Code Actions",
    command = "lua vim.lsp.buf.code_action()",
    keybindings = { "n", "<leader>ca", silent_noremap },
  },
  {
    description = "LSP: Goto definition",
    command = "Telescope lsp_definitions",
    keybindings = { "n", "<leader>gd", silent_noremap },
  },
  {
    description = "LSP: Goto declaration",
    command = "Telescope lsp_declarations",
    keybindings = { "n", "<leader>gD", silent_noremap },
  },
  {
    description = "LSP: Goto references",
    command = "Telescope lsp_references",
    keybindings = { "n", "<leader>gr", silent_noremap },
  },
  {
    description = "LSP: Goto implementations",
    command = "Telescope lsp_implementations",
    keybindings = { "n", "<leader>gi", silent_noremap },
  },
  {
    description = "LSP: Goto type definition",
    command = "Telescope lsp_typedefs",
    keybindings = { "n", "<leader>gt", silent_noremap },
  },
  {
    description = "DAP: Pause",
    command = "lua require'dap'.pause()",
    keybindings = { "n", "<space>dp", silent_noremap },
  },
  {
    description = "DAP: Step into",
    command = "lua require'dap'.step_into()",
    keybindings = { "n", "<space>dsi", silent_noremap },
  },
  {
    description = "DAP: Step back",
    command = "lua require'dap'.step_back()",
    keybindings = { "n", "<space>dsb", silent_noremap },
  },
  {
    description = "DAP: Step over",
    command = "lua require'dap'.step_over()",
    keybindings = { "n", "<space>dso", silent_noremap },
  },
  {
    description = "DAP: Step out",
    command = "lua require'dap'.step_out()",
    keybindings = { "n", "<space>dsu", silent_noremap },
  },
  {
    description = "DAP: Commands",
    command = "lua require'telescope'.extensions.dap.commands{}",
    keybindings = { "n", "<space>dc", silent_noremap },
  },
  {
    description = "DAP: Run configurations",
    command = "lua require'telescope'.extensions.dap.configurations{}",
    keybindings = { "n", "<space>dr", silent_noremap },
  },
  {
    description = "DAP: Variables",
    command = "lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)",
    keybindings = { "n", "<space>dv", silent_noremap },
  },
  {
    description = "DAP: Frames",
    command = "lua require'telescope'.extensions.dap.frames{}",
    keybindings = { "n", "<space>df", silent_noremap },
  },
  {
    description = "DAP: Expression",
    command = "lua require('dap.ui.widgets').hover(require('dap.ui.widgets').expression)",
    keybindings = { "n", "<space>de", silent_noremap },
  },
  {
    description = "DAP: Run to cursor",
    command = "lua require'dap'.run_to_cursor()",
    keybindings = { "n", "<space>dgc", silent_noremap },
  },
  {
    description = "DAP: Continue",
    command = "lua require'dap'.run_to_cursor()",
    keybindings = { "n", "<space>dgr", silent_noremap },
  },
  {
    description = "DAP: Clear breakpoints",
    command = "lua require('dap.breakpoints').clear()",
    keybindings = { "n", "<space>dbc", silent_noremap },
  },
  {
    description = "DAP: Breakpoints",
    command = "lua require'telescope'.extensions.dap.list_breakpoints{}",
    keybindings = { "n", "<space>db", silent_noremap },
  },
  {
    description = "DAP: Toggle breakpoint",
    command = "lua require'dap'.toggle_breakpoint()",
    keybindings = { "n", "<space>dtb", silent_noremap },
  },
  {
    description = "DAP: Toggle conditional breakpoint",
    command = "lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))",
    keybindings = { "n", "<space>dtc", silent_noremap },
  },
  {
    description = "DAP: Toggle logpoint",
    command = "lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))",
    keybindings = { "n", "<space>dtl", silent_noremap },
  },
  {
    description = "Dash: Search word",
    command = "DashWord",
  },
  {
    description = "Dash: Search",
    command = "Dash",
  },
  -- TODO: add to file type specific section if available
  {
    description = "Java: Execute test suite",
    command = "lua require('jdtls').test_class()",
  },
  {
    description = "Java: Execute test method",
    command = "lua require('jdtls').test_nearest_method()",
  },
  {
    description = "Java: Update project configurations",
    command = "lua require('jdtls').update_project_config()",
  },
  {
    description = "Java: Organize imports",
    command = "lua require'jdtls'.organize_imports()",
  },
  {
    description = "Java: Refresh run configurations",
    command = "lua require('jdtls.dap').setup_dap_main_class_configs({ verbose = true })",
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
require("telescope").load_extension("luasnip")
require("telescope").load_extension("notify")
require("telescope").load_extension("project")
require("dressing").setup({})

-- Buffers, Files, ...
vim.api.nvim_set_keymap('n', '<space><space>', ':Telescope command_center<CR>', { noremap = true, silent = true })
