
## Normalization

In order to compile down to sequential code, it is imperative
to extract stateful computations that appear inside expressions.

The normalizer's behavior is quite simple. Its operation are twofold.

Firstly, it separates pattern equations into simple ones.
One should not make the misatke to expect that a pattern on
the right hand side of the equation signifies the presence of
a pattern equation. Indeed, node calls can have several return
values.

\side
\include ../tests/correct/norm_pattern.sap
\middle_side
node dup(x : int) ->
  (x : int, x : int) with

node pattern(x : int) -> (x : int) with
  a = 1;
  b = 2;
  (x, y) = @dup(1)
\end_side

Merges are tricky. Indeed, the demultiplexer must
get all flows, and duplicate them in order to demultiplex
the expressions insides of flows.

\side
\include ../tests/correct/complex_demux.sap
\middle_side
node complex_demux(a : int) -> (x : int) with
  a = 2;
  b = 3;
  c = 4;
  (x, y) = @dup(a, b);
  f = True;
  d = merge f(True -> 2)
  (False -> 4);
  e = merge f(True -> 3)
  (False -> 5)
\end_side

Its other action is to extract stateful computations - that is to say
`fby` expressions. For each `fby` expression present in the
equation list, the normalizer creates a new one based on a fresh id.

\side
\include ../tests/correct/simple_fby_extract.sap
\middle_side
node id(x : int) -> (x : int) with

node simple_fby(a : int) -> (x : int) with
t2 = 1 fby 2;
t1 = 2 fby 3;
x = @id(t1);
y = t2;
\end_side

Here is a more recursive example.

\side
\include ../tests/correct/complex_normal.sap
\middle_side
node normal(a : int) -> (x : int) with
  t1 = 8 fby 1;
  z = True;
  a = 2;
  b = 3;
  c = merge z (True -> 4) (False -> 6);
  d = merge z(True -> 5) (False -> t1)
\end_side

It should be noted that term extraction can cause harm when
the code is rescheduled after.

\side
\include ../tests/correct/fibo.sap
\middle_side
node fibonacci() -> (fib : int) with
  fib = t2;
  n = t1;
  t1 = 1 fby plus(n, 1);
  t2 = 0 fby n
\end_side

Indeed, fib is now calculated before t2 is updated. To remedy
that problem, when an output variable is extracted-on, we rename
the output variable into the newly generated id.

\side
\include ../tests/correct/fibo.sap
\middle_side
node fibonacci() -> (t1 : int) with
  fib = t2;
  n = t1;
  t1 = 1 fby plus(n, 1);
  t2 = 0 fby n
\end_side

After the extraction, terms and equations should be characterized by the 
grammar described in figure \ref{NsapGrammar}.

\include nsap/nsap_grammar.tex

\