-- Tab management
return {
  --https://github.com/Aasim-A/scrollEOF.nvim
  'nanozuki/tabby.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {},
  config = function (_, opts)
    require("tabby").setup(opts)
  end
}
