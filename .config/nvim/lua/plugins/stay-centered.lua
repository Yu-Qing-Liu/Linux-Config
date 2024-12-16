-- Adds padding after end of file
return {
  --https://github.com/Aasim-A/scrollEOF.nvim
  'arnamak/stay-centered.nvim',
  opts = {
    -- The filetype is determined by the vim filetype, not the file extension. In order to get the filetype, open a file and run the command:
    -- :lua print(vim.bo.filetype)
    skip_filetypes = {},
    -- Set to false to disable by default
    enabled = true,
  },
  config = function (_, opts)
    require("stay-centered").setup(opts)
  end
}
