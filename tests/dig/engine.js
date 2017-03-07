var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

document.addEventListener("keypress", keyPressHandler, false);

var dir_enum = Object.freeze({
    LEFT: 37,
    RIGHT: 39,
});

var player_x = 0;
var rock_y = 0;
var collide = false;
var stop = false;

var update_rock_node = new update_rock();
update_rock_node.reset();

function keyPressHandler(e) {
    dir = e.keyCode;
    switch (dir) {
        case dir_enum.RIGHT:
            player_x += 20;
            break;
        case dir_enum.LEFT:
            player_x -= 20;
            break;
    }
}

function draw_rect(x, y) {
    ctx.beginPath();
    ctx.rect(x, y, 20, 20);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}

function collide_func() {
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    if (player_x > 100) {
        collide = true;
    }
    if (rock_y > canvas.width - 20) {
        stop = true;
    }
    [rock_y] = update_rock_node.step(collide, stop);
    draw_rect(100, rock_y);
    draw_rect(player_x, 200);
    requestAnimationFrame(draw);
}

draw();
