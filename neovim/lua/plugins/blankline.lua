local status_blankline, blankline = pcall(require, "indent_blankline")
if not status_blankline then
  return
end

vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "alpha",
  "packer",
  "NvimTree",
}

blankline.setup {
  space_char_blankline = "·",
  show_current_context = true,
  show_current_context_start = true,
}
