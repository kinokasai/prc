Algebraic Data Types exhibit some properties:
* Composite: Definition by cases - each case is composed into a single type
* Closed: A finite set of cases


The simplest ADT is Haskell's Boolean.

```haskell
data Boolean = True | False
```

Here, a variable of type `Boolean` has to be either `True` or `False`.
However, a variant type can also contain inner variables.

```haskell
type event = Nothing | GainPoints(amount: int)
```

A variable of type `event` will then be of type `Nothing` or `GainPoints` based on what happened in the game.

To access a fieled contained in a variant type, we use a syntax similar to deconstructive pattern matching in ML languages.

```haskell
step(e : event) returns () = var in
case (e) {
  Nothing: {- We do nothing-} |
  GainPoints(amount): state(points) = state(points) + amount
  }
```

#### Syntax
\include sol/adt_grammar.tex

#### Compilation

However, Javascript doesn't have Algebraic Data Types.
Thus, some trick is required. Fortunately, this has been the center of some research, as this is know
as The Expression problem.
While we'll not dive into detail here, know that an ADT can be represented
using Object-Oriented Programming.

We use a class's static methods to represent the construction of a variant type.
If a variant type is also a product type, that is it contains variables, the static method will take
as arguments those variables in order.

We use object litterals with a bit set to the enumerated type corresponding.
For example, the aforementioned `event` type will become:

```javascript
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
```

#### Formal translation

\include sol/adt_translation.tex
