local M = {}

local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  return
end

local lsp_config = require("plugins.lsp").make_config()

function M.setup()
  -- specific jsonls setup
  lspconfig.jsonls.setup({
    on_attach = lsp_config.on_attach,
    capabilities = lsp_config.capabilities,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  })
end

return M
