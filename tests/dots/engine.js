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
points[1].collide(-1, 1);

function make_point() {
    point_ = new point()
    point_.reset();
    return point_;
}

function speed_up() {
    points.forEach(function(point) {
        point.speedUp();
    })
}

function speed_down() {
    points.forEach(function(point) {
        point.speedDown();
    })
}

function collide(point) {
    bump = false;
    var vy = point.vy;
    var vx = point.vx;
    if (point.y < 0 || point.y + 10 > canvas.height) {
        var vy = -vy;
        bump = true;
    }
    if (point.x < 0 || point.x + 10 > canvas.width) {
        var vx = -vx;
        bump = true;
    }
    points.forEach(function(val) {
        if (!bump && point != val && aabb(point, val, 10)) {
           lvx = -vx;
            bump = true;
        }
    });
    if (bump) {
        console.log("bump");
        point.collide(vx, vy);
    }
}

function draw() {
    points.forEach(function (point) {
        collide(point);
    });
    points.forEach(function (point) {
        point.move(point.x, point.y)
    })
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    points.forEach(function (point) {
        draw_rect(point.x, point.y, 10, 10);
    })
    requestAnimationFrame(draw);
}

draw();