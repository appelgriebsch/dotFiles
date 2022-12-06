local M = {}

local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  return
end

local lsp_config = require("plugins.lsp").make_config()
local mason_registry = require("mason-registry")

local function on_attach(client, bufnr)
  local status_menu, menu = pcall(require, "which-key")
  if status_menu then
    menu.register({
      r = {
        name = "+rust",
        d = { "<CMD>RustDebuggables<CR>", "debug configurations" }
      }
    }, {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = bufnr, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    })
  end

  lsp_config.on_attach(client, bufnr)
end

-- rust tools configuration for debugging support
local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. '/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = vim.fn.has "mac" == 1 and extension_path .. 'lldb/lib/liblldb.dylib' or
    extension_path .. 'lldb/lib/liblldb.so'

function M.setup()
  require("rust-tools").setup({
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
    },
    tools = {
      autoSetHints = false,
      hover_actions = {
        auto_focus = false,
      },
      inlay_hints = {
        auto = false,
        show_parameter_hints = true,
      },
    },
    server = {
      on_attach = on_attach,
      capabilities = lsp_config.capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          -- Add clippy lints for Rust.
          checkOnSave = {
            command = 'clippy',
          },
          procMacro = {
            enable = true,
          },
        }
      }
    },
  })
end

return M
