# Parsing

In order to build an Abstract Syntax Tree to be worked on,
we used the menhir \cite{menhir} parser generator in combination with
ocamllex. While ocamllex is pretty standard in the industry,
menhir is a recently developer `LR(1)` parser generator.

It's in this step that the `match` desugaring happens.

\side
\include ../tests/correct/simple_clk_match.sap
\middle_side
\include ../tests/correct/simple_clk.sap
\end_side