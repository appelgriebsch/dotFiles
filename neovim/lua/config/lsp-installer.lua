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

    local opts = lsp_setup.make_config()

    if server.name == "jdtls" then
      table.insert(require('command_palette').CpMenu,
        {"Test",
          { "execute test suite", ":lua require('jdtls').test_class()" },
          { "execute test method", ":lua require('jdtls').test_nearest_method()" },
        }
      )
      return
    end

    if server.name == "rust_analyzer" then
      -- Initialize the LSP via rust-tools instead
      require("rust-tools").setup {
        -- The "server" property provided in rust-tools setup function are the
        -- settings rust-tools will provide to lspconfig during init.
        -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
        -- with the user's own settings (opts).
        server = vim.tbl_deep_extend("force", server:get_default_options(), opts, {
          settings = {
            ["rust-analyzer"] = {
              completion = {
                postfix = {
                  enable = false
                }
              },
              checkOnSave = {
                command = "clippy"
              },
            }
          }
        }),
      }
      server:attach_buffers()
      -- Only if standalone support is needed
      require("rust-tools").start_standalone_if_required()
      return
    end

		if server.name == "sumneko_lua" then
			-- only apply these settings for the "sumneko_lua" server
			opts.settings = {
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
			}
		end

    if server.name == "jsonls" then
      opts.settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      }
    end

    if server.name == "tsserver" then
      -- Needed for inlayHints. Merge this table with your settings or copy
      -- it from the source if you want to add your own init_options.
      local init_options = require("nvim-lsp-ts-utils").init_options
      local ts_opts = vim.tbl_deep_extend("force", server:get_default_options(), opts, init_options, {
        settings = {
          javascript = {
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
            }
          },
          typescript = {
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
            }
          }
        },
        on_attach = function(client, bufnr)
          local ts_utils = require("nvim-lsp-ts-utils")
          ts_utils.setup({})
          -- required to fix code action ranges and filter diagnostics
          ts_utils.setup_client(client)
          opts.on_attach(client, bufnr)
        end
      })
      server:setup(ts_opts)
      vim.cmd [[ do User LspAttachBuffers ]]
      return
    end

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]

end)
