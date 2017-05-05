type bool = Whatev | Not

machine huh =
  memory
  instances
  reset() = skip
  step () returns (x: int) =
    var b : int in
    b = Not;
  case(b) {
    Whatev: x = 1 |
    Not: x = 2
  }
