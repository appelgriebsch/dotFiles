local status_telescope, telescope = pcall(require, "telescope")
if not status_telescope then
  return
end

local keymap = require("utils.keymaps")
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
vim.keymap.set("n", "<leader>bc", "<CMD>noh<CR>", keymap.map_global("clear highlights"))
vim.keymap.set("n", "<leader>bf", "<CMD>Telescope current_buffer_fuzzy_find<CR>", keymap.map_global("find"))
vim.keymap.set("n", "<leader>bn", "<CMD>ene <BAR> startinsert<CR>", keymap.map_global("create new"))
vim.keymap.set("n", "<leader>bq", "<CMD>Bdelete!<CR>", keymap.map_global("close"))
vim.keymap.set("n", "<leader>br", "<CMD>e!<CR>", keymap.map_global("reload"))
vim.keymap.set("n", "<leader>bR", "<CMD>lua require(\"resize-mode\").start()<CR>", keymap.map_global("resize"))
vim.keymap.set("n", "<leader>bs", "<CMD>vs<CR>", keymap.map_global("split vertical"))
vim.keymap.set("n", "<leader>bv", "<CMD>sp<CR>", keymap.map_global("split horizontal"))
vim.keymap.set("n", "<leader>bw", "<CMD>w!<CR>", keymap.map_global("write"))

-- Workspaces / Files
vim.keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>", keymap.map_global("buffer"))
vim.keymap.set("n", "<leader>fe", "<CMD>Telescope file_browser<CR>", keymap.map_global("file explorer"))
vim.keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>", keymap.map_global("file"))
vim.keymap.set("n", "<leader>fg", "<CMD>Telescope git_files<CR>", keymap.map_global("git file"))
vim.keymap.set("n", "<leader>fm", "<CMD>Telescope marks<CR>", keymap.map_global("bookmarks"))
vim.keymap.set("n", "<leader>fp", "<CMD>Telescope project display_type=full<CR>", keymap.map_global("project"))
vim.keymap.set("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>", keymap.map_global("recent files"))
vim.keymap.set("n", "<leader>fs", "<CMD>Telescope live_grep<CR>", keymap.map_global("search word"))

-- Git
vim.keymap.set("n", "<leader>gs", "<CMD>Telescope git_status<CR>", keymap.map_global("status"))
vim.keymap.set("n", "<leader>gc", "<CMD>Telescope git_commits<CR>", keymap.map_global("commit history"))
vim.keymap.set("n", "<leader>gC", "<CMD>Telescope git_bcommits<CR>", keymap.map_global("buffer commit history"))
vim.keymap.set("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", keymap.map_global("branches history"))

-- Tabs
vim.keymap.set("n", "<leader>tn", "<CMD>tabnew<CR>", keymap.map_global("create new"))
vim.keymap.set("n", "<leader>th", "<CMD>tabprevious<CR>", keymap.map_global("previous"))
vim.keymap.set("n", "<leader>tl", "<CMD>tabnext<CR>", keymap.map_global("next"))
vim.keymap.set("n", "<leader>tq", "<CMD>tabclose<CR>", keymap.map_global("close"))

-- Utils
vim.keymap.set("n", "<leader>uvh", "<CMD>lua require(\"telescope\").extensions.vstask.history()<CR>", keymap.map_global("history"))
vim.keymap.set("n", "<leader>uvi", "<CMD>lua require(\"telescope\").extensions.vstask.inputs()<CR>", keymap.map_global("inputs"))
vim.keymap.set("n", "<leader>uvr", "<CMD>lua require(\"telescope\").extensions.vstask.launch()<CR>", keymap.map_global("run"))
vim.keymap.set("n", "<leader>uvt", "<CMD>lua require(\"telescope\").extensions.vstask.tasks()<CR>", keymap.map_global("tasks"))

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>b", { desc = "buffer" })
menu.set("n", "<leader>f", { desc = "find" })
menu.set("n", "<leader>g", { desc = "git" })
menu.set("n", "<leader>t", { desc = "tabs" })
menu.set("n", "<leader>u", { desc = "utils" })
menu.set("n", "<leader>uv", { desc = "vstasks" })
