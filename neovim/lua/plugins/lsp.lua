local M = {}
local keymap = require("utils.keymaps")

-- Automatically update diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = false,
  severity_sort = true,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

-- table from lsp severity to vim severity.
local severity = {
  "error",
  "warn",
  "info",
  "info", -- map both hint and info to info?
}

vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
  vim.notify(method.message, severity[params.type])
end

local diagnostic_signs = { " ", " ", " ", " " }
local diagnostic_severity_fullnames = { "Error", "Warning", "Information", "Hint" }
local diagnostic_severity_shortnames = { "Error", "Warn", "Info", "Hint" }

for index, icon in ipairs(diagnostic_signs) do
  local fullname = diagnostic_severity_fullnames[index]
  local shortname = diagnostic_severity_shortnames[index]

  vim.fn.sign_define("DiagnosticSign" .. shortname, {
    text = icon,
    texthl = "Diagnostic" .. shortname,
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("LspDiagnosticsSign" .. fullname, {
    text = icon,
    texthl = "LspDiagnosticsSign" .. fullname,
    linehl = "",
    numhl = "",
  })
end

-- keymaps
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- set omnifunc to lsp version
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- configure lsp signature helper (virtual text hints)
  local cfg = {
    bind = true,
    handler_opts = {
      border = "none"
    },
    floating_window = false,
    hint_prefix = " "
  }

  require("lsp_signature").on_attach(cfg, bufnr)

  -- default lsp mappings.
  if client.name == "rust_analyzer" then
    vim.keymap.set("n", "K", "<CMD>RustHoverActions<CR>", keymap.map_local("HIDDEN"))
  else
    vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", keymap.map_local("HIDDEN"))
  end
  vim.keymap.set("n", "<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>", keymap.map_local("HIDDEN"))

  vim.keymap.set("n", "<leader>la", "<CMD>lua vim.lsp.buf.code_action()<CR>", keymap.map_local("code actions"))
  vim.keymap.set("n", "<leader>lgj", "<CMD>lua vim.diagnostic.goto_prev({ border = \"rounded\" })<CR>",
    keymap.map_local("previous diagnostic"))
  vim.keymap.set("n", "<leader>lgk", "<CMD>lua vim.diagnostic.goto_next({ border = \"rounded\" })<CR>",
    keymap.map_local("next diagnostic"))
  vim.keymap.set("n", "<leader>lr", "<CMD>lua vim.lsp.buf.rename()<CR>", keymap.map_local("rename symbol"))

  -- Set some keybinds conditional on server capabilities
  vim.cmd [[ command! Format execute "lua vim.lsp.buf.formatting()" ]]
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.formatting()<CR>", keymap.map_local("format buffer"))
  elseif client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.range_formatting()<CR>", keymap.map_local("format range"))
  end

  -- Telescope
  local status_telescope, telescope = pcall(require, "telescope")
  if status_telescope then
    vim.keymap.set("n", "<leader>lgd", "<CMD>Telescope lsp_definitions<CR>", keymap.map_local("definitions"))
    vim.keymap.set("n", "<leader>lgD", "<CMD>Telescope lsp_declarations<CR>", keymap.map_local("declarations"))
    vim.keymap.set("n", "<leader>lgr", "<CMD>Telescope lsp_references<CR>", keymap.map_local("references"))
    vim.keymap.set("n", "<leader>lgi", "<CMD>Telescope lsp_implementations<CR>", keymap.map_local("implementations"))
    vim.keymap.set("n", "<leader>lgt", "<CMD>Telescope lsp_typedefs<CR>", keymap.map_local("type definitions"))
    vim.keymap.set("n", "<leader>ld", "<CMD>Telescope diagnostics bufnr=0<CR>", keymap.map_local("local diagnostics"))
    vim.keymap.set("n", "<leader>ls", "<CMD>Telescope lsp_document_symbols<CR>", keymap.map_local("local symbols"))
    vim.keymap.set("n", "<leader>lD", "<CMD>Telescope diagnostics<CR>", keymap.map_local("workspace diagnostics"))
    vim.keymap.set("n", "<leader>lS", "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>",
      keymap.map_local("workspace symbols"))
  end

  -- Help
  local status_dash, dash = pcall(require, "dash")
  if status_dash then
    vim.keymap.set("n", "<leader>uds", "<CMD>Dash<CR>", keymap.map_local("search index"))
    vim.keymap.set("n", "<leader>udl", "<CMD>DashWord<CR>", keymap.map_local("lookup word"))
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end

  local status_menu, menu = pcall(require, "key-menu")
  if not status_menu then
    return
  end
  menu.set("n", "<leader>l", { desc = "lsp" })
  menu.set("n", "<leader>lg", { desc = "goto" })
  if status_dash then
    menu.set("n", "<leader>ud", { desc = "dash" })
  end
end

function M.make_config()
  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
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

return M
