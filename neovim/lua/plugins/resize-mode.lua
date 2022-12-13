local status_resize, resize = pcall(require, "resize-mode")
if not status_resize then
  return
end

resize.setup ({
  horizontal_amount = 9,
  vertical_amount = 5,
  quit_key = "<ESC>",
  enable_mapping = true
})