type event = Collide | None | Left | Right

machine point =
  memory x : int, y : int, speed : int
  instances move : move
  reset () =
    state(vx) = 1;
    state(vy) = 1;
    state(speed) = 2
  step(e : event, x: int, y : int, vx : int, vy : int) returns (x: int, y:int) =
    var in
    case (e) {
      Collide: state(vx) = vx; state(vy) = vy |
      None: (x, y) = move.step(x, y, state(vx), state(vy), state(speed)) |
      Left: state(speed) = minus(state(speed), 1) |
      Right: state(speed) = plus(state(speed), 1)
    }

machine move =
  memory
  instances
  reset () = skip
  step(x: int, y: int, vx: int, vy: int, speed:int) returns (x: int, y: int) =
    var in
    x = plus(x, times(vx, speed));
    y = plus(y, times(vy, speed))
