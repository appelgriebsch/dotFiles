local status_hover, hover = pcall(require, "hover")
if not status_hover then
  return
end

local keymap = require("utils.keymaps")

hover.setup {
  init = function()
    -- Require providers
    require("hover.providers.lsp")
    require('hover.providers.gh')
    -- require('hover.providers.gh_user')
    -- require('hover.providers.jira')
    require('hover.providers.man')
    require('hover.providers.dictionary')
  end,
  preview_opts = {
    border = "rounded",
  },
  -- Whether the contents of a currently open hover window should be moved
  -- to a :h preview-window when pressing the hover keymap.
  preview_window = false,
  title = true
}

-- Setup keymaps
vim.keymap.set("n", "K", "<CMD>lua require(\"hover\").hover<CR>", keymap.map_global("HIDDEN"))
