var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    dir = e.keyCode;
    //switch (dir) {
        //case 38:
            //point_node.step(event_enum.Up);
            //break;
        //case 40:
            //point_node.step(event_enum.Down);
            //break;
    //}
}

var node = new point().reset();

function collide() {
    if (node.y < 0 || node.y + 10 > canvas.height) {
        node.collide(node.vx, -node.vy)
    }
    if (node.x < 0 || node.x + 10 > canvas.width) {
        node.collide(-node.vx, node.vy);
    }
}

function draw() {
    collide()
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    node.move();
    draw_rect(node.x, node.y, 10, 10);
    requestAnimationFrame(draw);
}

draw();
