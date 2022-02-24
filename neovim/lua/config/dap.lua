local dap = require('dap')
dap.defaults.fallback.terminal_win_cmd = '1split new'
require("nvim-dap-virtual-text").setup()

vim.fn.sign_define("DapBreakpoint", { text="", texthl="", linehl="", numhl="" })
vim.fn.sign_define("DapBreakpointCondition", { text="", texthl="", linehl="", numhl="" })
vim.fn.sign_define("DapLogPoint", { text="ﱴ", texthl="", linehl="", numhl="" })
vim.fn.sign_define("DapStopped", { text="", texthl="", linehl="", numhl="" })

vim.api.nvim_exec([[
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
]], false)
