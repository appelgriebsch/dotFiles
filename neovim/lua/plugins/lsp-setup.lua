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

require("plugins.cmp").setup()

local status_lsplines, lsp_lines = pcall(require, "lsp_lines")
if status_lsplines then
  vim.api.nvim_exec([[
    augroup LSPLines
      autocmd!
      autocmd InsertEnter * silent! lua vim.diagnostic.config({ virtual_lines = false })
      autocmd InsertLeave * silent! lua vim.diagnostic.config({ virtual_lines = true })
    augroup end
  ]], false)
end

local lsp_setup = require("plugins.lsp").make_config()

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

local mason_registry = require("mason-registry")

mason_lspconfig.setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    if server_name == "jdtls" then
      -- will be handled in ftplugin --
    else
      require("lspconfig")[server_name].setup({
        on_attach = lsp_setup.on_attach,
        capabilities = lsp_setup.capabilities
      })
    end
  end,
  -- Next, you can provide targeted overrides for specific servers.
  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup({
      on_attach = function(client, bufnr)
        lsp_setup.on_attach(client, bufnr)
      end,
      capabilities = lsp_setup.capabilities,
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
  end,
  ["rust_analyzer"] = function()
    -- rust tools configuration for debugging support
    local codelldb = mason_registry.get_package("codelldb")
    local extension_path = codelldb:get_install_path() .. '/extension/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = vim.fn.has "mac" == 1 and extension_path .. 'lldb/lib/liblldb.dylib' or extension_path .. 'lldb/lib/liblldb.so'
    require("rust-tools").setup({
      dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
      },
      tools = {
        autoSetHints = false,
        hover_with_actions = true,
        inlay_hints = {
          auto = false,
          show_parameter_hints = true,
        },
      },
      server = {
        on_attach = function(client, bufnr)
          lsp_setup.on_attach(client, bufnr)
        end,
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
  end,
  ["jsonls"] = function()
    -- specific jsonls setup
    lspconfig.jsonls.setup({
      on_attach = lsp_setup.on_attach,
      capabilities = lsp_setup.capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
        },
      },
    })
  end,
  ["sqls"] = function()
    -- sqls setup
    lspconfig.sqls.setup {
      on_attach = function(client, bufnr)
        require("sqls").on_attach(client, bufnr)
        lsp_setup.on_attach(client, bufnr)
      end,
      capabilities = lsp_setup.capabilities,
    }
  end,
  ["tsserver"] = function ()
    lspconfig.tsserver.setup({
      on_attach = function(client, bufnr)
        lsp_setup.on_attach(client, bufnr)
      end,
      capabilities = lsp_setup.capabilities,
      settings = {
        javascript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        typescript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
      },
    })
  end
})
