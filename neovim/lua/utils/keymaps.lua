local M = {}

function M.map_global(desc) return { silent = true, desc = desc } end
function M.map_local(desc) return { silent = true, buffer = true, desc = desc } end

return M