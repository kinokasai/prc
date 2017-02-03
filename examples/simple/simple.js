var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

var x = 0;
var y = 150;

var dir_enum = Object.freeze({
    LEFT: 37,
    RIGHT: 39,
});

dir = 0;

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case dir_enum.RIGHT:
            x += 20;
            break;
        case dir_enum.LEFT:
            x -= 20;
            break;
        default:
            break;
    }
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
    ctx.rect(x, y, 20, 20);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
    requestAnimationFrame(draw);
}

draw();
