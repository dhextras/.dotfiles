local utils = require 'dhextras.funcs.utils'

local M = {}

-- Validate JSON content
local validate_json = function(decoded_content)
  if not decoded_content or type(decoded_content) ~= 'table' or not decoded_content.macros or type(decoded_content.macros) ~= 'table' then
    return false
  end

  for _, macro in ipairs(decoded_content.macros) do
    if type(macro) ~= 'table' or type(macro.reg) ~= 'string' or macro.reg == '' or type(macro.content) ~= 'string' or macro.content == '' then
      return false
    end
  end

  return true
end

-- Pretty print JSON content using jq
local pretty_print_json = function(data)
  local json_str = vim.fn.json_encode(data)

  if vim.fn.executable 'jq' == 0 then
    local cmd = 'echo ' .. vim.fn.shellescape(json_str) .. ' | jq --monochrome-output'
    return vim.fn.system(cmd)
  else
    utils.notify "jq is not installed on the machine, defaults to 'none'."
    return json_str
  end
end

-- Get the most recent backup file
local get_latest_backup = function(backup_dir)
  local process = io.popen('ls -t "' .. backup_dir .. '"')

  if process then
    local latest_backup = process:read '*l'
    process:close()
    return latest_backup and backup_dir .. '/' .. latest_backup
  else
    return nil
  end
end

-- Restore from the most recent backup
local restore_from_backup = function(backup_file, original_file)
  if not backup_file or original_file then
    return false
  end

  local cmd = "cp -f '" .. backup_file .. "' '" .. original_file .. "'"
  return os.execute(cmd) == 0
end

-- Clean old backup so that we don't fill the storage
local cleanup_old_backups = function(backup_dir, keep_last_no)
  local process = io.popen("ls -t '" .. backup_dir .. "'")

  if not process then
    return nil
  end

  local backups = {}
  for filename in process:lines() do
    table.insert(backups, filename)
  end
  process:close()

  for i = keep_last_no + 1, #backups do
    local backup_to_delete = backup_dir .. '/' .. backups[i]
    os.remove(backup_to_delete)
  end
end

-- Handle JSON file read and write (r, w)
M.handle_json_file = function(json_file_path, mode, data)
  if not json_file_path or json_file_path == '' then
    utils.notify('Invalid JSON file path.', 'error')
    return mode == 'r' and { macros = {} } or nil
  end

  local file_path = json_file_path
  local backup_dir = vim.fn.stdpath 'data' .. '/dhextras-funcs/load_regs/backups'
  vim.fn.mkdir(backup_dir, 'p')

  if mode == 'r' then
    local file = io.open(file_path, 'r')
    if not file then
      local latest_backup = get_latest_backup(backup_dir)
      if latest_backup then
        if restore_from_backup(latest_backup, file_path) then
          utils.notify 'No JSON found. Restored from the most recent backup.'
          file = io.open(file_path, 'r')
        end
      else
        utils.notify('No JSON found. Creating new file: ' .. file_path)
        file = io.open(file_path, 'w')
        if file then
          local content = vim.fn.json_encode { macros = {} }
          file:write(content)
          file:close()
          return { macros = {} }
        else
          utils.notify('Failed to create new file: ' .. file_path, 'error')
          return nil
        end
      end
    end

    if file then
      local content = file:read '*a'
      file:close()

      if not content or content == '' then
        local latest_backup = get_latest_backup(backup_dir)
        if latest_backup then
          if restore_from_backup(latest_backup, file_path) then
            utils.notify('File is empty. Restored from most recent backup.', 'error')
            return M.handle_json_file(json_file_path, mode, data)
          end
        else
          utils.notify('File is empty. Initializing with default structure.', 'error')
          return { macros = {} }
        end
      end

      if content then
        local status, decoded_content = pcall(vim.fn.json_decode, content)
        if status and validate_json(decoded_content) then
          return decoded_content
        else
          utils.notify('Invalid JSON content. Attempting to restore from backup.', 'error')
          local latest_backup = get_latest_backup(backup_dir)
          if latest_backup and restore_from_backup(latest_backup, file_path) then
            utils.notify 'Successfully restored from backup.'
            return M.handle_json_file(json_file_path, mode, data)
          else
            utils.notify('Failed to restore from backup. Manual check required.', 'error')
            return nil
          end
        end
      end
    end
  elseif mode == 'w' then
    local backup_file_path = backup_dir .. '/' .. os.date '%Y%m%d%H%M%S' .. '_macros.json.bak'

    local file = io.open(file_path, 'w')
    if not file then
      utils.notify('Unable to write to the file.', 'error')
      return nil
    end

    local content = pretty_print_json(data)
    file:write(content)
    file:close()

    os.execute("cp -f '" .. file_path .. "' '" .. backup_file_path .. "'")
    cleanup_old_backups(backup_dir, 10)
  else
    utils.notify("Invalid mode: '" .. mode .. "'. Use 'r' or 'w'.", 'error')
  end
end

return M
