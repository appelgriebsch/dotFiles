local o = vim.opt
local g = vim.g

-- Remap , as leader key
g.mapleader = ","
g.maplocalleader = ","

-- don't show last command
o.showcmd = false

-- Yank and paste with the system clipboard
o.clipboard = 'unnamedplus'

-- Hides buffers instead of closing them
o.hidden = true

-- Insert spaces when TAB is pressed.
o.expandtab = true

-- Change number of spaces that a <Tab> counts for during editing ops
o.softtabstop = 2
o.tabstop = 2

-- Indentation amount for < and > commands.
o.shiftwidth = 2

-- do wrap long lines by default at margin 80
o.wrap = true

-- Don't highlight current cursor line
o.cursorline = false

-- Disable line/column number in status line
o.ruler = false

-- Only one line for command line
o.cmdheight = 1

-- Set preview window to appear at bottom
o.splitbelow = true

-- Don't dispay mode in command line
o.showmode = false

-- ignore case when searching
o.ignorecase = true

-- if the search string has an upper case letter in it, the search will be case sensitive
o.smartcase = true

-- Automatically re-read file if a change was detected outside of vim
o.autoread = true

-- Enable relative line numbers
o.number = true
o.relativenumber = true

--Decrease update time
o.updatetime = 250

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
o.signcolumn = "yes"

-- Save undo history
o.undolevels = 1000
o.undofile = false

-- Don't put backups in current dir
o.backup = false
o.writebackup = false
o.backupdir = "~/.local/share/nvim/backup"

-- default to utf-8
o.encoding = 'UTF-8'
o.fileencoding = 'UTF-8'

--  showing special non-printable chars
o.listchars = { tab = ">>>", trail = "·", precedes = "←", extends = "→",eol = "↲", nbsp = "␣" }

-- Incremental live completion
o.inccommand = "nosplit"

-- Set completeopt to have a better completion experience
o.completeopt = { 'menu', 'menuone', 'noselect' }
g.completion_enable_auto_signature = 0
g.completion_matching_strategy_list = { 'fuzzy', 'substring', 'exact' }

-- Don't give completion messages like 'match 1 of 2'
-- or 'The only match'
o.shortmess:append { c = true }

--Set highlight on search
o.hlsearch = false
o.incsearch = true

-- Enable mouse mode
o.mouse = "a"

-- searching for project root directory
g.rooter_pattern = {'.git', 'node_modules', 'src', 'Makefile', 'cargo.toml', 'package.json', 'pom.xml'}
g.outermost_root = true

-- configure code actions menu
g.code_action_menu_show_details = false
g.code_action_menu_show_diff = false

-- Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap=true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", {noremap= true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', '0', "v:count == 0 ? 'g0' : '0'", {noremap= true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', '$', "v:count == 0 ? 'g$' : '$'", {noremap= true, expr = true, silent = true})

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true})

-- buffer navigation
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>q', ':BDelete! this<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true})
