local status_notify, notify = pcall(require, "notify")
if not status_notify then
  return
end

notify.setup({
  -- Animation style (see below for details)
  stages = "fade_in_slide_out",

  -- Default timeout for notifications
  timeout = 5000,

  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
  background_colour = "Normal",

  -- Icons for the different levels
  -- diagnostic_signs = {" ", " ", " ", " "}
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "",
  },
})

vim.notify = notify
