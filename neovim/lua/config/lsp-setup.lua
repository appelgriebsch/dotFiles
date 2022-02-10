local lspkind = require('lspkind')
local luasnip = require('luasnip')
local cmp = require('cmp')

local M = {}

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format(),
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
    { name = 'crates' }
  })
})

require('cmp').setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})

-- Automatically update diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, prefix = "●" },
  severity_sort = true,
})

local diagnostic_signs = {" ", " ", " ", " "}
local diagnostic_severity_fullnames = {"Error", "Warning", "Information", "Hint"}
local diagnostic_severity_shortnames = {"Error", "Warn", "Info", "Hint"}

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
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- set omnifunc to lsp version
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local cfg = {
    bind = true,
    handler_opts = {
      border = "none"
    },
    floating_window = false,
    hint_prefix = " "
  }

  require('lsp_signature').on_attach(cfg, bufnr)

  -- Mappings.
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('i', '<C-space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>k', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>j', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
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

-- config that activates keymaps and enables snippet support
function M.make_config()
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

return M
