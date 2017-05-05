---
title: Synchronous Retrogames in HTML5
author: Alexandre Doussot
place: Paris
institute: Université Pierre et Marie Curie
header-includes:
  - \usepackage{tikz}
  - \usepackage{listings}
  - \usepackage{color}
  - \usepackage{syntax}
  - \usepackage{fancyvrb}
  - \usepackage{booktabs}
---
# Introduction

## Context
  * Game programming
  * Speed is not that important
  * Reactive limitations by the canvas API
  * Hence control-command system
  * Synchronous Data Flow language


# The language

## DataFlow


\centering
(1 + x) * y + (1 + x) * z

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
\end{figure}

## SAP node - (1 + x) * y + (1 + x) * z

\code
node calc(x : int, y : int, z : int)  -> (d : int) with
  a = plus(1, x);
  b = times(a, y);
  c = times(a, z);
  d = plus(b, c)
\end_code

Each equation describes its own stream.

## Clocks

\code
\include ../tests/correct/simple_clk.sap
\end_code

## Algebraic Data Types

\code
\include ../tests/correct/type_creation_interface.sap
\end_code

# The compiler

## SMUDGE

* Multi-pass compiler
* Built with OCaml and Menhir

![](compiler/passes.png)\ 

## Normalization

1. Demux equations
2. Extract stateful computations

## Normalization - Demux

\side
\include ../tests/correct/complex_demux.sap
\middle_side
node complex_demux(a : int) -> (x : int) with
  a = 2;
  b = 3;
  c = 4;
  (x, y) = @dup(a, b);
  f = True;
  d = merge f (True -> 2)
              (False -> 4);
  e = merge f (True -> 3)
              (False -> 5)
\end_side

## Normalization - Extraction

\side
\include ../tests/correct/simple_fby_extract.sap
\middle_side
\include ../build/simple_fby_extract.nsap
\end_side

## Scheduling

1. Check each equation for dependecies
2. Build a dependency graph
3. Reverse `fby` edges
4. Schedule node

## Scheduling

\begin{table}[!h]
\begin{minipage}{0.45\linewidth}
\begin{lstlisting}
\include ../tests/correct/schedule.sap
\end{lstlisting}
\end{minipage}
\hfill\vrule\hfill
\begin{minipage}{0.45\linewidth}
  \includegraphics[trim=4 4 4 4, clip]{compiler/depgraph.png}
\end{minipage}
\end{table}

## Scheduling

\side
\include ../tests/correct/schedule.sap
\middle_side
node example() -> (x: int) with
  y = 2;
  x = 3 fby plus(b, 2)
  (c, d) = (x, y)
  z = 3 fby plus(b, 1);
  b = 2 fby 1;
  a = @node_call(x)
\end_side

## Intermediate language

Intermediate language needs:

  * Imperative
  * State and state modifiers
  * → OOP

## SOL

\code
machine example =
  memory /* Instance variables */
  instances /* Node instances */
  reset () = skip
  step() returns () =
    /* Instructions */
\end_code

## SOL Code Generation

\side
\include ../tests/correct/sol_trans.sap
\middle_side
\include ../build/sol_trans.sol
\end_side

## Javascript Code Generation - small node

\side
\include ../tests/correct/small_node.sap
\middle_side
\include ../build/small_node.sol
\end_side

## Javascript Code Generation - small node

\side
\include ../build/small_node.sol
\middle_side
function small() {
  this.t2 = undefined;
  this.t3 = new node_call();
}
small.prototype.reset = function() {
  this.t3.reset();
  this.t2 = 0;
}
small.prototype.step = function(a) {
  /* Omitting vardecs */
  t1 = this.t3.step(a);
  x = this.t2;
  b = t1;
  this.t2 = b;
  return x;
}
\end_side

## Types
\side
\include ../tests/correct/type_creation_interface.sap
\middle_side
var action_enum = Object.freeze({
  Add: 1,
  Id: 2
});

function action_type() {}

action_type.Add = function(n, x) {
  return {id: action_enum.Add, n:n, x:x}
}

action_type.Id = function() {
  return {id: action_enum.Id, n:n}
}
\end_side

## Interfacing with engine code

\side
\include ../tests/correct/type_creation_interface.sap
\middle_side
test.prototype.add = function (n, x) {
   this.step(action_type.Add(n, x));
   return this;
 }

test.prototype.nothing = function () {
  this.step(action_type.Nothing());
  return this;
}
\end_side

## Interfacing with generated code

\code
var node = new test().reset();
var result = node.add(2, 3).get_x();
assert(result == 5);
var result = node.id(5).get_x();
assert(result == 5);
\end_code

# Conclusion

## Past & Future Work

Accomplished work

* Working SAP compiler
    + [Parser|Normalizer|Scheduler|SOL Codegen|JS Codegen]
* Runtime Javascript Library
* Snake clone

Future work

* Type inference & Checking
* Clock inference & Checking
* Automata
* Optimisation

## {.standout}

Questions?