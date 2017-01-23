var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

var x = 0;
var y = canvas.height / 2 - 40;

var right_press = false;
var left_press = false;

document.addEventListener("keydown", keyDownHandler, false);
document.addEventListener("keyup", keyUpHandler, false);

function keyDownHandler(e) {
    if (e.keyCode == 39) {
        right_press = true;
    }
}

function keyUpHandler(e) {
    if (e.keyCode == 39) {
        right_press = false;
    }
}

function main() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    if (right_press) {
        x += 2;
    }
    ctx.beginPath();
    ctx.rect(x, y, 20, 20);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
    requestAnimationFrame(main);
}

main();
