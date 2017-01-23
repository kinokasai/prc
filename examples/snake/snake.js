var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

var snake_len = 5;
var snake_dx = 0;
var snake_dy = 2;

var snake = [];
var pushbacks = [];

var pix_waypoint = 0;

var food_x = 0;
var food_y = 0;

var left_press = false;
var right_press = false;
var down_press = false;
var up_press = false;

var tick = 0;

/* create functions */

function create_snake() {
    for (i = 0; i < snake_len; i++) {
        snake[i] = {x: 100 - i * 12, y: 50, dx: 0, dy: 0, waypoints: []};
    }
    snake[0].dx = 2;
    snake[0].switch_dx = 2;
    for (i = 1; i < snake.length; i++) {
        snake[i].dx = snake[i-1].dx;
        snake[i].dy = snake[i-1].dy;
    }
}

function make_food() {
    food_x = rand_int(100, canvas.width - 100);
    food_y = rand_int(100, canvas.height - 100);
}

function init() {
    create_snake();
    make_food();
}

/* Helper functions */

function broadcast(x, y, dx, dy) {
    snake.forEach(function (snk, idx, array) {
        if (idx != 0) {
            snk.waypoints.push({x, y, dx, dy});
        }
    });
    pix_waypoint = 0;
}

function add_ring() {
    pushbacks.forEach(function (item, index, array) {
        if (item.tick == tick) {
            snk = snake[item.idx];
            snake[item.idx + 1].dx = item.dx;
            snake[item.idx + 1].dy = item.dy;
            snake_len += 1;
        }
    })
}

function rand_int(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function in_range(x, min, max) {
    return x > min && x < max;
}

/* Input functions */

document.addEventListener("keydown", keyDownHandler, false);
document.addEventListener("keyup", keyUpHandler, false);

function keyDownHandler(e) {
    if (e.keyCode == 39) {
        right_press = true;
    } else if (e.keyCode == 37) {
        left_press = true;
    } else if (e.keyCode == 38) {
        up_press = true;
    } else if (e.keyCode == 40) {
        down_press = true;
    }
}

function keyUpHandler(e) {
    if (e.keyCode == 39) {
        right_press = false;
    } else if (e.keyCode == 37) {
        left_press = false;
    } else if (e.keyCode == 38) {
        up_press = false;
    } else if (e.keyCode == 40) {
        down_press = false;
    }
}

/* Gameplay functions */

function parse_input() {
    snk = snake[0];
    if (right_press && snake[0].dx == 0) {
        snake[0].dx = 2;
        snake[0].dy = 0;
        broadcast(snk.x, snk.y, snk.dx, snk.dy)
    } else if (left_press && snake[0].dx == 0) {
        snake[0].dx = -2;
        snake[0].dy = 0;
        broadcast(snk.x, snk.y, snk.dx, snk.dy)
    } else if (down_press && snake[0].dy == 0) {
        snake[0].dx = 0;
        snake[0].dy = 2;
        broadcast(snk.x, snk.y, snk.dx, snk.dy)
    } else if (up_press && snake[0].dy == 0) {
        snake[0].dx = 0;
        snake[0].dy = -2;
        broadcast(snk.x, snk.y, snk.dx, snk.dy)
    }
}

function collide_canvas() {
    var snk = snake[0];
    if (snk.x < 0 || snk.x + 10 > canvas.width
        || snk.y < 0 || snk.y + 10 > canvas.height) {
            alert("Game over");
            document.location.reload();
        }
}

function collide_food() {
    var snk = snake[0];
    if (in_range(food_x, snk.x - 4, snk.x + 10)
        && in_range(food_y + 4, snk.y, snk.y + 14)) {
            pushbacks.push({dx: snk.dx, dy: snk.dy, idx: snake.length - 1,
                           tick: tick + (snake.length * 6)});
            snake.push({x: snk.x, y: snk.y, dx: 0, dy: 0, waypoints: []});
            make_food();
        }
}

/* draw_functions */

function draw_stuff(stuff) {
    ctx.font = "16px Arial";
    ctx.fillStyle = "#0095DD";
    ctx.fillText(stuff, 8, 20);
}

function draw_snake() {
    for (i = 0; i < snake.length; i++) {
        ctx.beginPath();
        ctx.rect(snake[i].x, snake[i].y, 10, 10);
        ctx.fillStyle = "#0095DD";
        ctx.fill();
        ctx.closePath();
    }
}

function draw_food() {
    ctx.beginPath();
    ctx.rect(food_x, food_y, 5, 5);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}

function draw_waypoint() {
    snake.forEach(function (snk, idx, array) {
        snk.waypoints.forEach(function (point, idx, array) {
            ctx.beginPath();
            ctx.rect(point.x, point.y, 1, 1);
            ctx.fillStyle = "#FF0000";
            ctx.fill();
            ctx.closePath();
        });
    });
}

function move_snake() {

    for (i = 1; i < snake.length; i++) {
        snk = snake[i];
        if (snk.waypoints.length) {
            var point = snk.waypoints[0];
            if (snk.x == point.x && snk.y == point.y) {
                snk.dx = point.dx;
                snk.dy = point.dy;
                snk.waypoints.shift();
            }
        }
    }

    snake.forEach(function (snk, idx, array) {
        snk.x += snk.dx;
        snk.y += snk.dy;
    })

    pix_waypoint += snake[0].dx + snake[0].dy;
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    if (Math.abs(pix_waypoint) >= 12) {
       parse_input();
    }
    /* draw stuff */
    draw_snake();
    draw_food();
    draw_stuff(snake.length);
    draw_waypoint();

    /* update stuff */
    move_snake();
    add_ring();
    collide_canvas();
    collide_food();
    tick += 1;

    requestAnimationFrame(draw);
}

init();
draw();
