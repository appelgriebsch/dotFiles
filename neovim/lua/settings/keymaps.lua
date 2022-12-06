local function map_global(desc) return { silent = true, desc = desc } end

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Y yank until the end of line
vim.keymap.set("n", "Y", "y$", map_global("Yank full line"))
vim.keymap.set("v", "p", "\"_dP", map_global("Paste from clipboard"))

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", map_global("Switch to lefthand window"))
vim.keymap.set("n", "<C-j>", "<C-w>j", map_global("Switch to window below"))
vim.keymap.set("n", "<C-k>", "<C-w>k", map_global("Switch to window above"))
vim.keymap.set("n", "<C-l>", "<C-w>l", map_global("Switch to righthand window"))

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "0", "v:count == 0 ? \"g0\" : \"0\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })
vim.keymap.set("n", "$", "v:count == 0 ? \"g$\" : \"$\"", { noremap = true, expr = true, silent = true, desc = "HIDDEN" })

-- Buffers, Files, ...
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", map_global("Switch to next buffer"))
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", map_global("Switch to previous buffer"))
