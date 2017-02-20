machine whatever =
    memory x2 : int
    instances x4 : count
    reset () = skip
    step (c : bool, i : int) returns (o : int) =
        var x123 : int in
        x123 = x2.step(x, y);
        state(x1) = x3
