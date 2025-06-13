return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      ocal colors = {
        bg     = "#1e1e2e",
        fg     = "#d4be98",
        blue   = "#7da6ff",
        orange = "#fab387",
        yellow = "#f9e2af",
        red    = "#f38ba8",
        green  = "#a6e3a1",
        gray1  = "#222222",
        gray2  = "#444444",
        gray3  = "#bbbbbb",
        gray4  = "#eeeeee",
        cyan   = "#005577",
      }

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'

      -- Set a transparent background
      vim.api.nvim_set_hl(0, 'Normal',      { bg = 'none', fg = colors.fg })
      vim.api.nvim_set_hl(0, 'NormalNC',    { bg = 'none', fg = colors.fg })
      vim.api.nvim_set_hl(0, 'SignColumn',  { bg = 'none' })
      vim.api.nvim_set_hl(0, 'CursorLine',  { bg = colors.gray1 })
      vim.api.nvim_set_hl(0, 'CursorLineNr',{ fg = colors.blue, bold = true })
      vim.api.nvim_set_hl(0, 'Visual',      { bg = colors.gray2 })
      vim.api.nvim_set_hl(0, 'Comment',     { fg = colors.gray3, italic = true })
      vim.api.nvim_set_hl(0, 'Function',    { fg = colors.green })
      vim.api.nvim_set_hl(0, 'Keyword',     { fg = colors.red })
      vim.api.nvim_set_hl(0, 'Type',        { fg = colors.yellow })
      vim.api.nvim_set_hl(0, 'String',      { fg = colors.orange })
      vim.api.nvim_set_hl(0, 'Number',      { fg = colors.blue })
      vim.api.nvim_set_hl(0, 'WinSeparator',{ fg = colors.blue })
      vim.api.nvim_set_hl(0, 'WinBar',      { fg = colors.orange, bg = 'none' })
      vim.api.nvim_set_hl(0, 'WinBarNC',    { fg = colors.blue, bg = 'none' })
    end,
  },
}
