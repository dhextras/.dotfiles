return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      -- Prevent the current line from being highlighted
      scope = {
        enabled = true, -- Keep the scope enabled
        show_start = false, -- Disable the horizontal line
        show_end = false, -- Disable the horizontal line at the end (if applicable)
      },
    },
  },
}
