local opt = vim.opt
local g = vim.g

local options = {
  autoread = true,                         -- Automatically re-read file if a change was detected outside of vim
  backup = false,                          -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 1,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  cursorline = false,                      -- Don't highlight current cursor line
  encoding = 'UTF-8',                      -- default to utf-8
  expandtab = true,                        -- Insert spaces when TAB is pressed.
  fileencoding = 'UTF-8',                  -- default to utf-8
  guifont = 'FiraMono Nerd Font:h13',      -- gui font
  hidden = true,                           -- Hides buffers instead of closing them
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  inccommand = "nosplit",                  -- Incremental live completion
  incsearch = true,
  laststatus = 3,                          -- enable global status bar
  mouse = 'a',
  number = true,
  relativenumber = true,                   -- Enable relative line numbers
  ruler = false,                           -- Disable line/column number in status line
  shiftwidth = 2,                          -- Indentation amount for < and > commands.
  showcmd = false,                         -- don't show last command
  showmode = false,                        -- Don't dispay mode in command line
  signcolumn = "yes",                      -- Always show the signcolumn, otherwise it would shift the text each time
  smartindent = true,                      -- make indenting smarter again
  softtabstop = 2,
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  tabstop = 2,                             -- Change number of spaces that a <Tab> counts for during editing ops
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  undolevels = 1000,
  updatetime = 400,                        -- faster completion (4000ms default)
  wrap = true,                             -- do wrap long lines by default at margin 80
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

for k, v in pairs(options) do
  opt[k] = v
end

--  showing special non-printable chars
opt.listchars:append { tab = ">>>" }
opt.listchars:append { trail = "·" }
opt.listchars:append { space = "⋅" }
opt.listchars:append { precedes = "←" }
opt.listchars:append { extends = "→" }
opt.listchars:append { eol = "↲" }
opt.listchars:append { nbsp = "␣" }
opt.fillchars:append { eob = " " } -- hide tildes at the end of buffers
opt.fillchars:append { vert = " "} -- hide borders of split vertical windows (nvim tree)

g.completion_enable_auto_signature = 0
g.completion_matching_strategy_list = { 'fuzzy', 'substring', 'exact' }

-- disable some extension providers
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0

-- disable some builtin vim plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

function ivy_opts(opts)
  local result = require("telescope.themes").get_ivy({
    preview = {
      hide_on_startup = true
    },
    layout_config = { height = 0.4 }
  })
  if opts == nil then
    opts = {}
  end
  for k, v in pairs(opts) do
    result[k] = v
  end
  return result
end
