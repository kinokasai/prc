type event = Collide(vx: int, vy: int) | Move | SpeedDown | SpeedUp

machine point =
  interface event
  memory x : int, y : int, speed : int
  instances move_point : move
  reset () =
    state(x) = 400;
    state(y) = 200;
    state(vx) = 1;
    state(vy) = 1;
    state(speed) = 2
  step(e : event) returns () =
    var x : int, y : int in
    x = state(x);
    y = state(y);
    case (e) {
      Collide(vx, vy): state(vx) = vx; state(vy) = vy |
      Move: (x, y) = move_point.step(state(x), state(y), state(vx), state(vy), state(speed)) |
      SpeedUp: state(speed) = addu(state(speed), 1) |
      SpeedDown: state(speed) = subu(state(speed), 1)
    };
    state(x) = x;
    state(y) = y

machine move =
  memory
  instances
  reset () = skip
  step(x: int, y: int, vx: int, vy: int, speed:int) returns (x: int, y: int) =
    var in
    x = addu(x, mult(vx, speed));
    y = addu(y, mult(vy, speed))
