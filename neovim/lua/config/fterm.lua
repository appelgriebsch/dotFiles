require("FTerm").setup({
    dimensions  = {
        height = 0.8,
        width = 0.8
    },
    border = 'single' -- or 'double'
})

-- trigger with <space>t
vim.api.nvim_set_keymap('n', '<space>t', '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<space>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', {noremap = true, silent = true})

-- Remap escape to leave terminal mode
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
  augroup end
]], false)
