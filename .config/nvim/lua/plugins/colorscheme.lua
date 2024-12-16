-- Theme/Colorscheme (uncomment section for whichever theme you prefer or use your own)
return {
  -- https://github.com/rebelot/kanagawa.nvim
  'rebelot/kanagawa.nvim', -- You can replace this with your favorite colorscheme
  lazy = false,            -- We want the colorscheme to load immediately when starting Neovim
  priority = 1000,         -- Load the colorscheme before other non-lazy-loaded plugins
  opts = {
    transparent = true,
    colors = {
      theme = {
        all = {
          ui = { bg_gutter = 'none' },
        }
      }
    }
  },
  config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.o.background = "dark"
    vim.cmd("colorscheme kanagawa-wave")
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#273638' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = 'orange', bold = true, underline = false, bg = '#273638' })
  end
}
