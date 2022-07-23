require("cheat-sheet").setup({
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

local function local_keymap(desc) return { silent = true, desc = desc } end

vim.keymap.set("n", "<leader>tc", "<CMD>CheatSH<CR>", local_keymap("Show Cheat Sheet"))
