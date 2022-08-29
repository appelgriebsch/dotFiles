local status_nvimux, nvimux = pcall(require, "nvimux")
if not status_nvimux then
  return
end

nvimux.setup({
  config = {
    prefix = "<C-a>",
  },
  bindings = {
    { { "n", "v", "i", "t" }, "s", nvimux.commands.horizontal_split },
    { { "n", "v", "i", "t" }, "v", nvimux.commands.vertical_split },
  }
})
