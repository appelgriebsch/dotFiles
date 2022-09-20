local status_cheat, cheatsheet = pcall(require, "cheat-sheet")
if not status_cheat then
  return
end

cheatsheet.setup({
  auto_fill = {
    filetype = true,
    current_word = true,
  },

  main_win = {
    style = "minimal",
    border = "rounded",
  },

  input_win = {
    style = "minimal",
    border = "rounded",
  },
})

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

local keymap = require("utils.keymaps")
vim.keymap.set("n", "<leader>uc", "<CMD>CheatSH<CR>", keymap.map_global("cheatsheet"))
