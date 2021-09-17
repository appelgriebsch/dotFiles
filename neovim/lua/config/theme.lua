-- Enable true color support
vim.opt.termguicolors = true

-- Editor theme
vim.opt.background = "dark"

-- setup Github Dimmed Theme
require('github-theme').setup({
  theme_style = "dimmed",
  keyword_style = "NONE",
  function_style = "NONE",
  variable_style = "NONE",
  dark_float = true,
})

vim.g.colorscheme = "github_dimmed"