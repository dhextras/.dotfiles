-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Toggle undo tree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndo tree' })

-- Open workspace explorer
vim.keymap.set('n', '<leader>we', vim.cmd.Ex, { desc = '[W]orkplace [E]xplorer' })

-- Load and save registers ( load_regs funcs )
vim.keymap.set('n', '<leader>lrs', function()
  local load_reg = require 'dhextras.funcs.load_regs'
  load_reg.save_macro_from_register()
end, { desc = '[L]oad [R]egs - [S]ave register' })

vim.keymap.set('n', '<leader>lra', function()
  local load_reg = require 'dhextras.funcs.load_regs'
  load_reg.save_all_available_macros()
end, { desc = '[L]oad [R]egs - Save [A]ll registers' })

vim.keymap.set('n', '<leader>lrl', function()
  local load_reg = require 'dhextras.funcs.load_regs'
  load_reg.load_macros_to_registers()
end, { desc = '[L]oad [R]egs - [L]oad saved registers' })

-- Key maps to move around quickfix list
vim.keymap.set('n', '<C-c><C-n>', function()
  local qf = vim.fn.getqflist()
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  if idx == #qf then
    vim.cmd 'cfirst' -- Wrap to first item
  else
    vim.cmd 'cnext'
  end
end, { noremap = true, silent = true, desc = 'Quick fix - [C][N]ext' })

vim.keymap.set('n', '<C-c><C-p>', function()
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  if idx == 1 then
    vim.cmd 'clast' -- Wrap to last item
  else
    vim.cmd 'cprev'
  end
end, { noremap = true, silent = true, desc = 'Quick fix - [C][P]rev' })
