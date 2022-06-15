local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local lsp_setup = require("plugins.lsp").make_config()

local noremap = { noremap = true }
local silent_noremap = { noremap = true, silent = true }

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
local status_ok, rust_tools = pcall(require, "rust-tools")
if status_ok then
  -- rust tools configuration for debugging support
  local extension_path = vim.env.HOME .. '/.local/share/nvim/dap_adapters/codelldb/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = vim.fn.has "mac" == 1 and extension_path ..  'lldb/lib/liblldb.dylib' or extension_path ..  'lldb/lib/liblldb.so'
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
local status_ok, schemastore = pcall(require, "schemastore")
if status_ok then
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
local status_ok, typescript = pcall(require, "typescript")
if status_ok then
  typescript.setup({
    debug = false, -- enable debug logging for commands
    server = { -- pass options to lspconfig's setup method
      on_attach = lsp_setup.on_attach,
      capabilities = lsp_setup.capabilities
    },
  })
end

-- Yaml companion
local status_ok, yaml_companion = pcall(require, "yaml-companion")
if status_ok then
  local yaml_cfg = yaml_companion.setup({
    -- Add any options here, or leave empty to use the default settings
    -- lspconfig = {
    --   cmd = {"yaml-language-server"}
    -- },
  })
  lspconfig.yamlls.setup(yaml_cfg)
end

local status_ok, lsp_lines = pcall(require, "lsp_lines")
if status_ok then
  lsp_lines.register_lsp_virtual_lines()
  vim.api.nvim_exec([[
    augroup LSPLines
      autocmd!
      autocmd InsertEnter * silent! lua vim.diagnostic.config({ virtual_lines = false })
      autocmd InsertLeave * silent! lua vim.diagnostic.config({ virtual_lines = true })
    augroup end
  ]], false)
end

local status_ok, command_center = pcall(require, "command_center")
if status_ok then
  command_center.add({
    {
      category = "lsp",
      description = "LSP: Code Actions",
      cmd = "<CMD>lua vim.lsp.buf.code_action()<CR>",
      keybindings = { "n", "<leader>ca", silent_noremap },
    },
    {
      category = "lsp",
      description = "LSP: Goto definition",
      cmd = "<CMD>Telescope lsp_definitions<CR>",
      keybindings = { "n", "<leader>gd", silent_noremap },
    },
    {
      category = "lsp",
      description = "LSP: Goto declaration",
      cmd = "<CMD>Telescope lsp_declarations<CR>",
      keybindings = { "n", "<leader>gD", silent_noremap },
    },
    {
      category = "lsp",
      description = "LSP: Goto references",
      cmd = "<CMD>Telescope lsp_references<CR>",
      keybindings = { "n", "<leader>gr", silent_noremap },
    },
    {
      category = "lsp",
      description = "LSP: Goto implementations",
      cmd = "<CMD>Telescope lsp_implementations<CR>",
      keybindings = { "n", "<leader>gi", silent_noremap },
    },
    {
      category = "lsp",
      description = "LSP: Goto type definition",
      cmd = "<CMD>Telescope lsp_typedefs<CR>",
      keybindings = { "n", "<leader>gt", silent_noremap },
    },
  })
end
