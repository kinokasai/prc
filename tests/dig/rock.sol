type bool = True | False
type atm = Wait | Countdown | Fall | Stop

machine update_rock =
    memory y : int, st : atm
    instances cd : countdown, fall : fall, wait : wait
    reset () =
      state(y) = 0;
      state(st) = Wait
    step(collide : bool, stop : bool) returns (y : int) =
      var y : int, st : atm in
      y = state(y);
      st = state(st);
    case (st) {
        Wait: st = wait.step(collide) |
        Countdown: st = cd.step() |
        Fall: (st, y) = fall.step(y, stop)
    };
    state(y) = y;
    state(st) = st

machine wait =
    memory useless : int
    instances
    reset () = skip
    step(collide : bool) returns (t : atm) =
        var t : atm in
        case (collide) {
            True : t = Countdown |
            False : t = Wait
    }

machine countdown =
    memory count : int
    instances
    reset () =
        state(count) = 300
    step() returns (t : atm) =
        var x : int, t : atm in
        x = subu(state(count), 1);
        b = less_than(x, 0);
        case (b) {
            True : t = Fall |
            False : t = Countdown
        };
        state(count) = x

machine fall =
    memory imuseless : bool
    instances
    reset () = skip
    step(y_in : int, stop : bool) returns (t : atm, y : int) =
      var y : int, diff : int, t : atm in
      case (stop) { True: diff = 0 |
                    False: diff = 4};
      y = addu(y_in, diff);
      case (stop) { True: t = Stop |
                    False: t = Fall}
