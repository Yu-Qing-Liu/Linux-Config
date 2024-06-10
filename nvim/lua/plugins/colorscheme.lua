-- Theme/Colorscheme (uncomment section for whichever theme you prefer or use your own)
-- Gruvbox
return {
  -- https://github.com/rebelot/kanagawa.nvim
  'ellisonleao/gruvbox.nvim', -- You can replace this with your favorite colorscheme
  lazy = false, -- We want the colorscheme to load immediately when starting Neovim
  priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
  opts = {
    transparent_mode = true,
  },
  config = function(_, opts)
    require('gruvbox').setup(opts) -- Replace this with your favorite colorscheme
    vim.o.background = "dark"
    vim.cmd("colorscheme gruvbox") -- Replace this with your favorite colorscheme
     -- Custom diff colors
    vim.cmd([[
      autocmd VimEnter * hi DiffAdd guifg=#00FF00 guibg=#005500
      autocmd VimEnter * hi DiffDelete guifg=#FF0000 guibg=#550000
      autocmd VimEnter * hi DiffChange guifg=#CCCCCC guibg=#555555
      autocmd VimEnter * hi DiffText guifg=#00FF00 guibg=#005500
    ]])

    -- Custom border colors
    vim.cmd([[
      autocmd ColorScheme * hi NormalFloat guifg=#F9E7C0 guibg=#1F1F1F
      autocmd ColorScheme * hi FloatBorder guifg=#F9E7C0 guibg=#1F1F1F
    ]])
  end
}
