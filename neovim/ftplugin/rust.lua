-- Rust specific vim keybindings

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>r", { desc = "Rust" })
