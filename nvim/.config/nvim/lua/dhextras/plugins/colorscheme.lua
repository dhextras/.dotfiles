return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'

      local colors = {
        bg      = "#1e1e2e",
        fg      = "#d4be98",
        blue    = "#7da6ff",
        orange  = "#e0a774", -- softer orange than main theme
        dorange = "#db8a42", -- softer orange than main theme
        yellow  = "#f9e2af",
        red     = "#d75f6d", -- darker red than main theme
        purple  = "#cba6f7",
        green   = "#9ece6a",
        gray1   = "#282838",
        gray2   = "#393950",
        gray3   = "#bbbbbb",
        gray4   = "#eeeeee",
        gray5   = "#565f89",
        cyan    = "#008899",
      }

      vim.cmd.hi 'Comment gui=italic'

      -- Background
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

      -- Cursor line
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.gray1 })
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.dorange, bold = true })

      -- Visual selection
      vim.api.nvim_set_hl(0, 'Visual', { bg = colors.gray2 })

      -- Syntax
      vim.api.nvim_set_hl(0, 'Comment', { fg = colors.gray5 })
      vim.api.nvim_set_hl(0, 'Function', { fg = colors.blue })
      vim.api.nvim_set_hl(0, 'Keyword', { fg = colors.purple, bold = true })
      vim.api.nvim_set_hl(0, 'Type', { fg = colors.cyan })
      vim.api.nvim_set_hl(0, 'String', { fg = colors.green })
      vim.api.nvim_set_hl(0, 'Number', { fg = colors.dorange })
      vim.api.nvim_set_hl(0, 'Constant', { fg = colors.dorange })
      vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.cyan })

      -- UI
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = colors.blue })
      vim.api.nvim_set_hl(0, 'WinBar', { fg = colors.orange, bg = 'none' })
      vim.api.nvim_set_hl(0, 'WinBarNC', { fg = colors.blue, bg = 'none' })
      vim.api.nvim_set_hl(0, 'Directory', { fg = colors.blue })
      vim.api.nvim_set_hl(0, 'Title', { fg = colors.orange, bold = true })
      vim.api.nvim_set_hl(0, 'PmenuSel', { bg = colors.gray2, fg = colors.fg })
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = colors.bg, fg = colors.fg })

      -- LSP/Diagnostics
      vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = colors.red })
      vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = colors.orange })
      vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = colors.blue })
      vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = colors.green })
    end,
  },
}
