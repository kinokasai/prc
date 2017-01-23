function x() = {
    this.b_1 = true;
    this.x_2 = 0;
}

x.prototype.reset = function () {
    this.b_1 = true;
    this.x_2 = 0;
}

x.prototype.step = function (right) {
    var x = 0;
    var b = false;
    var x_3 = 0;
    var b = this.b_1;
    if (b) {x_3 = 0;} else {x_3 = x_2 + 2}
    if (right) {o = x_2;} else {o = x_3;}
    x_2 = 0;
    return o;
}
