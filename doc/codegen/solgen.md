
\lstset{language=Javascript}

## Compilation from Normalized SAP
<!--
`map f list` is an helper function that apply the function
`f` to each element of the list.

\side
node <id>(<in_var_decs>) ->
  (<out_var_decs>) with
  var <var_decs> in
  <eql>
\middle_side
machine <id> =
  memory `mem_list`
  instances get_instances(<eql>)
  reset() = get_inst(<eql>)
  step(<in_var_decs>) returns (<out_var_decs>) =
    get_inst(<eql>)
\end_side

\side
get_mems(<eql>)
\middle_side
`fold` get_mem [] <eql>
\end_side

If the right hand side of the equation is an fby,
the variable is added to memories.

For the remaining forms of eq, nothing is added
to the memories.

\side
get_mem(<id> = <val> fby <exp>, mem_list)
\middle_side
mem_list + (<id> : undefined)
\end_side

If the right hand side of the equation is a nodecall,
the variable is added to instances.

For the remaining forms of eq, nothing is added
to the instance list.

\side
get_instance(<idl> =
  <node_id>(<exp>,..., <exp>))
\middle_side
inst_list + (<node_id>)
\end_side

\side
get_inst(<id> = <value> fby <exp>)
\middle_side

\end_side

\side
\middle_side
\end_side

\side
\middle_side
\end_side

\side
\middle_side
\end_side

\side
\middle_side
\end_side-->

The formal translation function from normalized sap code to SOL won't be
given here as we try to guide the reader's intuition. One can find
such a function in \cite{pouzet}

Equation exploration is pretty straightforward as the code has
been normalized.

The compiler starts by exploring the equation list in order
to find `fby` expressions. When one is found, the left-hand side is
added as an untyped memory. The value initializer is transformed
as an assignation instruction in the `reset()` function. Lastly,
the follow expression is transformed as an assignation instruction
in the `step()` function.

\side
node fby_example() -> (x: int) with
  x = 2 fby add(x, 1)
\middle_side
machine fby_example
  memory x : undefined
  instances
  reset() =
    x = 2
  step() returns (x: int) =
    var in
    x = add(x, 1)
\end_side

The compiler explores yet again the equation list to find
nodecalls. When one is found, the node id is added as an
instance. Furthermore, it's transformed as a `reset` call in
the `reset()` function. Lastly, the equation is translated as
an Assignation of a `step` call to the equation's left hand side.

\side
node node_call() -> (x: int) with
  x = @plus_node(1, 2)
\middle_side
machine node_call
  memories
  instances plus_node : plus_node
  reset () =
    plus_node.reset()
  step () returns (x: int) =
    var x : undefined in
    x = plus_node.step(1, 2)
\end_side

Once that's done, the compiler makes the list of all the ids
which are present on the right hand side of the equations,
to which it substracts input variables.
This list is used to define which variables need defining
in the `step()` method of the machine. Each variable is marked
as undefined as the type inference system could not be made
functional for this deadline.

\side
\include ../tests/correct/var_decs.sap
\middle_side
machine var_dec =
  memory t1 : undefined
  instances 
  reset () = 
    state(t1) = 3
  step(a : int) returns (x : int) = 
    var fby_var : undefined,
        var_dec : undefined,
        x : undefined
    in 
    state(t1) = 3;
    a = 1;
    fby_var = state(t1);
    var_dec = 2;
    x = 4
\end_side

The compiler then passes on to compile down each equation as
instructions.

Operator call, variable assignment of another stream or a
type constructor are translated as is.

\side
node normal_exps() -> (x: int) with
  x = add(3, 4);
  y = x;
  z = True
\middle_side
machine normal_exps()
  memory
  instances
  reset () =
    skip
step () returns (x: int) =
  var x : undefined,
      y : undefined,
      z : undefined
  in
  x = add(3, 4);
  y = x;
  z = True
\end_side

\newpage

`When` exps are special. Indeed, they are translated
as-is in themselveses. However, a `When` equation is
on a different clock than the rest of the equations.
Basically, this means that this equation is only defined
when the right side of the when exp is true. Clocks will
be discussed in-depth in their own section.

\side
node when_exp() -> (x: int) with
  b = True;
  x = 2 when True(b) :: base on True(b)
        /* Here is a clock ^ */
\middle_side
machine when_exp
  memory
  instances
  reset () = skip
  step () returns (x : int) =
    var b : undefined, x : undefined
    in
    b = True;
    case (b) {
      True -> x = 2
    }
\end_side

<!--`merge <id> (<constr> -> a1) ... (<constr> -> an)`
is the combination operator.
It takes as arguments a stream (`<id>`) producing values
belonging to a finite enumerated type - here
`type Boolean = True | False` and
a1 ... an being complementary streams. That is to say
that at any given moment, only one of them is producing
a value.-->

Thankfully, `Merge` expression can be expressed faithfully as a
`case` instruction.

\side
\include ../tests/correct/simple_merge.sap
\middle_side
machine merge
  memory
  instances
  reset () = skip
  step () returns (x: int) =
    var a : undefined,
        x : undefined,
        t1 : undefined,
        t2 : undefined
    in
      t1 = 2;
      t2 = 3;
      case(a) {
        True -> x = t1 |
        False -> x = t2
      }
\end_side

\newpage

One trickiness should be noted on merges.
Imbricked merges should propagate the assignment
through each case.

\side
\include ../tests/correct/imbricked_merge.sap
\middle_side
type color = Black | White
machine merges =
  memory 
  instances 
  reset () = 
    
  step() returns (x : int) = 
    var b : undefined,
        c : undefined,
        x : undefined
    in 
    b = True;
    c = Black;
    case (c) {
      White: case (b) {
        True: x = 1;
        False: x = 2
      };
      Black: x = 3
    }
\end_side

\newpage

### Simple Moving Point

Once it has been normalized and scheduled, our example is translated
as imperative code.

\code
machine point =
  memory t3 : undefined, t2 : undefined
  instances t4 : move
  reset () = 
    t4.reset();
  state(t3) = 0;
  state(t2) = 0
  step(e : event) returns () = 
    var x : undefined, y : undefined,
        t1 : undefined, new_x : undefined,
        new_y : undefined
    in 
    x = state(t2);
    y = state(t3);
    t1 = t4.step(e.d, x, y);
    (new_x, new_y) = t1;
    state(t2) = new_x;
    state(t3) = new_y

machine move =
  memory 
  instances 
  reset () = 
      
  step(dir : dir, x : int, y : int) returns (x_ : int, y_ : int) = 
    var x_ : undefined, y_ : undefined in 
      case (dir) {
        Left: x_ = sub(x, 20);
        Right: x_ = add(x, 20);
        Down: x_ = x;
        Up: x_ = x
      };
      case (dir) {
        Left: y_ = y;
        Right: y_ = y;
        Down: y_ = add(y, 20);
        Up: y_ = sub(y, 20)
      }
\end_code