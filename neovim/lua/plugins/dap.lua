local status_dap, dap = pcall(require, "dap")
if not status_dap then
  return
end

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

local status_dap_virttext, dap_virttext = pcall(require, "nvim-dap-virtual-text")
if status_dap_virttext then
  dap_virttext.setup()
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

vim.api.nvim_exec([[
  au FileType dap-repl lua require("dap.ext.autocompl").attach()
]], false)

local status_menu, menu = pcall(require, "which-key")
if not status_menu then
  return
end

menu.register({
  ["<leader>d"] = {
    name = "+debugger",
    b = {
      name = "+breakpoints",
      c = { "<CMD>lua require(\"dap\").set_breakpoint(vim.ui.input(\"Breakpoint condition: \"))<CR>", "condition" },
      l = { "<CMD>lua require(\"dap\").set_breakpoint(nil, nil, vim.ui.input(\"Log point message: \"))<CR>", "logpoint" },
      r = { "<CMD>lua require(\"dap.breakpoints\").clear()<CR>", "remove all" },
      s = { "<CMD>Telescope dap list_breakpoints<CR>", "show" },
      t = { "<CMD>lua require(\"dap\").toggle_breakpoint()<CR>", "toggle" },
    },
    c = { "<CMD>lua require(\"dap\").continue()<CR>", "continue" },
    e = { "<CMD>lua require(\"dap.ui.widgets\").hover()<CR>", "expression" },
    p = { "<CMD>lua require(\"dap\").pause()<CR>", "pause" },
    r = { "<CMD>Telescope dap configurations<CR>", "run" },
    s = {
      name = "+steps",
      b = { "<CMD>lua require(\"dap\").step_back()<CR>", "back" },
      c = { "<CMD>lua require(\"dap\").run_to_cursor()<CR>", "to cursor" },
      i = { "<CMD>lua require(\"dap\").step_into()<CR>", "into" },
      o = { "<CMD>lua require(\"dap\").step_over()<CR>", "over" },
      r = { "<CMD>lua require(\"dap\").step_out()<CR>", "return" }
    },
    t = { "<CMD>lua require(\"dap\").terminate()<CR>", "terminate" },
    v = {
      name = "+views",
      f = { "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").frames)<CR>", "frames" },
      s = { "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").scopes)<CR>", "scopes" },
      t = { "<CMD>lua require(\"dap.ui.widgets\").centered_float(require(\"dap.ui.widgets\").threads)<CR>", "threads" },
    },
  }
})
