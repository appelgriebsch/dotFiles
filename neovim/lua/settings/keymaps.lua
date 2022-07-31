local function global_keymap(desc) return { silent = true, desc = desc } end

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Y yank until the end of line
vim.keymap.set("n", "Y", "y$", global_keymap("Yank full line"))
vim.keymap.set("v", "p", "\"_dP", global_keymap("Paste from clipboard"))

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", global_keymap("Switch to lefthand window"))
vim.keymap.set("n", "<C-j>", "<C-w>j", global_keymap("Switch to window below"))
vim.keymap.set("n", "<C-k>", "<C-w>k", global_keymap("Switch to window above"))
vim.keymap.set("n", "<C-l>", "<C-w>l", global_keymap("Switch to righthand window"))

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "0", "v:count == 0 ? \"g0\" : \"0\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "$", "v:count == 0 ? \"g$\" : \"$\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })

-- Buffers, Files, ...
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", global_keymap("Switch to next buffer"))
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", global_keymap("Switch to previous buffer"))

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

-- If you use <Space> as your mapping prefix, then this will make the key-menu
-- popup appear in Normal mode, after you press <Space>, after timeoutlen.
menu.set("n", "<Space>")
menu.set("n", "g")
