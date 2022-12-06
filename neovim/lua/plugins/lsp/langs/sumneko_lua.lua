local M = {}

local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  return
end

local lsp_config = require("plugins.lsp").make_config()

function M.setup()
  lspconfig.sumneko_lua.setup({
    on_attach = lsp_config.on_attach,
    capabilities = lsp_config.capabilities,
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
        diagnostics = {
          -- Get the language server to recognize the 'vim', 'use' global
          globals = { 'vim', 'use', 'require' },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.stdpath "config" .. "/lua"] = true,
          },
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
      },
    },
  })
end

return M