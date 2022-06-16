local status_dap, dap = pcall(require, "dap")
if not status_dap then
  return
end

local silent_noremap = { noremap = true, silent = true }

dap.defaults.fallback.terminal_win_cmd = "enew"
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { vim.env.HOME .. "/.local/share/nvim/dap_adapters/node-debug2/out/src/nodeDebug.js" },
}
dap.configurations.javascript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}

require("nvim-dap-virtual-text").setup()

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

vim.api.nvim_exec([[
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
]], false)

local status_ok, command_center = pcall(require, "command_center")
if status_ok then
  command_center.add({
    {
      category = "dap",
      description = "DAP: Pause",
      cmd = "<CMD>lua require'dap'.pause()<CR>",
      keybindings = { "n", "<space>dp", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Step into",
      cmd = "<CMD>lua require'dap'.step_into()<CR>",
      keybindings = { "n", "<space>dsi", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Step back",
      cmd = "<CMD>lua require'dap'.step_back()<CR>",
      keybindings = { "n", "<space>dsb", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Step over",
      cmd = "<CMD>lua require'dap'.step_over()<CR>",
      keybindings = { "n", "<space>dso", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Step out",
      cmd = "<CMD>lua require'dap'.step_out()<CR>",
      keybindings = { "n", "<space>dsu", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Commands",
      cmd = "<CMD>lua require'telescope'.extensions.dap.commands{}<CR>",
      keybindings = { "n", "<space>dc", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Run configurations",
      cmd = "<CMD>lua require'telescope'.extensions.dap.configurations{}<CR>",
      keybindings = { "n", "<space>dr", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Variables",
      cmd = "<CMD>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)<CR>",
      keybindings = { "n", "<space>dv", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Frames",
      cmd = "<CMD>lua require'telescope'.extensions.dap.frames{}<CR>",
      keybindings = { "n", "<space>df", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Expression",
      cmd = "<CMD>lua require('dap.ui.widgets').hover(require('dap.ui.widgets').expression)<CR>",
      keybindings = { "n", "<space>de", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Run to cursor",
      cmd = "<CMD>lua require'dap'.run_to_cursor()<CR>",
      keybindings = { "n", "<space>dgc", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Continue",
      cmd = "<CMD>lua require'dap'.run_to_cursor()<CR>",
      keybindings = { "n", "<space>dgr", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Clear breakpoints",
      cmd = "<CMD>lua require('dap.breakpoints').clear()<CR>",
      keybindings = { "n", "<space>dbc", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Breakpoints",
      cmd = "<CMD>lua require'telescope'.extensions.dap.list_breakpoints{}<CR>",
      keybindings = { "n", "<space>db", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Toggle breakpoint",
      cmd = "<CMD>lua require'dap'.toggle_breakpoint()<CR>",
      keybindings = { "n", "<space>dtb", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Toggle conditional breakpoint",
      cmd = "<CMD>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      keybindings = { "n", "<space>dtc", silent_noremap },
    },
    {
      category = "dap",
      description = "DAP: Toggle logpoint",
      cmd = "<CMD>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      keybindings = { "n", "<space>dtl", silent_noremap },
    },
  })
end
