local status_dap, dap = pcall(require, "dap")
if not status_dap then
  return
end

local keymap = require("utils.keymaps")

dap.defaults.fallback.terminal_win_cmd = "enew"

local status_dap_js, dap_js = pcall(require, "dap-vscode-js")
if status_dap_js then
  local mason_registry = require("mason-registry")
  local js_debug_pkg = mason_registry.get_package("js-debug-adapter")
  local js_debug_path = js_debug_pkg:get_install_path()
  dap_js.setup({
    debugger_path = js_debug_path,
    adapters = { "pwa-node", "node-terminal" }, -- which adapters to register in nvim-dap
  })
  for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file (" .. language .. ")",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach (" .. language .. ")",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      }
    }
  end
end

require("nvim-dap-virtual-text").setup()

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

vim.api.nvim_exec([[
  au FileType dap-repl lua require("dap.ext.autocompl").attach()
]], false)

vim.keymap.set("n", "<leader>dr", "<CMD>Telescope dap configurations<CR>", keymap.map_global("run"))
vim.keymap.set("n", "<leader>dp", "<CMD>lua require(\"dap\").pause()<CR>", keymap.map_global("pause"))
vim.keymap.set("n", "<leader>dc", "<CMD>lua require(\"dap\").continue()<CR>", keymap.map_global("continue"))
vim.keymap.set("n", "<leader>dx", "<CMD>lua require(\"dap\").terminate()<CR>", keymap.map_global("terminate"))
vim.keymap.set("n", "<leader>dv",
  "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").scopes)<CR>",
  keymap.map_global("variables"))
vim.keymap.set("n", "<leader>dt",
  "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").threads)<CR>",
  keymap.map_global("threads"))
vim.keymap.set("n", "<leader>df",
  "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").frames)<CR>",
  keymap.map_global("frames"))
vim.keymap.set("n", "<leader>de", "<CMD>lua require(\"dap.ui.widgets\").hover()<CR>", keymap.map_global("expression"))

vim.keymap.set("n", "<leader>dbc", "<CMD>lua require(\"dap.breakpoints\").clear()<CR>",
  keymap.map_global("clear"))
vim.keymap.set("n", "<leader>dbs", "<CMD>Telescope dap list_breakpoints<CR>", keymap.map_global("show"))
vim.keymap.set("n", "<leader>dbt", "<CMD>lua require(\"dap\").toggle_breakpoint()<CR>",
  keymap.map_global("toggle breakpoint"))
vim.keymap.set("n", "<leader>dbc",
  "<CMD>lua require(\"dap\").set_breakpoint(vim.fn.input(\"Breakpoint condition: \"))<CR>",
  keymap.map_global("conditional breakpoint"))
vim.keymap.set("n", "<leader>dbl",
  "<CMD>lua require(\"dap\").set_breakpoint(nil, nil, vim.fn.input(\"Log point message: \"))<CR>",
  keymap.map_global("logpoint"))

vim.keymap.set("n", "<leader>dsi", "<CMD>lua require(\"dap\").step_into()<CR>", keymap.map_global("into"))
vim.keymap.set("n", "<leader>dsb", "<CMD>lua require(\"dap\").step_back()<CR>", keymap.map_global("back"))
vim.keymap.set("n", "<leader>dso", "<CMD>lua require(\"dap\").step_over()<CR>", keymap.map_global("over"))
vim.keymap.set("n", "<leader>dsx", "<CMD>lua require(\"dap\").step_out()<CR>", keymap.map_global("out"))
vim.keymap.set("n", "<leader>dsr", "<CMD>lua require(\"dap\").run_to_cursor()<CR>", keymap.map_global("to cursor"))

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>d", { desc = "debugger" })
menu.set("n", "<leader>db", { desc = "breakpoints" })
menu.set("n", "<leader>ds", { desc = "steps" })
