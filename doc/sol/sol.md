---
header-includes:
  - \usepackage{syntax}
  - \usepackage{amsmath}
---
## SOL

As our goal is to compile down to a more imperative language,
we'll use the most simple form of an Object-Oriented language.
Please keep in mind that we are only interested in the capability
to encapsulate a piece of memory managed exclusively by the methods
of the class.

\include sol/grammar.tex

### ADT

\include sol/adt.md

### Interface

Our model concentrates on the implementation of an `interface` node -
or machine - that will be used by the game engine's javascript implementation.
Such a node will typically take an unique parameter, in the form of an `event` variable.
This variable will be an instance of an ADT type.

###Interface

```haskell
type event = Move | ChangeDir(x: int, y: int)

machine main =
  interface event
  memory
  instances
  reset () = skip
  step(e : event) returns (x: int, y: int) =
    var in
```

Then, for each variant of the `event` type, we add a method to the prototype of the interfaced node

*Formalism will be there*

```javascript
function main() {}
  
main.prototype.reset = function() {}

main.prototype.step = function(e) {
  return this;
}
main.prototype.move = function () {
  this.step(event_type.Move());
  return this;
}

main.prototype.changeDir = function (x, y) {
  this.step(event_type.ChangeDir(x, y));
  return this;
}

```
which allows the engine's code write a simple function call depending on the event
one is willing to trigger.

```javascript
main.move();
main.changeDir(10, 10);
```