-- Rust specific vim keybindings
local keymap = require("utils.keymaps")

-- TODO: rust specific key maps

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>tr", { desc = "rust" })
