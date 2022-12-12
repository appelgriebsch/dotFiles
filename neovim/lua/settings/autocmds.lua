local api = vim.api
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd

-- Use 'q' to quit from common plugins
autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
  callback = function()
    cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd({ "FileType" }, {
  pattern = "tf",
  callback = function()
    cmd([[
      set filetype=terraform
    ]])
  end,
})

autocmd({ "FileType" }, {
  pattern = "java",
  callback = function()
    require("plugins.lsp.langs.jdtls").setup()
  end,
})

autocmd({ "FileType" }, {
  pattern = "http",
  callback = function()
    -- http / rest specific vim keybindings
    local status_menu, menu = pcall(require, "which-key")
    if not status_menu then
      return
    end

    menu.register({
      ["<leader>h"] = {
        name = "+http",
        e = { "<Plug>RestNvim<CR>", "execute request " },
        p = { "<Plug>RestNvimPreview<CR>", "preview cUrl" },
        r = { "<Plug>RestNvimLast<CR>", "repeat last request" }
      }
    })
  end,
})

autocmd({ "FileType" }, {
  pattern = "rust",
  callback = function()
    local status_menu, menu = pcall(require, "which-key")
    if status_menu then
      menu.register({
        K = { "<CMD>lua require(\"rust-tools.hover_actions\").hover_actions()<CR>", "HIDDEN" }
      })
    end
  end,
})

autocmd({ "FileType" }, {
  pattern = "toml",
  callback = function()
    if vim.fn.expand("%:t", false, false) == "Cargo.toml" then
      local status_menu, menu = pcall(require, "which-key")
      if status_menu then
        menu.register({
          K = { "<CMD>lua require(\"crates\").show_popup()<CR>", "HIDDEN" }
        })
      end
    end
  end,
})

-- Fixes Autocomment
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")

autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Highlight Yanked Text
api.nvim_create_augroup("Highlight", { clear = true })
autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank({higroup='IncSearch', timeout=1500, on_visual = true})",
  group = "Highlight",
  desc = "Highlight yanked text",
})

autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

autocmd({ "BufAdd", "BufEnter" }, {
  callback = function(args)
    if vim.t.bufs == nil then
      vim.t.bufs = { args.buf }
    else
      local bufs = vim.t.bufs
      if not vim.tbl_contains(bufs, args.buf) and (args.event == "BufAdd" or vim.bo[args.buf].buflisted) then
        table.insert(bufs, args.buf)
        vim.t.bufs = bufs
      end
    end
  end,
})

autocmd("BufDelete", {
  callback = function(args)
    for _, tab in ipairs(api.nvim_list_tabpages()) do
      local bufs = vim.t[tab].bufs
      if bufs then
        for i, bufnr in ipairs(bufs) do
          if bufnr == args.buf then
            table.remove(bufs, i)
            vim.t[tab].bufs = bufs
            break
          end
        end
      end
    end
  end,
})

autocmd("User", {
  pattern = "AlphaReady",
  desc = "disable tabline for alpha",
  callback = function()
    vim.opt.showtabline = 0
  end,
})
autocmd("BufUnload", {
  buffer = 0,
  desc = "enable tabline after alpha",
  callback = function()
    vim.opt.showtabline = 2
  end,
})

-- need bufdelete.nvim & alpha-dashboard
local alpha_on_empty = api.nvim_create_augroup("alpha_on_empty", { clear = true })
api.nvim_create_autocmd("User", {
  pattern = "BDeletePost*",
  group = alpha_on_empty,
  callback = function(event)
    local fallback_name = api.nvim_buf_get_name(event.buf)
    local fallback_ft = api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""

    if fallback_on_empty then
      -- if using neo-tree: require("neo-tree").close_all()
      cmd("Alpha")
      cmd(event.buf .. "bwipeout")
    end
  end,
})
