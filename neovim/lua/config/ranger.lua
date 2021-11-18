local o = vim.opt
local g = vim.g

-- Make Ranger replace Netrw and be the file explorer
g.rnvimr_ex_enable = true

-- Make Ranger to be hidden after picking a file
g.rnvimr_pick_enable = true
g.rnvimr_draw_border = true

-- Make Neovim wipe the buffers corresponding to the files deleted by Ranger
g.rnvimr_bw_enable = true

g.rnvimr_presets = {{
  width = 0.900,
  height = 0.900
}}

-- trigger with <space>r
vim.api.nvim_set_keymap('n', '<space>r', ':RnvimrToggle<CR>', {noremap = true, silent = true})
