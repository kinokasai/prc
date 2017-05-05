
<!--# Synchronous Data Flow

Formally, a stream is composed of both a function
`f : Stream(T) -> Stream(T')` and a stream equation `y = f(x)`.
Given those, the code generation produces a pair `(f', s')`
made of a transition function `f'` of type `S -> T -> T' x S` and an initial
state `s'`.
The transition function takes a state and the current input, and it
returns the current output with a new state.
Its infinite repetition produces the sequence of outputs.


In actual implementations, the transition
function is written in imperative style with in-place modification
of the state. Synchrony finds a very practical justification here:
an infinite stream of type `Stream(T)` is represented by a scalar
value of type `T` and no intermediate memory nor complex buffering
mechanism is needed. These principles are generalized to functions
with multiple inputs and multiple outputs.

----

But we don't care about that 'cause it's taken from Pouzet's paper.
\newpage-->

# SAP

## Dataflow programming 

We can think of dataflow programming as a network. For example,
the following diagram shows the dataflow representation of the
expression \newline `(1 + x) * y + (1 + x) * z`:

\begin{figure}[h]
\centering
\begin{BVerbatim}
1 --->-----+           +---<--- y
           |           |
x ---->---[+]---->----[*]---->----[+]---->--
           |                       |
           |                       |
           +----->----[*]---->-----+
                       |
         z ------->----+
\end{BVerbatim}
\caption{A network}
\end{figure}

\lstset{language=Javascript}

The flow of data in the network resembles the flow of water in pipes.
The nodes in the network are processing stations of data, which correspond
to functions in the program. These processing stations can work in parallel.
This is another benefit of the dataflow model.

In SAP, the aforementioned network is defined by a set of equations.

\code
a = plus(1, x);
b = times(a, y);
c = times(a, z);
d = plus(b, c)
\end_code

However, such a program - in order to be called - must be comprised in
a node. Nodes specify input and output variables, which makes them similar
to functions in traditional programming languages.

\code
node calc(x : int, y : int, z : int)  -> (d : int) with
  a = plus(1, x);
  b = times(a, y);
  c = times(a, z);
  d = plus(b, c)
\end_code

As such, _every_ data is a flow. A variable `x` means an infinite
sequence of `x1, x2, x3, ...` and the constant `1` means an infinite
sequence of ones.

Another reprentation is through a chronogram of the program's execution,
showing the sequence of values taken by streams during the execution.

Each line shows the evolution of the corresponding stream.
The `...` notation indicates that the stream has more values - it is infinite -
not represented here.

Following is a chonogram representation of the `calc` node.

\begin{table}[h]
\centering
\begin{tabular}{|l|l|l|l|l|}
\hline
x & 0 & 0 & 1 & ...\\ \hline
y & 0 & 1 & 1 & ...\\ \hline
z & 0 & 0 & 1 & ...\\ \hline
a & 1 & 1 & 2 & ... \\ \hline
b & 0 & 1 & 2 & ... \\ \hline
c & 0 & 0 & 2 & ... \\ \hline
d & 1 & 1 & 4 & ... \\ \hline
plus(d, d) & 2 & 2 & 8 & ... \\ \hline
\end{tabular}
\caption{Calc node Chronogram}
\end{table}

### Delays

It is possible to operate on a sequence's history.
`fby` is such an operator. The expression `v fby x`
returns a new sequence by prepending the sequence x
with the value `v`. Such a contraptions allows us to
create *memories*. Following is a counter node.

\code
node counter() -> (x : int) with
  x = 0 fby plus(x, 1)
\end_code

At each iteration, the stream x will have its value increased
by one.
\begin{table}[h]
\centering
\begin{tabular}{|l|l|l|l|l|l|l|l|}
\hline
x & 0 & 1 & 2 & 3 & 4 & 5 & ... \\ \hline
\end{tabular}
\caption{Counter node Chronogram}
\end{table}

Constructing on this, we can create the famous fibonacci sequence.

\code
\include ../tests/correct/fibo.sap
\end_code

\begin{table}[h]
\centering
\begin{tabular}{|l|l|l|l|l|l|l|l|}
\hline
n & 1 & 2 & 3 & 5 & 8 & 13 & ... \\ \hline
fib & 0 & 1 & 2 & 3 & 5 & 8 & ... \\ \hline
\end{tabular}
\caption{Fibonacci Chronogram}
\end{table}

