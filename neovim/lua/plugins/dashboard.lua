local status_dashboard, alpha = pcall(require, "alpha")
if not status_dashboard then
  return
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "                                                          ",
  "  ███╗   ██╗ ███████╗  ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗ ",
  "  ████╗  ██║ ██╔════╝ ██╔═══██╗ ██║   ██║ ██║ ████╗ ████║ ",
  "  ██╔██╗ ██║ █████╗   ██║   ██║ ██║   ██║ ██║ ██╔████╔██║ ",
  "  ██║╚██╗██║ ██╔══╝   ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║ ",
  "  ██║ ╚████║ ███████╗ ╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝ ╚══════╝  ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝ ",
  "                                                          ",
}

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("p", "  > Open project", "<CMD>Telescope project display_type=full<CR>"),
  dashboard.button("e", "  > New file", "<CMD>ene <BAR> startinsert<CR>"),
  dashboard.button("f", "  > Find file", "<CMD>cd $HOME/Projects | Telescope find_files<CR>"),
  dashboard.button("l", "  > LSP Servers", "<CMD>Mason<CR>"),
  dashboard.button("r", "  > Recent files", "<CMD>Telescope oldfiles<CR>"),
  dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | Telescope file_browser<CR>"),
  dashboard.button("u", "  > Update plugins", "<CMD>PackerSync<CR>"),
  dashboard.button("q", "  > Quit NVIM", "<CMD>qa<CR>"),
}

-- Set footer
local fortune = require("alpha.fortune")
dashboard.section.footer.val = fortune()

dashboard.config.opts.setup = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    desc = "disable tabline for alpha",
    callback = function()
      vim.opt.showtabline = 0
    end,
  })
  vim.api.nvim_create_autocmd("BufUnload", {
    buffer = 0,
    desc = "enable tabline after alpha",
    callback = function()
      vim.opt.showtabline = 2
    end,
  })
end

-- Send config to alpha
alpha.setup(dashboard.config)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
