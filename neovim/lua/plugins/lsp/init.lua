local M = {}

require("plugins.lsp.handlers")

-- keymaps
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- set omnifunc to lsp version
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local status_lspsignature, lspsignature = pcall(require, "lsp_signature")
  if status_lspsignature then
    -- configure lsp signature helper (virtual text hints)
    local cfg = {
      bind = true,
      handler_opts = {
        border = "none"
      },
      floating_window = false,
      hint_prefix = " "
    }
    lspsignature.on_attach(cfg, bufnr)
  end

  -- default lsp mappings.
  local status_menu, menu = pcall(require, "which-key")
  if status_menu then
    menu.register({
      ["<leader>l"] = {
        name = "+lsp",
        a = { "<CMD>lua vim.lsp.buf.code_action()<CR>", "code actions" },
        d = {
          name = "+diagnostics",
          j = { "<CMD>lua vim.diagnostic.goto_prev({ border = \"rounded\" })<CR>", "previous" },
          k = { "<CMD>lua vim.diagnostic.goto_next({ border = \"rounded\" })<CR>", "next" },
          p = { "<CMD>lua vim.diagnostic.open_float({ border = \"rounded\" })<CR>", "preview" },
          s = { "<CMD>lua require(\"telescope.builtin\").diagnostics(ivy_opts({ bufnr=0 }))<CR>", "show" }
        },
        D = { "<CMD>lua require(\"telescope.builtin\").diagnostics(ivy_opts())<CR>", "workspace diagnostics" },
        f = { "<CMD>lua vim.lsp.buf.format()<CR>", "format" },
        g = {
          name = "+goto",
          d = { "<CMD>lua require(\"telescope.builtin\").lsp_definitions(ivy_opts())<CR>", "definitions" },
          D = { "<CMD>lua require(\"telescope.builtin\").lsp_declarations(ivy_opts())<CR>", "declarations" },
          r = { "<CMD>lua require(\"telescope.builtin\").lsp_references(ivy_opts())<CR>", "references" },
          i = { "<CMD>lua require(\"telescope.builtin\").lsp_implementations(ivy_opts())<CR>", "implementations" },
          t = { "<CMD>lua require(\"telescope.builtin\").lsp_typedefs(ivy_opts())<CR>", "type definitions" }
        },
        r = { "<CMD>lua vim.lsp.buf.rename()<CR>", "rename symbol" },
        s = { "<CMD>lua require(\"telescope.builtin\").lsp_document_symbols(ivy_opts({ preview = { hide_on_startup = false }}))<CR>", "symbols" },
        S = { "<CMD>lua require(\"telescope.builtin\").lsp_dynamic_workspace_symbols(ivy_opts({ preview = { hide_on_startup = false }}))<CR>", "workspace symbols" }
      },
      ["<C-Space"] = { "<CMD>lua vim.lsp.buf.signature_help()<CR>", "show signature" }
    }, {
      mode = "n", -- NORMAL mode
      prefix = "",
      buffer = bufnr, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    })
  end

  vim.cmd [[ command! Format execute "lua vim.lsp.buf.formatting()" ]]

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
end

function M.make_config()
  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  return {
    flags = {
      allow_incremental_sync = true,
    },
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

function M.lsp_name(msg)
  msg = msg or "Inactive"
  local buf_clients = vim.lsp.buf_get_clients()
  if next(buf_clients) == nil then
    if type(msg) == "boolean" or #msg == 0 then
      return "Inactive"
    end
    return msg
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  return table.concat(buf_client_names, ", ")
end

return M
