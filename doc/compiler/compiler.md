The SMUDGE compiler is comprised of six passes:

* Parsing
* Clock checking
* Scheduling
* Normalization
* Sol codegen
* Javascript codegen

![Compiler Passes](compiler/passes.png)

Each output is fed as input to the following pass.

For debug purposes, build artifacts are created in the `build/` folder.
As such, we can find the following files in `build/` after `file.sap` has been compiled:

* name.sap
* name.clk
* name.scheduled
* name.nsap
* name.sol

If no `-o name` parameter is given, the compiler outputs the Javascript code
in `out.js`

## Scheduler

For more ease of use, SaP users are allowed to write their equations
in whichever order they like. As such, there should be no noticeable difference in
the execution of the following snippets.

\side
node example() -> (x: int) with
  y = 2;
  x = y + 1
\middle_side
node example() -> (x: int) with
  x = y + 1;
  y = 2
\end_side

This is the task of the Scheduler. We'll explain its operation using the following
snippet as example.

\code
node example() -> (x: int) with
  a = whatev(x);
  z = 3 fby plus(z, 1);
  b = 2 fby 1;
  x = plus(z, y);
  (c, d) = (x, y);
  y = 2
\end_code

#### TL;DR
The scheduler must find dependencies between equations. In order to do so,
it runs through node equations to find references to variables defined in-node.
It has to check for circular dependency, and reorganize equation order based on
those factors. We implement this by using graph algorithms.

Firstly, the scheduler builds an Hashmap containing the equations with the ids as
index. 

\begin{table}[!htbp]
\centering
\begin{tabular}{ll}
id & equations                      \\
\midrule
a  & a = op(x)                      \\
z  & z = 3 fby plus(z, 1)           \\
b  & b = 2 fby 1                    \\
x  & x = plus(z, y)                 \\
c  & (c, d) = (x, y)                \\
d  & (c, d) = (x, y)                \\
y  & y = 2                          \\
\bottomrule
\end{tabular}
\caption{Hashtable Contents}
\end{table}

The scheduler then establishes a list of ids that could be depended upon.
This is to exclude input variables. Indeed, input variables would
not be present in the equations.

\begin{table}[!htbp]
\centering
\begin{tabular}{|l|l|l|l|l|l|l|}
\hline
a & z & b & x & c & d & y \\ \hline
\end{tabular}
\caption{Id List}
\end{table}

The scheduler then moves on to creating the dependency graph. First, it adds a vertex
for each id present in the Hashmap.

Secondly, it adds an edge for each reference to an id in the right-hand side of the equation.
For example, it would add an edge between `a` and `x`. We are presented with the following
graph.

\newpage
![Incorrect Dependency Graph](compiler/depgraphdelays.png){width=40%}

However, that graph is non-correct. Indeed, delay variables must be changed
*after* every reading is completed. Correctly schduled code in on the right.

\side
node example() -> (x: int) with
  z = 1 fby 3
  x = y;
  y = 2 fby z;
\middle_side
node example() -> (x: int) with
  x = y;
  y = 2 fby z;
  z = 1 fby 3
\end_side

From here, the scheduler simply has to reverse every edge that goes to a delay.
A special case is made for a delay referencing itself.
The node right_fby is rightly scheduled code.
\code
node right_fby() -> (x: int) with
  x = 2 fby x + 1
\end_code
All those operations present us with figure \ref{GoodGraph}.

![Dependency Graph\label{GoodGraph}](compiler/depgraph.png){width=50%} 

Once the dependency graph is in our possession, we can do a causality check.
Indeed, the scheduler must determine the existence of a schedule. The `wrong` node
is for example unschedulable, as x depends on y which depends on x.

\code
node wrong() -> (x: int) with
  x = y;
  y = x
\end_code

As such, a schedule only exists if the graph is acyclic.

If no cycle is found, the scheduler moves on to reordering.

The scheduler then traverses the graph in order to find a vertex that has no
successors, that is to say that the equation has no more unsatisfied dependencies.
When one is found, it is added to the ordered list, and the vertex is deleted.
The scheduler goes on recursively until no vertex is left.

We are left with the following arrangement.

\code
node test() -> () with
  y = 2;
  x = plus(z, y);
  a = whatev(x);
  (c, d) = (x, y);
  z = 3 fby plus(z, 1);
  b = 2 fby 1
\end_code