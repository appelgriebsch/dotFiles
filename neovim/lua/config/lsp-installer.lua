local lsp_setup = require('config.lsp-setup')
local lsp_installer = require("nvim-lsp-installer")

-- Provide settings first!
lsp_installer.settings {
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
}

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lsp_installer.on_server_ready(function(server)

    if server.name == "jdtls" then
      return
    end

    local opts = lsp_setup.make_config()

    if server.name == "jsonls" then
      opts.settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      }
    end

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]

end)