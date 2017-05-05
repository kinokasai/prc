
### Algebraic Data Types

Algebraic Data Types exhibit some properties:

* Composite: Definition by cases - each case is composed into a single type
* Closed: A finite set of cases


The simplest ADT is Haskell's Boolean.

\lstset{language=Haskell}

\code
data Boolean = True | False
\end_code

Here, a variable of type `Boolean` has to be either `True` or `False`.
However, a variant type can also contain inner variables.

\lstset{language=SOL}

\code
type event = Nothing | GainPoints(amount: int)
\end_code

A variable of type `event` will then be of type `Nothing` or `GainPoints` based on what happened in the game.

To access a fieled contained in a variant type, we use a syntax similar to deconstructive pattern matching in ML languages.


\code
step(e : event) returns () = var in
case (e) {
  Nothing: {- We do nothing-} |
  GainPoints: state(points) = state(points) + e.amount
  }
\end_code

#### Syntax
A formal grammar can be found in figure \ref{ADT}

\include sol/adt_grammar.tex

#### Compilation

Sadly, Javascript doesn't have Algebraic Data Types.
However, we can simulate them.

We use a class's static methods to represent the construction of a variant type.
If a variant type is also a product type, that is it contains variables, the static method will take
as arguments those variables in order.

We use object litterals with a bit set to the enumerated type corresponding.
For example, the aforementioned `event` type will become:

\lstset{language=Javascript}
\code
var event_enum = Object.freeze({
  Nothing: 1,
  GainPoints: 2
});

function event_type() {}

event_type.Nothing = function() {
  return {id: event_enum.Nothing}
}

event_type.GainPoints = function(amount) {
  return {id: event_enum.GainPoints, amount:amount}
}
\end_code

#### Formal translation

A formal type translation is given as Figure \ref{Nice}

\include sol/adt_translation.tex
