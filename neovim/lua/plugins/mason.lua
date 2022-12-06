local status_mason, mason = pcall(require, "mason")
if not status_mason then
  return
end

local status_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason_lspconfig then
  return
end

local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  return
end

local lsp_config = require("plugins.lsp").make_config()

mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "",
      package_uninstalled = "✗"
    }
  }
})

mason_lspconfig.setup({
  ensure_installed = { "sumneko_lua", "rust_analyzer" },
  automatic_installation = false,
})

mason_lspconfig.setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    if server_name == "jdtls" then
      -- will be handled in ftplugin --
    else
      local has_langserver_setup, langserver = pcall(require, "plugins.lsp.langs." .. server_name)
      if has_langserver_setup then
        langserver.setup()
      else
        require("lspconfig")[server_name].setup({
          on_attach = lsp_config.on_attach,
          capabilities = lsp_config.capabilities
        })
      end
    end
  end,
})
