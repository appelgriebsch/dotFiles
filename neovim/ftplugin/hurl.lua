local keymap = require("utils.keymaps")

if vim.fn.executable("hurl") ~= 1 then
  return
end

vim.keymap.set("n", "<leader>hr", "<CMD>enew | set filetype=HttpResult | 0r !hurl --variables-file=.env --include #<CR>", keymap.map_local("run via hurl"))
vim.keymap.set("n", "<leader>ht", "<CMD>enew | set filetype=HttpResult | 0r !hurl --variables-file=.env --test #<CR>", keymap.map_local("test via hurl"))

vim.cmd[[
  set filetype=http
]]
