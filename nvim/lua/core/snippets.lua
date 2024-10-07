-- snippets.lua
local ls = require("luasnip")

ls.add_snippets("tex", {
  ls.parser.parse_snippet("node", [[
%--------------------------
\begin{tikzpicture}
\node [mybox] (box){%
\begin{minipage}{0.3\textwidth}
\end{minipage}
};
\node[fancytitle, right=10pt] at (box.north west) {};
\end{tikzpicture}
]])
})

ls.add_snippets("tex", {
  ls.parser.parse_snippet("right", [[
  $\rightarrow$
]])
})

ls.add_snippets("tex", {
  ls.parser.parse_snippet("Right", [[
  $\Rightarrow$
]])
})

ls.add_snippets("tex", {
  ls.parser.parse_snippet("\\right", [[
  \rightarrow
]])
})

ls.add_snippets("tex", {
  ls.parser.parse_snippet("\\Right", [[
  \Rightarrow
]])
})
