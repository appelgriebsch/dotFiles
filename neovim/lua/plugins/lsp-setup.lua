local status_lspinstaller, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_lspinstaller then
  return
end

local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  return
end

require("plugins.cmp").setup()

local lsp_setup = require("plugins.lsp").make_config()

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

-- generic lsp server initialization
for _, server in ipairs(lsp_installer.get_installed_servers()) do
  if server.name == "jdtls" then
    goto continue
  end
  lspconfig[server.name].setup({
    on_attach = lsp_setup.on_attach,
    capabilities = lsp_setup.capabilities
  })
  ::continue::
end

-- Specific sumneko_lua setup.
lspconfig.sumneko_lua.setup({
  on_attach = lsp_setup.on_attach,
  capabilities = lsp_setup.capabilities,
  settings = {
    Lua = {
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

-- Specific rust-analyzer setup.
local status_rust, rust_tools = pcall(require, "rust-tools")
if status_rust then
  -- rust tools configuration for debugging support
  local extension_path = vim.env.HOME .. '/.local/share/nvim/dap_adapters/codelldb/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = vim.fn.has "mac" == 1 and extension_path ..  'lldb/lib/liblldb.dylib' or extension_path ..  'lldb/lib/liblldb.so'
  rust_tools.setup({
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
    },
    tools = {
      autoSetHints = false,
      hover_with_actions = false,
      inlay_hints = {
        show_parameter_hints = false,
      },
    },
    server = {
      on_attach = lsp_setup.on_attach,
      capabilities = lsp_setup.capabilities,
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

-- specific jsonls setup
local status_jsonls, schemastore = pcall(require, "schemastore")
if status_jsonls then
  lspconfig.jsonls.setup({
    on_attach = lsp_setup.on_attach,
    capabilities = lsp_setup.capabilities,
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
      },
    },
  })
end

-- Specific typescript setup.
local status_tsserver, typescript = pcall(require, "typescript")
if status_tsserver then
  typescript.setup({
    debug = false, -- enable debug logging for commands
    server = { -- pass options to lspconfig's setup method
      on_attach = lsp_setup.on_attach,
      capabilities = lsp_setup.capabilities
    },
  })
end

-- Yaml companion
local status_yamlls, yaml_companion = pcall(require, "yaml-companion")
if status_yamlls then
  local yaml_cfg = yaml_companion.setup({
    -- Add any options here, or leave empty to use the default settings
    -- lspconfig = {
    --   cmd = {"yaml-language-server"}
    -- },
  })
  lspconfig.yamlls.setup(yaml_cfg)
end

-- sqls setup
lspconfig.sqls.setup{
  on_attach = function(client, bufnr)
      require("sqls").on_attach(client, bufnr)
  end
}

local status_lsplines, lsp_lines = pcall(require, "lsp_lines")
if status_lsplines then
  lsp_lines.register_lsp_virtual_lines()
  vim.api.nvim_exec([[
    augroup LSPLines
      autocmd!
      autocmd InsertEnter * silent! lua vim.diagnostic.config({ virtual_lines = false })
      autocmd InsertLeave * silent! lua vim.diagnostic.config({ virtual_lines = true })
    augroup end
  ]], false)
end