Finally, following is a program detecting the edges of a boolean stream.

\code
\include ../tests/correct/edge.sap
\end_code

\begin{table}[h]
\centering
\begin{tabular}{|l|l|l|l|l|l|l|l|}
\hline
c                 & f & f & t & t & f & t & ... \\ \hline
false             & f & f & f & f & f & f & ... \\ \hline
false fby c       & f & f & f & t & t & f & ... \\ \hline
not (false fby c) & t & t & t & f & f & t & ... \\ \hline
@edge(c)          & f & f & t & f & f & t & ... \\ \hline
\end{tabular}
\caption{Edge Chronogram}
\end{table}

### Synchrony

We haven't yet touched on what makes this language
a *synchronous* dataflow language. The basic notion
is that each stream produces value at its own speed.
This is achieved through the use of *clocks*.
Clocks can be seen as another type information on streams.
They give some information about the time behavior of streams.

In the following chapter, we introduce a sampling operator as well
as a combination one. equation is on its own clock. The clock that is
always active is named `base`.

`when` is a sampler that allows fast processes to communicate with slower ones by
extracting sub-streams from streams according to a condition.

\code
\include ../tests/correct/when.sap
\end_code

\begin{table}[h]
\centering
\begin{tabular}{|l|l|l|l|l|l|l|}
\hline
b              & f & t & f & t & f & ... \\ \hline
y when True(b) &   & t &   & t &   & ... \\ \hline
\end{tabular}
\caption{Simple_when Chronogram}
\end{table}

In effect, SAP does not possesses a clock inference system as of now.
As such, it's on the programmer to give the correct clock information
in SAP programs. If no clock is specified, the `base` clock will be assumed
by the compiler.

Clocks annotation are of the form:

\begin{grammar}
<clock> ::= \verb|base|
\alt <clock> on $C$($id$)
\end{grammar}

Following is the `when` node with clock information added.

\code
\include ../tests/correct/when_clk.sap
\end_code

`base on True(c)` will be translated as a control structure by the compiler.
As such, the `simple_when` node will be translated somewhat similarly to the
following pseudo-code.

\code
a = 2;
if (b is True) {
  y = b
}
\end_code

The control translation can be approximated using pattern match syntax as:
\code
Control ck =
  match ck with
    | base -> true
    | Clock(clk, id, type) -> id is_of_type type and control(clk)
\end_code

`merge` conversely allows slow streams to converse with faster ones.
However, each combined stream has to be complementary. That is to say
that at any point in time, one stream at most must be producing a value.

\code
\include ../tests/correct/simple_clk.sap
\end_code

SAP also includes syntactic sugar on merge in the forms of `match`.
However, since our compiler lacks type inference, some classic features
of pattern matching like wildcards are not available. The following
clk node produces the exact same code as the one aforementioned.

\code
\include ../tests/correct/simple_clk_match.sap
\end_code

\begin{table}[h]
\centering
\begin{tabular}{|l|l|l|l|l|l|l|l|}
\hline
half & t & f & t & f & t & f & ... \\ \hline
y    & 3 &   & 3 &   & 3 &   & ... \\ \hline
x    &   & 2 &   & 2 &   & 2 & ... \\ \hline
a    & 3 & 2 & 3 & 2 & 3 & 2 & ... \\ \hline
\end{tabular}
\caption{Clock Chronogram}
\end{table}

We'll not enumerate all the clock constraints here. If needed, they can
be found in \cite{pouzet}.

While clocks are absolutely *needed* in order to produce working sequential
code, we'll omit them for clarity reasons in the rest of this report, unless
told otherwise.

#### Types

SAP programmers can create their own sum types.

\code
\include ../tests/correct/type_creation.sap
\end_code

Furthermore, we also support sum types with arguments, albeit
those are stricly used to interface with Javascript due to current
limitations of the compiler.
Sap programmers can only create variables with constant constructors.

\code
\include ../tests/correct/type_creation_interface.sap
\end_code

Following is the grammar of `SAP` programs:

\include sdf/sap_grammar.tex