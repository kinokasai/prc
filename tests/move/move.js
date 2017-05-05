var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

point_node = (new point()).reset();

function keyPressHandler(e) {
    /* Do what you must here */
    dir = e.keyCode;
    switch (dir) {
        case 39:
            point_node.move(dir_enum.Right)
            break;
        case 37:
            point_node.move(dir_enum.Left)
            break;
        case 38:
            point_node.move(dir_enum.Up)
            break;
        case 40:
            point_node.move(dir_enum.Down)
            break;
    }
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    requestAnimationFrame(draw);
    draw_rect(point_node.get_x(), point_node.get_y(), 20, 20);
}

draw();
