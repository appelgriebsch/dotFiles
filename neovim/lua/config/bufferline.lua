require("bufferline").setup({
  options = {
    always_show_bufferline = true,
    show_close_icon = false,
    show_buffer_close_icons = false,
    separator_style = "thin",
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and "  " or (e == "warning" and "  " or "  ")
        s = s .. sym .. n
      end
      return s
    end,
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
