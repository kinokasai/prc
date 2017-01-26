var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

var right_press = false;
var left_press = false;
var down_press = false;
var up_press = false;

var x = 0;
var y = 0;
var dx = 0;
var dy = 0;

Array.prototype.last = function () {
    return this[this.length - 1];
}

var dir_enum = Object.freeze({
    LEFT: 37,
    UP: 38,
    RIGHT: 39,
    DOWN: 40
});

var dirs = [];
dir = 0;

document.addEventListener("keydown", keyDownHandler, false);
document.addEventListener("keyup", keyUpHandler, false);

function keyDownHandler(e) {
    if (e.keyCode >= 37 && e.keyCode <= 40) {
        dir = e.keyCode;
    }
}

function keyUpHandler(e) {
    if (dir == e.keyCode)
        dir = 0;
}

function parse_input() {
    console.log(dirs);
    switch (dir) {
        case dir_enum.RIGHT:
            dx = 2;
            dy = 0;
            break;
        case dir_enum.LEFT:
            dx = -2;
            dy = 0;
            break;
        case dir_enum.DOWN:
            dx = 0;
            dy = 2;
            break;
        case dir_enum.UP:
            dx = 0;
            dy = -2;
            break;
        default:
            dx = 0;
            dy = 0;
            break;
    }
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    parse_input();
    ctx.beginPath();
    ctx.rect(x, y, 20, 20);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
    x += dx;
    y += dy;
    requestAnimationFrame(draw);
}

draw();
