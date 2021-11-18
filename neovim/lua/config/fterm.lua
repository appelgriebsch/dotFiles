require("FTerm").setup({
  dimensions  = {
      height = 0.9,
      width = 0.9
  },
  border = 'single' -- or 'double'
})

local term = require("FTerm.terminal")
local gitui = term:new():setup({
  cmd = "gitui",
  dimensions  = {
      height = 0.9,
      width = 0.9
  },
  border = 'single' -- or 'double'
})

function _G.__fterm_gitui()
  gitui:toggle()
end

-- trigger default terminal with <space>t
vim.api.nvim_set_keymap('n', '<space>t', '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true, silent = true})

-- trigger gitui terminal with <space>G
vim.api.nvim_set_keymap('n', '<space>G', '<CMD>lua __fterm_gitui()<CR>', {noremap = true, silent = true})

-- Remap escape to leave terminal mode
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
  augroup end
]], false)

