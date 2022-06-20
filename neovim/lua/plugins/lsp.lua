local function local_keymap(desc) return { silent = true, buffer = true, desc = desc } end

local M = {}

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
  vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", local_keymap("HIDDEN"))
  vim.keymap.set("n", "<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>", local_keymap("HIDDEN"))

  vim.keymap.set("n", "<leader>bdj", "<CMD>lua vim.diagnostic.goto_prev({ border = \"rounded\" })<CR>", local_keymap("Goto previous diagnostic"))
  vim.keymap.set("n", "<leader>bdk", "<CMD>lua vim.diagnostic.goto_next({ border = \"rounded\" })<CR>", local_keymap("Goto next diagnostic"))
  vim.keymap.set("n", "<leader>bdp", "<CMD>lua vim.diagnostic.open_float()<CR>", local_keymap("Show current diagnostic"))
  vim.keymap.set("n", "<leader>bsr", "<CMD>lua vim.lsp.buf.rename()<CR>", local_keymap("Rename symbol"))
  vim.keymap.set("n", "<leader>bsa", "<CMD>lua vim.lsp.buf.code_action()<CR>", local_keymap("Show Actions"))

  -- Telescope
  vim.keymap.set("n", "<leader>bjd", "<CMD>Telescope lsp_definitions<CR>", local_keymap("Jump to definitions"))
  vim.keymap.set("n", "<leader>bjD", "<CMD>Telescope lsp_declarations<CR>", local_keymap("Jump to declarations"))
  vim.keymap.set("n", "<leader>bjr", "<CMD>Telescope lsp_references<CR>", local_keymap("Jump to references"))
  vim.keymap.set("n", "<leader>bji", "<CMD>Telescope lsp_implementations<CR>", local_keymap("Jump to implementations"))
  vim.keymap.set("n", "<leader>bjt", "<CMD>Telescope lsp_typedefs<CR>", local_keymap("Jump to type definitions"))
  vim.keymap.set("n", "<leader>bds", "<CMD>Telescope diagnostics bufno=0<CR>", local_keymap("Show Diagnostics"))
  vim.keymap.set("n", "<leader>bss", "<CMD>Telescope lsp_document_symbols<CR>", local_keymap("Show Symbols"))
  vim.keymap.set("n", "<leader>wd", "<CMD>Telescope diagnostics<CR>", local_keymap("Show Diagnostics"))
  vim.keymap.set("n", "<leader>ws", "<CMD>Telescope lsp_workspace_symbols<CR>", local_keymap("Show Symbols"))

  -- Help
  vim.keymap.set("n", "<leader>bhs", "<CMD>Dash<CR>", local_keymap("Search index"))
  vim.keymap.set("n", "<leader>bhl", "<CMD>DashWord<CR>", local_keymap("Lookup word"))

  -- Set some keybinds conditional on server capabilities
  vim.cmd [[ command! Format execute "lua vim.lsp.buf.formatting()" ]]
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<leader>bsf", "<CMD>lua vim.lsp.buf.formatting()<CR>", local_keymap("Format buffer"))
  elseif client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("n", "<leader>bsf", "<CMD>lua vim.lsp.buf.range_formatting()<CR>", local_keymap("Format range"))
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
  menu.set("n", "<leader>bd", { desc = "Diagnostics" })
  menu.set("n", "<leader>bj", { desc = "Jump" })
  menu.set("n", "<leader>bh", { desc = "Help" })
  menu.set("n", "<leader>bs", { desc = "Source" })
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
