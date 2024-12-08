-- Transparency
return {
  'xiyaowong/transparent.nvim',
  lazy = false,
  priority = 999,
  config = function(_)
    require('transparent')
  end
}
