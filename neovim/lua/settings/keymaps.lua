local keymap = require("utils.keymaps")

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Y yank until the end of line
vim.keymap.set("n", "Y", "y$", keymap.map_global("Yank full line"))
vim.keymap.set("v", "p", "\"_dP", keymap.map_global("Paste from clipboard"))

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", keymap.map_global("Switch to lefthand window"))
vim.keymap.set("n", "<C-j>", "<C-w>j", keymap.map_global("Switch to window below"))
vim.keymap.set("n", "<C-k>", "<C-w>k", keymap.map_global("Switch to window above"))
vim.keymap.set("n", "<C-l>", "<C-w>l", keymap.map_global("Switch to righthand window"))

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "0", "v:count == 0 ? \"g0\" : \"0\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "$", "v:count == 0 ? \"g$\" : \"$\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })

-- Buffers, Files, ...
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", keymap.map_global("Switch to next buffer"))
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", keymap.map_global("Switch to previous buffer"))

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

-- If you use <Space> as your mapping prefix, then this will make the key-menu
-- popup appear in Normal mode, after you press <Space>, after timeoutlen.
menu.set("n", "<Space>")
menu.set("n", "g")
