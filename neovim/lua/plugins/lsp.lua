local function local_keymap(desc) return { silent = true, buffer = true, desc = desc } end

local status_cmp, cmp = pcall(require, "cmp")
if not status_cmp then
  return
end

local lspkind = require("lspkind")
local snippy = require("snippy")

local M = {}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = { completeopt = "menu,menuone,noinsert" },
  experimental = { ghost_text = true },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol"
    })
  },
  mapping = {
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
    end, { "i", "s" })
  },
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "snippy" }
  }, {
    { name = "buffer" },
    { name = "path" },
    { name = "crates" }
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp_document_symbol" }
  }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" }
  })
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

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

  vim.keymap.set("n", "<leader>ldj", "<CMD>lua vim.diagnostic.goto_prev({ border = \"rounded\" })<CR>", local_keymap("Goto previous diagnostic"))
  vim.keymap.set("n", "<leader>ldk", "<CMD>lua vim.diagnostic.goto_next({ border = \"rounded\" })<CR>", local_keymap("Goto next diagnostic"))
  vim.keymap.set("n", "<leader>ldp", "<CMD>lua vim.diagnostic.open_float()<CR>", local_keymap("Show current diagnostic"))
  vim.keymap.set("n", "<leader>lr", "<CMD>lua vim.lsp.buf.rename()<CR>", local_keymap("Rename symbol"))
  vim.keymap.set("n", "<leader>la", "<CMD>lua vim.lsp.buf.code_action()<CR>", local_keymap("Show Code Actions"))

  -- Telescope
  vim.keymap.set("n", "<leader>lgd", "<CMD>Telescope lsp_definitions<CR>", local_keymap("Find definitions"))
  vim.keymap.set("n", "<leader>lgD", "<CMD>Telescope lsp_declarations<CR>", local_keymap("Find declarations"))
  vim.keymap.set("n", "<leader>lgr", "<CMD>Telescope lsp_references<CR>", local_keymap("Find references"))
  vim.keymap.set("n", "<leader>lgi", "<CMD>Telescope lsp_implementations<CR>", local_keymap("Find implementations"))
  vim.keymap.set("n", "<leader>lgt", "<CMD>Telescope lsp_typedefs<CR>", local_keymap("Find type definitions"))

  -- Help
  vim.keymap.set("n", "<leader>lhs", "<CMD>Dash<CR>", local_keymap("Show help index"))
  vim.keymap.set("n", "<leader>lhh", "<CMD>DashWord<CR>", local_keymap("Search for word"))

  -- Set some keybinds conditional on server capabilities
  vim.cmd [[ command! Format execute "lua vim.lsp.buf.formatting()" ]]
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.formatting()<CR>", local_keymap("Format buffer"))
  elseif client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.range_formatting()<CR>", local_keymap("Format range"))
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
