local o = vim.opt
local g = vim.g

-- Enable true color support
o.termguicolors = true

-- Editor theme
o.background = "dark"
g.ayu_mirage = true
vim.cmd[[colorscheme ayu]]
