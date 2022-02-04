-- Editor theme
vim.opt.background = "dark"

-- setup Ayu Mirage Theme
require("ayu").setup({
  mirage = true -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
})

require("ayu").colorscheme()