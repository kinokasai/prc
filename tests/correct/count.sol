machine condact =
memory x2: int
instances x4: count
reset () =
    state(x2) = 0
step (c : bool,i:int) returns (o:int) =
    var x3 : int in
    case(c) { True: o = x4.step(i) |
              False: o = state(x2)};
    state(x2) = o
