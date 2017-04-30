var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case 37:
            point_node.left();
            break;
        case 39:
            point_node.right();
            break;
    }
}

var point_node = new point().reset();

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    point_node.move();
    draw_rect(point_node.get_x(), point_node.get_y(), 10, 10);
    requestAnimationFrame(draw);
}

draw();
