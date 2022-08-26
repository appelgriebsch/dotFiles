vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

require("settings.autocmds")
require("settings.global")
require("settings.keymaps")
require("plugins")
