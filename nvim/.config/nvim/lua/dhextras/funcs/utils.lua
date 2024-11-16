local M = {}

-- Print message
M.notify = function(msg, level)
  if not level then
    level = 'info'
  end
  vim.notify('[dhextras-funcs] - ' .. msg, vim.log.levels[level:upper()], { title = 'dhextras-funcs' })
end

return M
