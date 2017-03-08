var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case 37:
            point_node.step(key_enum.Left);
            break;
        case 39:
            point_node.step(key_enum.Right);
            break;
    }
}

var [x, y] = [undefined, undefined];
var point_node = new point();
point_node.reset();

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    [x, y] = point_node.step(undefined);
    draw_rect(x, y, 10, 10);
    requestAnimationFrame(draw);
}

draw();
