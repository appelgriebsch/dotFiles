local M = {}

-- Utility functions shared between progress reports for LSP and DAP
local client_notifs = {}

function M.get_notif_data(client_id, token)
  if not client_notifs[client_id] then
    client_notifs[client_id] = {}
  end

  if not client_notifs[client_id][token] then
    client_notifs[client_id][token] = {}
  end

  return client_notifs[client_id][token]
end

M.spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

function M.update_spinner(client_id, token)
  local notif_data = M.get_notif_data(client_id, token)
  if notif_data.spinner then
    local new_spinner = (notif_data.spinner + 1) % #M.spinner_frames
    notif_data.spinner = new_spinner
    notif_data.notification = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = M.spinner_frames[new_spinner],
      replace = notif_data.notification,
    })
    vim.defer_fn(function()
      M.update_spinner(client_id, token)
    end, 100)
  end
end

function M.format_title(title, client_name)
  return client_name .. (#title > 0 and ": " .. title or "")
end

function M.format_message(message, percentage)
  return (percentage and percentage .. "%\t" or "") .. (message or "")
end

return M
