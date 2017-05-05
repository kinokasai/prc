# Future Work

As of now, clock correctness is a burden placed
on the programmer. Our next revision should include clock
inference and checking based on the semantics
given in \cite{pouzet}. This change should remove programmer's
abilities to use custom operators in synchronous code.
This would also allow to write both much lighter and more
robust SAP code.

The Javascript runtime lib is also very simple. Additional
methods common in game programming could be implemented.
For now, we advise to use one of the many existing ones.

The SMUDGE compiler lacks type checking. It is planned for
it to have type inference as well. Once that feature is
implemented, SAP users will be able to use parameterized
sum types in code. This also would permit more powerful
pattern matching.

Several quality of life improvements are also possible.
These include infix operators support as well as aforementioned
inference. A language extension for supporting automata \cite{automata}
would also be very benificient as part of this project.


Right now, the compiler does no optimisation *whatsoever*.
Future versions of SMUDGE should implement optimisation
such as dead code removal, inlining, or data-flow network minimization.
The top priority is control fusion, which drastically removes
the number of branching created in the Javascript code by
merging together equations on the same clock. Inlining
would also permit undelayed feedback loops.