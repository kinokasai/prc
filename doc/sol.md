## SOL

As our goal is to compile down to a more imperative language,
we'll use the most simple form of an Object-Oriented language.
Please keep in mind that we are only interested in the capability
to encapsulate a piece of memory managed exclusively by the methods
of the class.

_insert grammar.tex_

### ADT

Our model concentrates on the implementation of an `interface` node -
or machine - that will be used by the game engine's javascript implementation.
Such a node will typically take an unique parameter, in the form of an `event` variable.

Such an `event` will leverage the power of `Algebraic Data Types` to describe the event.

```ocaml
type event = Move | ChangeDir(x: int, y: int)
```

In order to represent such a data structure in Javascript, we leverage the ADT/Object duality (described in Cook's paper) and convert the event type to a Javascript object.

The previously mentioned `event` type will be compiled to the following Javascript object.

```javascript
var event_enum = Object.freeze({
  Move: 1,
  ChangeDir: 2
});

function event_type() {}

event_type.Move = function() {
  return {id: event_enum.Move}
}

event_type.ChangeDir = function(x, y) {
  return {id: event_enum.ChangeDir, x:x, y:y}
}

```

The type variant is idntified by the `id` field present in each object variation.
Each variant then has its specific properties added in its object litteral.

###Interface

```
machine main =
  interface event
  memory
  instances
  reset () = skip
  step(e : event) returns (x: int, y: int) =
    var in
```

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
which allows the engine's code to simply write:

```javascript
main.move();
main.changeDir(10, 10);
```

Effectively providing a nice interface to the dataflow code.