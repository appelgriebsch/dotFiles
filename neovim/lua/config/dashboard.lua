vim.g.dashboard_enable_session = 0
vim.g.dashboard_disable_statusline = 0
vim.g.dashboard_default_executive = 'fzf'

vim.g.dashboard_custom_header = {
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}

vim.g.dashboard_custom_section = {
  find_history = {
    description = {'  Recently opened files                   SPC h'},
    command =  'FzfLua oldfiles'
  },
  find_file  = {
    description = {'  Find  File                              SPC f'},
    command = 'FzfLua files'
  },
  new_file = {
   description = {'  File Browser                            SPC r'},
   command =  'RnvimrToggle'
  },
  find_word = {
   description = {'  Find  word                              SPC s'},
   command = 'FzfLua live_grep'
  },
  find_marks = {
   description = {'  Find marks                              SPC m'},
   command = 'FzfLua marks'
  },
}