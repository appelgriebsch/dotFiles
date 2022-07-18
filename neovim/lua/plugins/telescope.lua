local function global_keymap(desc) return { silent = true, desc = desc } end

local status_telescope, telescope = pcall(require, "telescope")
if not status_telescope then
  return
end

local actions = require("telescope.actions")

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
    --path_display = { shorten = { len = 1, exclude = {1, -1} } },
    path_display = { truncate = 3 },
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
      },
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
  }
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension("dap")
telescope.load_extension("file_browser")
telescope.load_extension("fzf")
telescope.load_extension("gh")
telescope.load_extension("notify")
telescope.load_extension("project")
telescope.load_extension("termfinder")
telescope.load_extension("yaml_schema")

local status_dressing, dressing = pcall(require, "dressing")
if status_dressing then
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

local status_vstask, vstask = pcall(require, "vstask")
if status_vstask then
  vstask.setup({
    terminal = "toggleterm",
    term_opts = {
      current = {
        direction = "float",
      },
    }
  })
end

-- Buffers
vim.keymap.set("n", "<leader>bf", "<CMD>Telescope buffers<CR>", global_keymap("Find Buffer"))
vim.keymap.set("n", "<leader>bb", "<CMD>Telescope marks<CR>", global_keymap("Show Bookmarks"))
vim.keymap.set("n", "<leader>bo", "<CMD>BDelete other<CR>", global_keymap("Close others"))
vim.keymap.set("n", "<leader>bq", "<CMD>BDelete! this<CR>", global_keymap("Force close"))
vim.keymap.set("n", "<leader>bw", "<CMD>w!<CR>", global_keymap("Force write"))
vim.keymap.set("n", "<leader>br", "<CMD>e!<CR>", global_keymap("Force reload"))

-- Workspaces / Files
vim.keymap.set("n", "<leader>pj", "<CMD>Telescope project display_type=full<CR>", global_keymap("Jump to Project"))
vim.keymap.set("n", "<leader>pts", "<CMD>lua require(\"telescope\").extensions.vstask.tasks()<CR>", global_keymap("Show Tasks"))
vim.keymap.set("n", "<leader>pti", "<CMD>lua require(\"telescope\").extensions.vstask.inputs()<CR>", global_keymap("Show Inputs"))

vim.keymap.set("n", "<leader>pff", "<CMD>Telescope find_files<CR>", global_keymap("Find File"))
vim.keymap.set("n", "<leader>pfb", "<CMD>Telescope file_browser<CR>", global_keymap("Open File Browser"))
vim.keymap.set("n", "<leader>pfr", "<CMD>Telescope oldfiles<CR>", global_keymap("Recent Files"))
vim.keymap.set("n", "<leader>pfg", "<CMD>Telescope git_files<CR>", global_keymap("Git Files"))
vim.keymap.set("n", "<leader>pfs", "<CMD>Telescope live_grep<CR>", global_keymap("Search in Files"))

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>b", { desc = "Buffer" })
menu.set("n", "<leader>p", { desc = "Project" })
menu.set("n", "<leader>pf", { desc = "Files" })
menu.set("n", "<leader>pt", { desc = "Tasks" })
