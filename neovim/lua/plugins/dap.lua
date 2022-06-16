local function global_keymap(desc) return { silent = true, desc = desc } end

local status_dap, dap = pcall(require, "dap")
if not status_dap then
  return
end

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

vim.keymap.set("n", "<leader>dr", "<CMD>lua require(\"telescope\").extensions.dap.configurations{}<CR>", global_keymap("Run"))
vim.keymap.set("n", "<leader>dp", "<CMD>lua require(\"dap\").pause()<CR>", global_keymap("Pause"))
vim.keymap.set("n", "<leader>dc", "<CMD>lua require(\"dap\").continue()<CR>", global_keymap("Continue"))
vim.keymap.set("n", "<leader>dv", "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").scopes)<CR>", global_keymap("Variables"))
vim.keymap.set("n", "<leader>dt", "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").threads)<CR>", global_keymap("Threads"))
vim.keymap.set("n", "<leader>df", "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").frames)<CR>", global_keymap("Frames"))
vim.keymap.set("n", "<leader>de", "<CMD>lua require(\"dap.ui.widgets\").hover()<CR>", global_keymap("Expression"))

vim.keymap.set("n", "<leader>dbd", "<CMD>lua require(\"dap.breakpoints\").clear()<CR>", global_keymap("Delete breakpoints"))
vim.keymap.set("n", "<leader>dbs", "<CMD>lua require(\"telescope\").extensions.dap.list_breakpoints{}<CR>", global_keymap("Show breakpoints"))
vim.keymap.set("n", "<leader>dbt", "<CMD>lua require(\"dap\").toggle_breakpoint()<CR>", global_keymap("Toggle breakpoint"))
vim.keymap.set("n", "<leader>dbc", "<CMD>lua require(\"dap\").set_breakpoint(vim.fn.input(\"Breakpoint condition: \"))<CR>", global_keymap("Toggle conditional breakpoint"))
vim.keymap.set("n", "<leader>dbl", "<CMD>lua require(\"dap\").set_breakpoint(nil, nil, vim.fn.input(\"Log point message: \"))<CR>", global_keymap("Toggle logpoint"))

vim.keymap.set("n", "<leader>dsi", "<CMD>lua require(\"dap\").step_into()<CR>", global_keymap("Step into"))
vim.keymap.set("n", "<leader>dsb", "<CMD>lua require(\"dap\").step_back()<CR>", global_keymap("Step back"))
vim.keymap.set("n", "<leader>dso", "<CMD>lua require(\"dap\").step_over()<CR>", global_keymap("Step over"))
vim.keymap.set("n", "<leader>dsx", "<CMD>lua require(\"dap\").step_out()<CR>", global_keymap("Step out"))
vim.keymap.set("n", "<leader>dsr", "<CMD>lua require(\"dap\").run_to_cursor()<CR>", global_keymap("Go to cursor"))

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>d", { desc = "Debugger" })
menu.set("n", "<leader>db", { desc = "Breakpoints" })
menu.set("n", "<leader>ds", { desc = "Steps" })
