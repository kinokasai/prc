/* This depends on the accompanying javascript code */
var diff = 20;

/* For this example, Sum types are converted to js enums */

var dir_enum = Object.freeze({
    Left: 37,
    Right: 39,
});

function main() {
    this.x = 0;
}

main.prototype.step = function (key) {
    var tmp_x = move_x_node.step(key, this.x)
    this.x = tmp_x;
    return tmp_x;
}

function move_x() {}

move_x.prototype.step = function (dir, x) {
    switch (dir) {
        case dir_enum.Left:
            x_1 = x - diff;
            break;
        case dir_enum.Right:
            x_1 = x + diff;
            break;
        default:
    }
    var new_x = x_1;
    return new_x;
}

var main_node = new main();
var move_x_node = new move_x();

function init_nodes() {
    main_node_ret = 0;
}

/* Here is the lib section */

var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

var main_node_ret = undefined;

function keyPressHandler(e) {
    switch (e.keyCode) {
        case dir_enum.Right:
            main_node_ret = main_node.step(dir_enum.Right);
            break;
        case dir_enum.Left:
            main_node_ret = main_node.step(dir_enum.Left);
            break;
        default:
            break;
    }
}

/* Here is the pure js */
var x = 0;

function draw() {
    /* Interface */
    x = main_node_ret;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
    ctx.rect(x, 150, 20, 20);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
    requestAnimationFrame(draw);
}

init_nodes();
draw();
