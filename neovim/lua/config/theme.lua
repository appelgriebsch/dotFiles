-- Enable true color support
vim.opt.termguicolors = true

-- Editor theme
vim.opt.background = "dark"

-- setup Github Dimmed Theme
require('github-theme').setup({
	themeStyle = "dimmed",
	keywordStyle = "NONE",
	functionStyle = "NONE",
	variableStyle = "NONE"
})