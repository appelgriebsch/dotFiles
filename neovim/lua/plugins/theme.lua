-- Editor theme
vim.opt.background = "dark"

local status_theme, theme = pcall(require, "github-theme")
if not status_theme then
  return
end

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_floating_blur = 0
  vim.g.neovide_floating_opacity = 90
end

theme.setup({
  theme_style = "dimmed",
  keyword_style = "NONE",
  function_style = "NONE",
  variable_style = "NONE",
  dark_float = true,
})
