-- Editor theme
vim.opt.background = "dark"

local status_ok, onedarkpro = pcall(require, "onedarkpro")
if not status_ok then
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
})
onedarkpro.load()
