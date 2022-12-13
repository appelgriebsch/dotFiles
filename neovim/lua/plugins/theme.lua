require("nvim-web-devicons").setup({ default = true })

-- Editor theme
vim.opt.background = "dark"

local status_theme, theme = pcall(require, "onedarkpro")
if not status_theme then
  return
end

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_floating_blur = 0
  vim.g.neovide_floating_opacity = 90
end

vim.cmd("colorscheme onedark")

theme.setup()
