type event = Collide | None

machine point =
  memory x : int, y : int, speed : int
  instances
  reset () =
    state(x) = 200;
    state(y) = 200;
    state(vx) = 1;
    state(vy) = 1;
    state(speed) = 1
  step(e : event, vx : int, vy : int) returns (x: int, y:int) =
    var x : int, y : int in
    case (e) {
      Collide: state(vx) = vx; state(vy) = vy
    };
    x = mult(addu(state(x), state(vx)), state(speed));
    y = mult(addu(state(y), state(vy)), state(speed));
    state(x) = x;
    state(y) = y
