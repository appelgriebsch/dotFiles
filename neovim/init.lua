vim.defer_fn(function()
  local status_ok, impatient = pcall(require, "impatient")
  if not status_ok then
    return
  end
  impatient.enable_profile()
end, 0)

require("settings.autocmds")
require("settings.global")
require("settings.keymaps")
require("plugins")
