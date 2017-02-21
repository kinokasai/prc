type key = Left | Right

machine point =
  memory theta : float, speed : int
  instances
  reset () =
    state(theta) = 0;
    state(speed) = 1
  step(k : key) returns (x : int, y : int) =
    var x : int, y : int in
    case(k) {
      Left: state(speed) = minus(state(speed), 1) |
      Right: state(speed) = plus(state(speed), 1)
    };
    state(theta) = plus(state(theta), div(state(speed), 100));
    x = plus(times(cos(state(theta)), 80), 200);
    y = plus(times(sin(state(theta)), 80), 200)

