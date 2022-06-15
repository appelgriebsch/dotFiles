local status_ok, command_center = pcall(require, "command_center")
if status_ok then
  command_center.add({
    {
      category = "help",
      description = "Dash: Search word",
      cmd = "<CMD>DashWord<CR>",
    },
    {
      category = "help",
      description = "Dash: Search",
      cmd = "<CMD>Dash<CR>",
    },
  })
end
