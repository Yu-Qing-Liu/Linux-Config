-- LaTeX
return {
  -- https://github.com/lervag/vimtex  
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_compiler_latexmk = {
      options = {
        '-interaction=nonstopmode',  -- Run LaTeX in nonstop mode
        '-file-line-error',          -- Enable file:line:error style messages
        '-synctex=1',                -- Enable synctex for forward search
        '-shell-escape',             -- Enable shell escape for certain packages
        '-halt-on-error',            -- Halt on error
        '-quiet',                    -- Quiet mode, suppress warnings
      }
    }
    vim.g.vimtex_view_method = "zathura"
  end
}
