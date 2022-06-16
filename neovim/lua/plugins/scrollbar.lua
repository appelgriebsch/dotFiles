local status_scrollbar, scrollview = pcall(require, "scrollview")
if not status_scrollbar then
  return
end

scrollview.setup({
  excluded_filetypes = { "nerdtree", "dashboard", "alpha" },
  current_only = true,
  winblend = 75,
})
