type key = KU | KD

machine main =
    memory k : key
    instances is_down : is_down
    reset () =
        state(k) = KU
    step (ck : bool, key : key :: ck) returns (b : bool)
    var b : bool in
    case (ck) {
        True: state(key) = key;
    };
    b = is_down.step(state(key))

machine is_down =
    memory
    instances
    reset () = skip
    step (key : key) returns (b : bool) =
        var b : bool in
    case (key) {
        KD: b = True;
        KU: b = False;
    }
