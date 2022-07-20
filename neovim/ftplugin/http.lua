-- http / rest specific vim keybindings

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

local function local_keymap(desc) return { silent = true, buffer = true, desc = desc } end

vim.keymap.set("n", "<leader>he", "<Plug>RestNvim<CR>", local_keymap("Execute request"))
vim.keymap.set("n", "<leader>hp", "<Plug>RestNvimPreview<CR>", local_keymap("Preview cUrl command"))
vim.keymap.set("n", "<leader>hl", "<Plug>RestNvimLast<CR>", local_keymap("Rerun last request"))

menu.set("n", "<leader>h", { desc = "Http" })
