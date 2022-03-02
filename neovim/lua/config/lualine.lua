local function clock()
  return " " .. os.date("%H:%M")
end

vim.cmd([[autocmd User LspProgressUpdate let &ro = &ro]])

vim.api.nvim_exec([[
  autocmd ColorScheme * lua require("config.lualine").load();
]], false)

local config = {
  options = {
    theme = "github",
    icons_enabled = true,
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
