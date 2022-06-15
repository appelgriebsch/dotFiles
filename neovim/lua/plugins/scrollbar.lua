local status_ok, scrollview = pcall(require, "scrollview")
if not status_ok then
  return
end

scrollview.setup({
  excluded_filetypes = { "nerdtree", "dashboard", "alpha" },
  current_only = true,
  winblend = 75,
})
