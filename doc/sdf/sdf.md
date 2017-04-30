
# Synchronous Data Flow

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
\newpage

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

Following is a representation of the `calc` node.

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

## Delays

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

Finally, following is an edge detector.

\code
\end_code