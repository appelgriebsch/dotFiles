require("bufferline").setup({
  options = {
    show_close_icon = true,
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    separator_style = "thin",
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and "  " or (e == "warning" and "  " or "  ")
        s = s .. sym .. n
      end
      return s
    end,
    custom_filter = function(buf_number)
      if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
        return true
      end
    end
  },
})
