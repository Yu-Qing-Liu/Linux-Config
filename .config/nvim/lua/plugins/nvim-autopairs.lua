-- Auto-completion of bracket/paren/quote pairs
return {
  -- https://github.com/windwp/nvim-autopairs
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  opts = {
    check_ts = true, -- enable treesitter
    ts_config = {
      lua = { "string" }, -- don't add pairs in lua string treesitter nodes
      javascript = { "template_string" }, -- don't add pairs in javascript template_string
    }
  },
  config = function(_, opts)
    local npairs = require('nvim-autopairs')
    npairs.setup(opts)

    -- Add rule for $$
    local Rule = require('nvim-autopairs.rule')
    npairs.add_rules({
      Rule("$", "$", "tex") -- Adds $$ pair for tex files
---@diagnostic disable-next-line: redefined-local
        :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return pair ~= "$$" -- Avoid auto-inserting multiple $
        end),
    })
  end
}
