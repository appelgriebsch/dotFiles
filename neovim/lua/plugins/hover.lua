local status_hover, hover = pcall(require, "hover")
if not status_hover then
  return
end

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
local status_menu, menu = pcall(require, "which-key")
if status_menu then
  menu.register({
    K = { "<CMD>lua require(\"hover\").hover()<CR>", "HIDDEN" }
  })
end
