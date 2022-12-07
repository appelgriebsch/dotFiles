local status_telescope, telescope = pcall(require, "telescope")
if not status_telescope then
  return
end

local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")

local status_projections, projections = pcall(require, "projections")
if not status_projections then
  return
end

projections.setup({
  workspaces = { -- Default workspaces to search for
    -- { "~/Documents/dev", { ".git" } },     Documents/dev is a workspace. patterns = { ".git" }
    -- { "~/repos", {} },                     An empty pattern list indicates that all subfolders are considered projects
    -- "~/dev",                               dev is a workspace. default patterns is used (specified below)
    "~/Projects",
    "~/Projects/nodejs/",
    "~/Projects/rust/",
  },
  patterns = { ".git", ".svn", ".hg" }, -- Default patterns to use if none were specified. These are NOT regexps.
})

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
    path_display = { shorten = { len = 1, exclude = {1, -1} } },
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
        ["<C-s>"] = actions.complete_tag,
        ["<C-]>"] = "which_key",
        ["<C-p>"] = layout_actions.toggle_preview,
        ["<S-k>"] = actions.preview_scrolling_up,
        ["<S-j>"] = actions.preview_scrolling_down,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-h>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-]>"] = "which_key",
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<C-p>"] = layout_actions.toggle_preview,
        ["<S-k>"] = actions.preview_scrolling_up,
        ["<S-j>"] = actions.preview_scrolling_down,
      }
    }
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    file_browser = {
      hijack_netrw = true,
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
telescope.load_extension("projections")
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

local status_menu, menu = pcall(require, "which-key")
if not status_menu then
  return
end

menu.register({
  -- Buffers
  ["<leader>b"] = {
    name = "+buffers",
    c = { "<CMD>noh<CR>", "clear highlights" },
    f = { "<CMD>Telescope current_buffer_fuzzy_find<CR>", "find" },
    n = { "<CMD>ene <BAR> startinsert<CR>", "create new" },
    q = { "<CMD>Bdelete!<CR>", "close" },
    r = { "<CMD>e!<CR>", "reload" },
    s = { "<CMD>sp<CR>", "split horizontal"},
    v = { "<CMD>vs<CR>", "split vertical" },
    w = { "<CMD>w!<CR>", "write" }
  },
  -- Workspaces / Files
  ["<leader>f"] = {
    name = "+find",
    b = { "<CMD>Telescope buffers<CR>", "buffers" },
    e = { "<CMD>lua require(\"telescope\").extensions.file_browser.file_browser(ivy_opts({ grouped = true }))<CR>", "file explorer" },
    f = { "<CMD>Telescope find_files<CR>", "files" },
    m = { "<CMD>Telescope marks<CR>", "marks" },
    p = { "<CMD>Telescope projections<CR>", "projects" },
    r = { "<CMD>Telescope oldfiles<CR>", "recent files"},
    s = { "<CMD>Telescope live_grep<CR>", "search word"},
  },
  -- Git
  ["<leader>g"] = {
    name = "+git",
    b = {"<CMD>Telescope git_branches<CR>", "branches" },
    c = { "<CMD>Telescope git_commits<CR>", "commits"},
    C = { "<CMD>Telescope git_bcommits<CR>", "buffer commits" },
    f = { "<CMD>Telescope git_files<CR>", "files" },
  },
  -- Tabs
  ["<leader>t"] = {
    name = "+tabs",
    n = { "<CMD>tabnew<CR>", "create new" },
    h = { "<CMD>tabprevious<CR>", "previous" },
    l = { "<CMD>tabnext<CR>", "next" },
    q = { "<CMD>tabclose<CR>", "close" }
  },
  -- utils
  ["<leader>u"] = {
    name = "+utils",
    v = {
      name = "vstasks",
      h = { "<CMD>lua require(\"telescope\").extensions.vstask.history(require(\"telescope.themes\").get_dropdown())<CR>", "history" },
      i = { "<CMD>lua require(\"telescope\").extensions.vstask.inputs(require(\"telescope.themes\").get_dropdown())<CR>", "inputs" },
      r = { "<CMD>lua require(\"telescope\").extensions.vstask.launch(require(\"telescope.themes\").get_dropdown())<CR>", "run" },
      s = { "<CMD>lua require(\"telescope\").extensions.vstask.tasks(require(\"telescope.themes\").get_dropdown())<CR>", "show" }
    }
  }
})
