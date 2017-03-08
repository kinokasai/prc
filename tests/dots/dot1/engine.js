var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case 38:
            point_node.step(event_enum.Up);
            break;
        case 40:
            point_node.step(event_enum.Down);
            break;
    }
}

var [x, y] = [undefined, undefined];
var point_node = new point();
point_node.reset();

function collide() {
    if (y < 0 || y > canvas.height) {
        point_node.step(event_enum.Collide)
    }
}

function draw() {
    collide()
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    [x, y] = point_node.step(event_enum.None);
    draw_rect(x, y, 10, 10);
    requestAnimationFrame(draw);
}

draw();
