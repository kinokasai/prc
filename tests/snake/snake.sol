type dir = Up | Left | Down | Right
type event = Move | MoveSecond(x: int, y:int) | ChangeDir(d : dir)

machine node =
  interface event
  memory x : int, y: int, d : dir
  instances move_left : left, move_right : right, move_down : down, move_up : up,
            cleft : change_left, cright : change_right, cdown: change_down, cup: change_up
  reset () =
    state(x) = 0;
    state(y) = 0;
    state(d) = Right
  step (e: event) returns () =
    var x_ : int, y_ : int, d_: dir in
    x_ = state(x);
    y_ = state(y);
    d_ = state(d);
    case (e) {
      ChangeDir(d): case(d_) {
        Left: d_ = cleft.step(d) |
        Right: d_ = cright.step(d) |
        Up: d_ = cup.step(d) |
        Down: d_ = cdown.step(d)
      } |
      Move: case (d_) {
        Left: x_ = move_left.step(x_) |
        Right: x_ = move_right.step(x_) |
        Up: y_ = move_up.step(y_) |
        Down: y_ = move_down.step(y_)
        } |
      MoveSecond(x, y): x_ = x; y_ = y
    };
    state(x) = x_;
    state(y) = y_;
    state(d) = d_

machine change_left =
  memory
  instances
  reset () = skip
  step(d: dir) returns (next_dir:dir) =
  var next_dir : dir in
    next_dir = d;
    case(d) {
      Right: next_dir = Left
    }

machine change_right =
  memory
  instances
  reset () = skip
  step(d: dir) returns (next_dir:dir) =
  var next_dir : dir in
    next_dir = d;
    case(d) {
      Left: next_dir = Right
    }

machine change_up =
  memory
  instances
  reset () = skip
  step(d: dir) returns (next_dir:dir) =
  var next_dir : dir in
    next_dir = d;
    case(d) {
      Down: next_dir = Up
    }

machine change_down =
  memory
  instances
  reset () = skip
  step(d: dir) returns (next_dir:dir) =
  var next_dir : dir in
    next_dir = d;
    case(d) {
      Up: next_dir = Down
    }

machine left =
  memory
  instances
  reset () = skip
  step (x: int) returns (x: int) =
    var in
    x = sub(x, node_size)

machine right =
  memory
  instances
  reset () = skip
  step(x: int) returns (x:int) =
    var in
    x = add(x, node_size)

machine up =
  memory
  instances
  reset () = skip
  step(y : int) returns (y : int) =
    var in
    y = sub(y, node_size)

machine down =
  memory
  instances
  reset () = skip
  step(y : int) returns (y : int) =
    var in
    y = add(y, node_size)