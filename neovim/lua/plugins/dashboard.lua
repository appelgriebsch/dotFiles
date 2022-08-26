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
dashboard.section.header.opts.hl = "StartifyHeader"

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("p", "  > Open project", ":Telescope project display_type=full<CR>"),
  dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  > Find file", ":cd $HOME/Projects | Telescope find_files<CR>"),
  dashboard.button("r", "  > Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | Telescope file_browser<CR>"),
  dashboard.button("u", "  > Update plugins", ":PackerSync<CR>"),
  dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

-- Set footer
local fortune = require("alpha.fortune")
dashboard.section.footer.val = fortune()

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
