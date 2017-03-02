type bool = True | False
type dir = Left | Right

machine main =
  memory x : int
  instances move_x : move_x
  reset() =
      state(x) = 0
    step(ck : bool, key : dir) returns (x : int) =
    var x : int in
    x = state(x);
    case(ck) {
        True: x = move_x.step(key, state(x))
    };
    state(x) = x

machine move_x =
  memory
  instances
  reset () = skip
  step(key : dir, x: int) returns (x_ : int) =
    var x_ : int in
  case (key) {
     Left : x_ = subu(x, 20) |
     Right : x_ = addu(x, 20)
  }
