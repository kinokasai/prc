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
      Left: state(speed) = subu(state(speed), 1) |
      Right: state(speed) = addu(state(speed), 1)
    };
    state(theta) = addu(state(theta), div(state(speed), 100));
    x = addu(mult(cos(state(theta)), 80), 200);
    y = addu(mult(sin(state(theta)), 80), 200)

