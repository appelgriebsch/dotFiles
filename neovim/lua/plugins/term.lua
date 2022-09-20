local status_term, toggleterm = pcall(require, "toggleterm")
if not status_term then
  return
end

local keymap = require("utils.keymaps")

toggleterm.setup({
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  direction = "float",
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    width = function()
      return math.floor(vim.o.columns * 0.85)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.85)
    end,
    highlights = {
      border = "FloatBorder",
      background = "NormalFloat",
    },
    border = "curved",
    winblend = 3,
  },
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal

local gitui = Terminal:new({ cmd = "gitui", hidden = true })
function _GITUI_TOGGLE()
  gitui:toggle()
end

local btop = Terminal:new({ cmd = "btop", hidden = true })
function _BTOP_TOGGLE()
  btop:toggle()
end

vim.keymap.set("n", "<leader>utf", "<CMD>ToggleTerm direction=float<CR>", keymap.map_global("floating"))
vim.keymap.set("n", "<leader>uth", "<CMD>ToggleTerm direction=horizontal<CR>", keymap.map_global("horizontal"))
vim.keymap.set("n", "<leader>uts", "<CMD>Telescope termfinder<CR>", keymap.map_global("search"))
vim.keymap.set("n", "<leader>utv", "<CMD>ToggleTerm direction=vertical<CR>", keymap.map_global("vertical"))

vim.keymap.set("n", "<leader>ug", "<CMD>lua _GITUI_TOGGLE()<CR>", keymap.map_global("gitui"))
vim.keymap.set("n", "<leader>ub", "<CMD>lua _BTOP_TOGGLE()<CR>", keymap.map_global("btop"))

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>ut", { desc = "terminal" })
