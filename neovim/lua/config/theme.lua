-- Enable true color support
vim.opt.termguicolors = true

-- Editor theme
vim.opt.background = "dark"

-- setup Github Dimmed Theme
require('github-theme').setup({
	themeStyle = "dimmed",
	keywordStyle = "NONE",
	functionStyle = "NONE",
	variableStyle = "NONE",
	darkFloat = true,
	colors = { bg_statusline = "#22272e" }     -- set statusline background to match theme background
})