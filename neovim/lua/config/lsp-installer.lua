local lsp_setup = require("config.lsp-setup")
local lsp_installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")

-- Provide settings first!
lsp_installer.setup({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

local lsp_cfg = lsp_setup.make_config()

-- generic lsp server initialization
for _, server in ipairs(lsp_installer.get_installed_servers()) do
  if server.name == "jdtls" then
    goto continue
  end
  lspconfig[server.name].setup({
    on_attach = lsp_cfg.on_attach,
    capabilities = lsp_cfg.capabilities
  })
  ::continue::
end

-- Specific sumneko_lua setup.
lspconfig.sumneko_lua.setup({
  on_attach = lsp_cfg.on_attach,
  capabilities = lsp_cfg.capabilities,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the 'vim', 'use' global
        globals = { 'vim', 'use', 'require' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
})

-- Specific rust-analyzer setup.
-- rust tools configuration for debugging support
local extension_path = vim.env.HOME .. '/.local/share/nvim/dap_adapters/codelldb/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = jit.os == 'OSX' and extension_path ..  'lldb/lib/liblldb.dylib' or extension_path ..  'lldb/lib/liblldb.so'
local rust_tools = require("rust-tools")
rust_tools.setup({
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
  },
  tools = {
    autoSetHints = true,
    hover_with_actions = false,
    inlay_hints = {
      show_parameter_hints = true,
    },
  },
  server = {
    on_attach = lsp_cfg.on_attach,
    capabilities = lsp_cfg.capabilities,
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

-- specific jsonls setup
lspconfig.jsonls.setup({
  on_attach = lsp_cfg.on_attach,
  capabilities = lsp_cfg.capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})

-- Specific typescript setup.
require("typescript").setup({
  debug = false, -- enable debug logging for commands
  server = { -- pass options to lspconfig's setup method
    on_attach = lsp_cfg.on_attach,
    capabilities = lsp_cfg.capabilities
  },
})

-- SQL ls setup
lspconfig.sqls.setup({
    on_attach = function(client, bufnr)
        require('sqls').on_attach(client, bufnr)
    end
})

-- Yaml companion
local yaml_cfg = require("yaml-companion").setup({
  -- Add any options here, or leave empty to use the default settings
  -- lspconfig = {
  --   cmd = {"yaml-language-server"}
  -- },
})
lspconfig.yamlls.setup(yaml_cfg)