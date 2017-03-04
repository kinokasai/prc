function aabb(a, b, size) {
    return a.x + size >= b.x && b.x + size >= a.x &&
        a.y + size >= b.y && b.y + size >= a.y;
}

var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case 37:
            speed_down();
            break;
        case 39:
            speed_up();
            break;
    }
}

var points = [make_point(), make_point()]
points[1].x = 160;
points[1].vx = -1;
points[1].node.collide(-1, 1);

function make_point() {
    point_ = {x: 400, y: 200, vx: 1, vy: 1, node: new point()};
    point_.node.reset();
    return point_;
}

function speed_up() {
    points.forEach(function(point) {
        point.node.speedUp();
    })
}

function speed_down() {
    points.forEach(function(point) {
        point.node.speedDown();
    })
}

function collide(point) {
    bump = false;
    if (point.y < 0 || point.y + 10 > canvas.height) {
        point.vy = -point.vy;
        bump = true;
    }
    if (point.x < 0 || point.x + 10 > canvas.width) {
        point.vx = -point.vx;
        bump = true;
    }
    points.forEach(function(val) {
        if (!bump && point != val && aabb(point, val, 10)) {
            point.vx = -point.vx;
            bump = true;
        }
    });
    if (bump) {
        console.log("bump");
        point.node.collide(point.vx, point.vy);
    }
}

function move_point(point) {
    [point.x, point.y] = point.node.move(point.x, point.y)
}

function draw() {
    points.forEach(function (point) {
        collide(point);
    });
    points.forEach(function (point) {
        move_point(point);
    })
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    points.forEach(function (point) {
        draw_rect(point.x, point.y, 10, 10);
    })
    requestAnimationFrame(draw);
}

draw();