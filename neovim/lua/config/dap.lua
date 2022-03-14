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

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.env.HOME .. '/.local/share/nvim/dap_adapters/node-debug2/out/src/nodeDebug.js' },
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}
