\lstset{language=Javascript}

# Javascript Code Generation

Once the compiler has the intermediate representation - SOL code, it can compile
it down to Javascript.

To present the translation functions, we'll use the same format as before.
On the left side is the SOL program, and its translation is found on the right.

A machine will be translated to a object (function) declaration, with two methods added to
its prototype, `step()` and `reset()`

\side
machine <id> =
  memory <mach_dec>
  instances <instances>
  reset() =
      <step_exps>
    step(<in_var_decs>) returns (<out_var_decs>) =
    var <var_dec> in
    <step_insts>
\middle_side
function <id>() {
  translate_mem(<machdec>);
  translate_instances(<instances>);
}

<id>.prototype.reset = function() {
  translate_inst(<step_insts>)
}

<id>.prototype.step = function(<in_var_decs>) {
  translate_inst(<step_insts>);
}
\end_side
A memory is translated as a member variable.

\side
translate_mem(<var_id> : <var_ty>)
\middle_side
this.x = undefined;
\end_side

A node instance is translated as a member variable holding a node object instance.

\side
translate_instances(<var> : <node_id>)
\middle_side
this.<var> = new <node_id>()
\end_side

A variable assignment is translated as an Javascript assignment and the tranlation
of the right-hand side exp.

\side
translate_inst(<var_id> = <exp>)
\middle_side
<var_id> = translate_exp(<exp>);
\end_side

Skip expression amounts to nothing.

\side
translate_inst(skip)
\middle_side
;
\end_side

A reset instruction is translated as a `reset()` call on the
member node variable.

\side
translate_inst(<id>.reset)
\middle_side
this.<id>.reset();
\end_side

A state assignment is translated as an assignment of the
translated exp to the member variable.

\side
translate_inst(state(<var_id>) = <exp>)
\middle_side
this.<var_id> = translate_exp(<exp>);
\end_side

A step instruction is translated as a `step()` call on the node
member variable. The tuple assignment is translated to array assignment,
which is available in ES6.

\side
translate_inst(
  (<var_id>, ..., <var_id>) =
  <node_id>.step(<value>, ..., <value>))
\middle_side
[<var_id>, ..., <var_id>] =
  this.<node_id>.step(
    translate_val(<value>), ..., translate_val(<value>))
\end_side

Translation of a sequence of inst is translated as the sequence of
the translations.

\side
translate_inst(<inst>;<inst>)
\middle_side
translate_inst(<inst>);
translate_inst(<inst>);
\end_side

The case instruction is converted as the corresponding switch
instruction in Javascript. However, a special case is made when
the variable switched on is part of the node interface.

\side
translate_inst(case(<var_id>) 
  {<constr> : <inst>,
   ...,
   <constr> : <inst>})
\middle_side
switch(<var_id>) {
  case <constr>:
    translate_inst(<inst>);
  ...
  case <constr>:
    translate_inst(<inst>);
}
\end_side

A variable id is simply left as such.

\side
translate_exp(<var_id>)
\middle_side
<var_id>
\end_side

A value translation as expression is translated as a value.

\side
translate_exp(<value>)
\middle_side
translate_val(<value>)
\end_side

\newpage

State variable access is translated as an access to a member
variable

\side
translate_exp(state(<var_id>))
\middle_side
this.<var_id>
\end_side

Operator translation amounts to use the same operator
with each value argument translated.

\side
translat_exp(<op_id>(<value>, ..., <value>))
\middle_side
<op_id>(translate_val(<value>),
        ...,
        translate_val(<value>))
\end_side

A constructor has to be a type's variant. Thus, it is
translated as the value of that type's enum. See the
section on ADT for more information.

\side
translate_val(<constr_id>)
\middle_side
<type_id>_enum.<constr_id>
\end_side

An immediate is simply left as such.

\side
translate_val(<immediate>)
\middle_side
<immediate>
\end_side

#### Things to note

One can note the difference between a simple variable and a memory in generated code.
The memory becomes a member variable.

\side
x
\middle_side
this.x
\end_side

We established a few pages ago that we built a delta list describing the changes
made during normalization. Indeed, the equation `x = 2 fby add(x, 1)` would
be transformed into `t1 = 2 fby add(x, 1); x = t1` - thus preventing Javascript
developers to access inner variable. To remedy that, we use the aforementioned
delta list to create getters and setters to the appropriate variable on interface
nodes.

\side
\include ../tests/correct/getter.sap
\middle_side
// We omit non-relevant code.
function getter() {
  this.t1 = undefined;
}

getter.prototype.reset = function() {
  this.t1 = 1;
  return this;
}

getter.prototype.step = function(e) {
  var x = undefined;
  x = this.t1;
  this.t1 = 2;
  return this;
}
getter.prototype.get_x = function() {
  return this.t1;
}

getter.prototype.set_x = function (new_value) {
  this.t1 = new_value;
  return this;
}
\end_side

\include sol/adt.md

\newpage

### Javascript Moving Point
 
 Finally, our program is compiled down to Javacript.
 Since the resulting compiled code is more than a
 hundred lines long, we can't show it here.
 Full code can be found in appendix.