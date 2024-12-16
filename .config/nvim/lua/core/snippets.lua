-- snippets.lua
local ls = require("luasnip")

ls.add_snippets("tex", {
  ls.parser.parse_snippet("node", [[
%--------------------------
\begin{tikzpicture}
\node [mybox] (box){%
\begin{minipage}{0.45\textwidth}
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
  ls.parser.parse_snippet("text", [[
  $\,\text{}\,$
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

ls.add_snippets("java", {
  ls.parser.parse_snippet("transaction", [[ 
Transaction transaction = null;
Session session = hibernate.getSession();
try {
    transaction = session.beginTransaction();
    

    transaction.commit();
    return true;
} catch (Exception e) {
    transaction.rollback();
    return false;
} finally {
    session.close();
}
]])
})

ls.add_snippets("java", {
  ls.parser.parse_snippet("javadoc", [[ 
/** Represents a class.
 * @author Yu Qing Liu
 * @author yu.qing.liu@mail.mcgill.ca
 * @version 1.0
 * @since 1.0
*/
]])
})
