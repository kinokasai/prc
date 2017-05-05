# The SMUDGE Compiler

As OCaml is particularly adapted to write compilers -
its types matching Ast structure really well as well as
having dedicated tooling, it's the language we adopted to
write the SMUDGE compiler.

The SMUDGE compiler is comprised of five passes:

* Parsing
* Scheduling
* Normalization
* Sol codegen
* Javascript codegen

![Compiler Passes](compiler/passes.png)

Each output is fed as input to the following pass.

The generated code is modular. This means that each node can be compiled
independantly of each other. Note that types still need to be known at
each compilation.

Each example presented in this report - unless told otherwise -
has been compiled through our compiler. Results may have been edited
for readability reasons.

For debug purposes, build artifacts are created in the `build/` folder.
As such, we can find the following files in `build/` after `file.sap` has been compiled:

* name.sap
* name.scheduled
* name.nsap
* name.sol

If no `-o name` parameter is given, the compiler outputs the Javascript code
in `out.js`

SMUDGE users have the ability to directly input SOL code. This can be useful
when getting to know the compiler operations or when wanting to have a finer
control on generated code.

### A small example

For the rest of this report, we'll see how a program goes through each pass
of the compiler. For this purpose, we'll use the following program:

\code
\include ../tests/move/move.sap
\end_code

It's a simple program which actuates the values of x and y depending on
input. It will be used - once compiled - to move a square accross the screen if
the player presses the right keys.