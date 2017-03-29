var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

function draw_rect(x, y, w, h) {
    ctx.beginPath();
    ctx.rect(x, y, w, h);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case 38:
            point_node.arrowUp();
            break;
        case 40:
            point_node.arrowDown();
            break;
    }
}

var [x, y] = [undefined, undefined];
var point_node = new point();
point_node.reset();

function collide() {
    if (point_node.y < 0 || point_node.y > canvas.height) {
        point_node.collide();
    }
}

function draw() {
    collide()
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    point_node.move();
    draw_rect(point_node.x, point_node.y, 10, 10);
    requestAnimationFrame(draw);
}

draw();
