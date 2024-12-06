-- View bufferline
return {
  -- https://github.com/nvim-tree/nvim-tree.lua
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-tree.lua',
    'nvim-tree/nvim-web-devicons'
  },
  opts = {
    options = {
      separator_style = {'',''},
      always_show_bufferline = true,
      enforce_regular_tabs = true,
      indicator = {
        style = 'none'
      },
      themable = true,
      color_icons = true,
    }
  },
  config = function(_, opts)
    require('bufferline').setup(opts)
  end
}
