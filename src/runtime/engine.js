var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    /* Do what you must here */
    dir = e.keyCode;
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    requestAnimationFrame(draw);
}

draw();
