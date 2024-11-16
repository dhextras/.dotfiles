local utils = require 'dhextras.funcs.utils'
local ts_builtin = require 'telescope.builtin'
local json = require 'dhextras.funcs.load_regs.json'
local base64 = require 'dhextras.funcs.load_regs.base64'

local M = {}
local json_file_path = vim.fn.stdpath 'data' .. '/dhextras-funcs/load_regs/macros.json'

-- Decode and set macro to register
M.set_decoded_macro_to_register = function(encoded_content, target_register)
  if not encoded_content or encoded_content == '' then
    utils.notify('Empty encoded content. Cannot set register `' .. target_register .. '`.', 'error')
    return
  end

  local decoded_content = base64.dec(encoded_content)
  if not decoded_content or decoded_content == '' then
    utils.notify('Failed to decode. Register `' .. target_register .. '` remains unchanged.', 'error')
    return
  end

  vim.fn.setreg(target_register, decoded_content)
end

--- Save selected macro to JSON with register
M.save_macro_from_register = function()
  -- Use Telescope's built-in register picker
  ts_builtin.registers {
    attach_mappings = function(prompt_bufnr, map)
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      -- Override selection to handle the register content
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if not selection then
          utils.notify('No register selected.', 'error')
          return
        end

        local register = selection.value and selection.value:lower()
        local valid_registers = '[a-z0-9]'

        if not register or not register:match('^' .. valid_registers .. '$') then
          utils.notify('Invalid register selection.', 'error')
          return
        end

        local register_content = selection.content
        if not register_content or register_content == '' then
          utils.notify('Register `' .. register .. '` is empty!', 'error')
          return
        end

        -- Load existing macros from the JSON file
        local macro_raw = base64.enc(register_content)
        local macros = json.handle_json_file(json_file_path, 'r')
        if macros then
          local macro_exists = false
          for _, macro in ipairs(macros.macros) do
            if macro.reg == register then
              macro.content = macro_raw
              macro_exists = true
              break
            end
          end
          if not macro_exists then
            table.insert(macros.macros, { reg = register, content = macro_raw })
          end
          json.handle_json_file(json_file_path, 'w', macros)
          utils.notify('Macro for register `' .. register .. '` saved.')
        else
          utils.notify('Failed to load macros file.', 'error')
        end
      end)

      return true
    end,
  }
end

--- Save all available macros to JSON with their registers
M.save_all_available_macros = function()
  local list_all_regs = {
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  }

  local saved_count = 0
  local macros = json.handle_json_file(json_file_path, 'r') or { macros = {} }

  for _, reg in ipairs(list_all_regs) do
    local register_content = vim.fn.getreg(reg)

    if register_content and register_content ~= '' then
      local macro_raw = base64.enc(register_content)

      local exists = false
      for i, macro in ipairs(macros.macros) do
        if macro.reg == reg then
          macros.macros[i].content = macro_raw
          exists = true
          break
        end
      end

      if not exists then
        table.insert(macros.macros, {
          reg = reg,
          content = macro_raw,
        })
      end

      saved_count = saved_count + 1
    end
  end

  if saved_count > 0 then
    json.handle_json_file(json_file_path, 'w', macros)
    utils.notify(string.format('Saved %d macros to JSON file', saved_count))
  else
    utils.notify('No non-empty registers found', 'warn')
  end
end

-- Load all the saved macros from the JSON file and set them into registers
M.load_macros_to_registers = function()
  local macros_data = json.handle_json_file(json_file_path, 'r')
  if not macros_data or not macros_data.macros or #macros_data.macros == 0 then
    utils.notify('No macros found in the JSON file.', 'error')
    return
  end

  for _, macro in ipairs(macros_data.macros) do
    if macro.reg and macro.content then
      M.set_decoded_macro_to_register(macro.content, macro.reg)
    end
  end

  utils.notify('All macros have been loaded into their respective registers.', 'info')
end

return M
