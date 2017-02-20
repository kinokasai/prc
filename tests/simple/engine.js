var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

var main = new main();
main.reset();

var x = undefined;
function keyPressHandler(e) {
    /* Do what you must here */
    dir = e.keyCode;
    switch (dir) {
        case 39:
            x = main.step(true, dir_enum.Right);
            break;
        case 37:
            x = main.step(true, dir_enum.Left)
            break;
    }
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    x = main.step(false, -1);
    draw_rect(x, 150, 20, 20);
    requestAnimationFrame(draw);
}

draw();
