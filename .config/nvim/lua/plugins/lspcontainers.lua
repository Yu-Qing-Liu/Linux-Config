-- Lsp in docker
return {
  -- https://github.com/lspcontainers/lspcontainers.nvim
  'lspcontainers/lspcontainers.nvim',
  version = "*",
  dependencies = {
    "neovim/nvim-lspconfig"
  }
}
