local status_bufferline, bufferline = pcall(require, "bufferline")
if not status_bufferline then
  return
end

bufferline.setup({
  options = {
    numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    max_name_length = 30,
    max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
    tab_size = 21,
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = true,
    always_show_bufferline = false,
    color_icons = false,
    diagnostics = "nvim_lsp",
    highlights = {
      buffer_selected = {
        gui = "none"
      },
      diagnostic_selected = {
        gui = "none"
      },
    },
  },
})
