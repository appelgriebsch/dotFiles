local function clock()
  return " " .. os.date("%H:%M")
end

local config = {
  options = {
    theme = "onedarkpro",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "diagnostics", sources = { "nvim_diagnostic" } }, "filename" },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { clock },
  },
  extensions = { "quickfix" },
}

require("nvim-web-devicons").setup({ default = true })
require('lualine').setup(config)
