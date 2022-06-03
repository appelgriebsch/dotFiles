-- Editor theme
vim.opt.background = "dark"

local onedarkpro = require("onedarkpro")
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
