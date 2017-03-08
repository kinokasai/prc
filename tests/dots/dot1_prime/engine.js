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

var [x, y] = [undefined, undefined];
var point_node = new point();
point_node.reset();

var vx = 1;
var vy = 1;

function collide() {
    bump = false;
    if (y < 0 || y + 10 > canvas.height) {
        vy = -vy;
        bump = true;
    }
    if (x < 0 || x + 10 > canvas.width) {
        vx = -vx;
        bump = true;
    }
    if (bump) {
        point_node.step(event_enum.Collide, vx, vy);
    }
}

function draw() {
    collide()
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    [x, y] = point_node.step(event_enum.None, undefined, undefined);
    draw_rect(x, y, 10, 10);
    requestAnimationFrame(draw);
}

draw();
