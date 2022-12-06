local status_statusline, lualine = pcall(require, "lualine")
if not status_statusline then
  return
end

local function clock()
  return " " .. os.date("%H:%M")
end

local lsp_config = require("plugins.lsp")

require("nvim-web-devicons").setup({ default = true })

lualine.setup({
  options = {
    globalstatus = true,
    theme = "onedark",
    disabled_filetypes = { "alpha" }
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { "branch" },
      {
        "diff",
        symbols = { added = " ", modified = "柳", removed = " " }, -- changes diff symbols
      },
    },
    lualine_c = {
      {
        "diagnostics",
        symbols = { error = " ", warn = " ", info = " ", hint = " " }
      },
      { "filename", padding = { left = 1, right = 1 } },
    },
    lualine_x = {
      {
        lsp_config.lsp_name,
        icon = "",
        color = { gui = "none" },
      },
      { "filetype", color = { gui = "none" }, padding = { left = 1, right = 1 }, separator = " " },
    },
    lualine_y = { "progress" },
    lualine_z = { clock },
  },
  extensions = { "quickfix", "toggleterm" },
})
