var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");
/* Ball vars */
var ball_x = canvas.width / 2;
var ball_y = canvas.height - 30;
ball_dx = 2;
ball_dy = -2;
ball_radius = 5;

/* Paddle vars */
var paddle_height = 10;
var paddle_width = 75;
var paddle_x = (canvas.width - paddle_width) / 2;

right_press = false;
left_press = false;

/* Brick vars */

var brick_row_count = 3;
var brick_column_count = 5;
var brick_width = 75;
var brick_height = 20;
var brick_padding = 10;
var brick_offset_top = 30;
var brick_offset_left = 30;

var bricks = [];
for (c = 0; c < brick_column_count; c++) {
    bricks[c] = [];
    for (r = 0; r < brick_row_count; r++) {
        bricks[c][r] = {x : 0, y : 0 };
    }
}

document.addEventListener("keydown", keyDownHandler, false);
document.addEventListener("keyup", keyUpHandler, false);

function keyDownHandler(e) {
    if (e.keyCode == 39) {
        right_press = true;
    } else if (e.keyCode == 37) {
        left_press = true;
    }
}

function keyUpHandler(e) {
    if (e.keyCode == 39) {
        right_press = false;
    } else if (e.keyCode == 37) {
        left_press = false;
    }
}

function draw_ball() {
    ctx.beginPath();
    ctx.arc(ball_x, ball_y, ball_radius * 2, 0, Math.PI*2);
    ctx.fillStyle = "#0095DD"
    ctx.fill();
    ctx.closePath();
}

function draw_bricks() {
    for (col = 0; col < brick_column_count; col++) {
        for (row = 0; row < brick_row_count; row++) {
            var brick_x = (col * (brick_width + brick_padding)) + brick_offset_left;
            var brick_y = (row * (brick_height + brick_padding)) + brick_offset_top;
            bricks[col][row].x = brick_x;
            bricks[col][row].y = brick_y;
            ctx.beginPath();
            ctx.rect(brick_x, brick_y, brick_width, brick_height);
            ctx.fillStyle = "#0095DD";
            ctx.fill();
            ctx.closePath();
        }
    }
}

function draw_paddle() {
    ctx.beginPath();
    ctx.rect(paddle_x, canvas.height - paddle_height, paddle_width, paddle_height);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    draw_ball();
    draw_paddle();
    draw_bricks();
    /* Move player */

    if (right_press) {
        paddle_x += 7;
    } else if (left_press) {
        paddle_x -= 7;
    }

    /* Move ball */

    ball_x += ball_dx;
    ball_y += ball_dy;

    /* Ball collisions */

    if (ball_x + ball_dx > canvas.width - ball_radius
        || ball_x + ball_dx < ball_radius) {
        ball_dx = -ball_dx;
    }

    if (ball_y + ball_dy < ball_radius) {
        ball_dy = -ball_dy;
    } else if (ball_y + ball_dy > canvas.height - ball_radius) {
        if (ball_x > paddle_x && ball_x < paddle_x + paddle_width) {
            ball_dy = - ball_dy;
        } else {
            alert("GAME OVER");
            document.location.reload();
        }
    }

}

setInterval(draw, 10);
