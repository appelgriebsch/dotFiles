local status_telescope, telescope = pcall(require, "telescope")
if not status_telescope then
  return
end

local status_cc, command_center = pcall(require, "command_center")
if not status_cc then
  return
end

local actions = require("telescope.actions")
local noremap = { noremap = true }
local silent_noremap = { noremap = true, silent = true }

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        preview_cutoff = 0.2,
        preview_height = 0.4
      },
      height = 0.9,
      width = 0.9
    },
    mappings = {
      i = {
        ["<CR>"] = actions.select_default,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-h>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<S-k>"] = actions.preview_scrolling_up,
        ["<S-j>"] = actions.preview_scrolling_down,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-h>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<S-k>"] = actions.preview_scrolling_up,
        ["<S-j>"] = actions.preview_scrolling_down,
      }
    }
  },
  extensions = {
    project = {
      base_dirs = {
        "~/Projects",
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
      hijack_netrw = true,
      theme = "ivy"
    },
    dash = {
      search_engine = "ddg",
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
telescope.load_extension("command_center")
telescope.load_extension("dap")
telescope.load_extension("file_browser")
telescope.load_extension("fzf")
telescope.load_extension("gh")
telescope.load_extension("notify")
telescope.load_extension("project")
telescope.load_extension("termfinder")
telescope.load_extension("yaml_schema")

-- Buffers, Files, ...
vim.api.nvim_set_keymap("n", "<space><space>", ":Telescope command_center<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>f", ":Telescope command_center category=file<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>b", ":Telescope command_center category=buffer<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>l", ":Telescope command_center category=lsp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>w", ":Telescope command_center category=workspace<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>d", ":Telescope command_center category=dap<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>h", ":Telescope command_center category=help<CR>", { noremap = true, silent = true })

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
    cmd = "<CMD>Bdelete!<CR>",
    keybindings = { "n", "<space>bc", silent_noremap },
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
})

local status_ok, dressing = pcall(require, "dressing")
if status_ok then
  dressing.setup({
    input = {
      override = function(conf)
        -- The default is 50. Try bumping it up until it's on top
        -- See :help nvim_open_win for details on zindex
        conf.zindex = 100
      end
    }
  })
end
