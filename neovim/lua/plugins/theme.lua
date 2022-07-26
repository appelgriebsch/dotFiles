-- Editor theme
vim.opt.background = "dark"

local status_theme, onedarkpro = pcall(require, "onedarkpro")
if not status_theme then
  return
end

onedarkpro.setup({
  theme = "onedark_vivid",
  styles = {
    strings = "NONE", -- Style that is applied to strings
    comments = "NONE", -- Style that is applied to comments
    keywords = "NONE", -- Style that is applied to keywords
    functions = "NONE", -- Style that is applied to functions
    variables = "NONE", -- Style that is applied to variables
  },
  options = {
    bold = false, -- Use the themes opinionated bold styles?
    terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
    cursorline = false, -- Use cursorline highlighting?
  }
})
onedarkpro.load()
