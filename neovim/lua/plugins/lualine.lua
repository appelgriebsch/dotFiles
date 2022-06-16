local status_statusline, lualine = pcall(require, "lualine")
if not status_statusline then
  return
end

local function clock()
  return " " .. os.date("%H:%M")
end

require("nvim-web-devicons").setup({ default = true })

lualine.setup({
  options = {
    globalstatus = true,
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
})
