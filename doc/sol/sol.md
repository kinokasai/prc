
#Simple Object Language

As we aim to compile down to an imperative language, we need to represent nodes
in a more imperative fashion as an intermediate representation.
As such, we introduce *Simple Object Language* (Sol), which relative
simplicity allows to represent stateful computation.

A node can be represented as a class definition with instances variables and two
methods `step` and `reset`. The `step` methods inherits its signature from the node
it was generated from, and it implements a single step of the node.
The `reset` method is parameterless, and is in charge of instancing state variables.

A program is made of sequence of global machine and type declarations (dec).
A machine (f) defines a set of memories, a set of instances for objects used inside
the body of the methods `step` or `reset`, and these two methods.

A description of SOL's grammar can be found in figure \ref{SolGrammar}.

\include sol/grammar.tex