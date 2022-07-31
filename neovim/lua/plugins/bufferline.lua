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
    always_show_bufferline = true,
    color_icons = false,
    sort_by = "directory",
    diagnostics = "nvim_lsp",
    highlights = {
      buffer_selected = {
        gui = "none"
      },
      diagnostic_selected = {
        gui = "none"
      },
    },
    custom_filter = function(buf_number)
      if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
        return true
      end
    end,
    custom_areas = {
      right = function()
        local result = {}
        local seve = vim.diagnostic.severity
        local error = #vim.diagnostic.get(0, {severity = seve.ERROR})
        local warning = #vim.diagnostic.get(0, {severity = seve.WARN})
        local info = #vim.diagnostic.get(0, {severity = seve.INFO})
        local hint = #vim.diagnostic.get(0, {severity = seve.HINT})

        if error ~= 0 then
          table.insert(result, { text = "  " .. error, guifg = "#E06C75" })
        end

        if warning ~= 0 then
          table.insert(result, { text = "  " .. warning, guifg = "#E5C07B" })
        end

        if hint ~= 0 then
          table.insert(result, { text = "  " .. hint, guifg = "#61AFEF" })
        end

        if info ~= 0 then
          table.insert(result, { text = "  " .. info, guifg = "#61AFEF" })
        end
        return result
      end,
    }
  },
})
