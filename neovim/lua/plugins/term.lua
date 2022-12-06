local status_term, toggleterm = pcall(require, "toggleterm")
if not status_term then
  return
end

toggleterm.setup({
  open_mapping = [[<c-]>]],
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
  vim.keymap.set("t", "<C-\\><C-N>", "<C-\\><C-N><CMD>ToggleTerm<CR>")
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

local status_menu, menu = pcall(require, "which-key")
if not status_menu then
  return
end

menu.register({
  ["<leader>ut"] = {
    name = "+terminal",
    f = { "<CMD>ToggleTerm direction=float<CR>", "floating" },
    h = { "<CMD>ToggleTerm direction=horizontal<CR>", "horizontal" },
    s = { "<CMD>Telescope termfinder theme=dropdown<CR>", "search" },
    v = { "<CMD>ToggleTerm direction=vertical<CR>", "vertical" }
  }
})

if vim.fn.executable("gitui") == 1 then
  menu.register({
    ["<leader>ug"] = { "<CMD>lua _GITUI_TOGGLE()<CR>", "gitui" }
  })
end

if vim.fn.executable("btop") == 1 then
  menu.register({
    ["<leader>ub"] = { "<CMD>lua _BTOP_TOGGLE()<CR>", "btop" }
  })
end
