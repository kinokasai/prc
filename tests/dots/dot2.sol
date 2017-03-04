type event = Collide(vx: int, vy:int) | Move(x: int, y: int) | SpeedDown | SpeedUp

machine point =
  interface event
  memory x : int, y : int, speed : int
  instances move_point : move
  reset () =
    state(vx) = 1;
    state(vy) = 1;
    state(speed) = 2
  step(e : event, x: int, y : int, vx : int, vy : int) returns (x: int, y:int) =
    var in
    case (e) {
      Collide: state(vx) = vx; state(vy) = vy |
      Move: (x, y) = move_point.step(x, y, state(vx), state(vy), state(speed)) |
      SpeedUp: state(speed) = addu(state(speed), 1) |
      SpeedDown: state(speed) = subu(state(speed), 1)
    }

machine move =
  memory
  instances
  reset () = skip
  step(x: int, y: int, vx: int, vy: int, speed:int) returns (x: int, y: int) =
    var in
    x = addu(x, mult(vx, speed));
    y = addu(y, mult(vy, speed))
