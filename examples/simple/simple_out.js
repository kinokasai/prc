/* This depends on the accompanying javascript code */
var diff = 2;

function KD(n) {
    return n;
}

function KU(n) {
    return n + 256;
}

/* For this example, Sum types are converted to js enums */

var dir_enum = Object.freeze({
    Left: 1,
    Up: 2,
    Right: 3,
    Down: 4,
    None: 5,
});

function move() {
    this.x = 0;
    this.y = 0;
}

move.prototype.step = function (ck, key) {
    //console.log("x: " + this.x);
    //console.log("y: " + this.y);
    //console.log("reset: " + this.r);
    var dir = dir_node.step(key);
    var x_1 = move_x_node.step(dir, this.x);
    var y_1 = move_y_node.step(dir, this.y);
    this.x = x_1;
    this.y = y_1;
    var point = {x: x_1, y: y_1};
    return point;
}

function move_x() {
    /* No internal state */
}

move_x.prototype.step = function (dir, x) {
    switch (dir) {
        case dir_enum.Up:
        case dir_enum.Down:
        case dir_enum.None:
            x_1 = x;
            break;
        case dir_enum.Left:
            x_1 = x - diff;
            break;
        case dir_enum.Right:
            x_1 = x + diff;
            break;
        default:
            console.log(dir);
    }
    new_x = x_1;
    return new_x;
}

function move_y() {
}

move_y.prototype.step = function (dir, y) {
    switch (dir) {
        case dir_enum.Left:
        case dir_enum.Right:
        case dir_enum.None:
            y_1 = y;
            break;
        case dir_enum.Up:
            y_1 = y - diff;
            break;
        case dir_enum.Down:
            y_1 = y + diff;
            break;
    }
    new_y = y_1;
    return new_y;
}

function dir() {
}

dir.prototype.step = function (key) {
    left = key_press_node.step(key, 37);
    up = key_press_node.step(key, 38);
    right = key_press_node.step(key, 39);
    down = key_press_node.step(key, 40);
    if (left) { d = dir_enum.Left; }
    else if (right) { d = dir_enum.Right; }
    else if (down) { d = dir_enum.Down; }
    else if (up) { d = dir_enum.Up; }
    else { d = dir_enum.None;  }
    return d;
}

function key_press() {
}

key_press.prototype.step = function (key, n) {
    var v = (key == KD(n));
    var b_1 = key != KU(n);
    if (b_1) {pressed = v;} else {pressed = false;}
    this.pressed = pressed;
    return pressed;
}

var key_press_node = new key_press();
var move_node = new move();
var move_x_node = new move_x();
var move_y_node = new move_y();
var dir_node = new dir();

function init_nodes() {
    move_node_ret = move_node.step(true, -1);
}

/* Here is the lib section */

var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);
document.addEventListener("keyup", keyUpHandler, false);

var move_node_ret = undefined;

function keyPressHandler(e) {
    move_node_ret = move_node.step(true, e.keyCode);
}

function keyUpHandler(e) {
    move_node_ret = move_node.step(true, e.keyCode + 256);
}

/* Here is the pure js */
var x = 0;
var y = 0;

function draw() {
    /* Interface */
    x = move_node_ret.x;
    y = move_node_ret.y;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
    ctx.rect(x, y, 20, 20);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
    requestAnimationFrame(draw);
}

init_nodes();
draw();
