-- Rust specific vim keybindings

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

local function local_keymap(desc) return { silent = true, buffer = true, desc = desc } end

vim.keymap.set("n", "<leader>ra", "<CMD>RustHoverActions<CR>", local_keymap("Actions"))
menu.set("n", "<leader>r", { desc = "Rust" })
