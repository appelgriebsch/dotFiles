-- http / rest specific vim keybindings
local keymap = require("utils.keymaps")

vim.keymap.set("n", "<leader>he", "<Plug>RestNvim<CR>", keymap.map_local("execute request"))
vim.keymap.set("n", "<leader>hp", "<Plug>RestNvimPreview<CR>", keymap.map_local("preview cUrl command"))
vim.keymap.set("n", "<leader>hl", "<Plug>RestNvimLast<CR>", keymap.map_local("rerun last request"))

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>h", { desc = "http" })
