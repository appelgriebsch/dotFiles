local status_resize_mode, resize_mode = pcall(require, "resize-mode")
if not status_resize_mode then
  return
end

resize_mode.setup({
  horizontal_amount = 9,
  vertical_amount = 5,
  quit_key = "<ENTER>",
  enable_mapping = true,
  resize_keys = {
    "h", -- increase to the left
    "j", -- increase to the bottom
    "k", -- increase to the top
    "l", -- increase to the right
    "H", -- decrease to the left
    "J", -- decrease to the bottom
    "K", -- decrease to the top
    "L" -- decrease to the right
  },
})
