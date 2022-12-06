local M = {}

local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  return
end

local lsp_config = require("plugins.lsp").make_config()

local function on_attach(client, bufnr)
  require("sqls").on_attach(client, bufnr)
  lsp_config.on_attach(client, bufnr)
end

function M.setup()
  -- sqls setup
  lspconfig.sqls.setup {
    on_attach = on_attach,
    capabilities = lsp_config.capabilities,
  }
end

return M
