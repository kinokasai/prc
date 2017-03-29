var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

function aabb(a, b, a_size, b_size) {
    return a.x + a_size >= b.x && b.x + b_size >= a.x &&
        a.y + a_size >= b.y && b.y + b_size >= a.y;
}

function draw_stuff(stuff) {
    ctx.font = "16px Arial";
    ctx.fillStyle = "#0095DD";
    ctx.fillText(stuff, 8, 20);
}


document.addEventListener("keypress", keyPressHandler, false);

var snake = []
var food;

var node_size = 20;

for (i = 200; i > 200 - 5 * node_size; i -= node_size) {
    snake.push(make_node(i, 120));
}

function make_node(x, y) {
    var node_ = new snake_node();
    node_.reset();
    node_.x = x;
    node_.y = y;
    return node_;
}

function make_food() {
    var x = rand_int(20, canvas.width - 20);
    var y = rand_int(20, canvas.height - 20);
    food = {
        x: x,
        y: y
    };
}

function move_snake() {
    for (i = snake.length - 1; i > 0; i--) {
        var prev = snake[i - 1]
        snake[i].moveSecond(prev.x, prev.y);
    }
    snake[0].move();
    if (snake[0].x >= canvas.width || snake[0].x < 0 ||
        snake[0].y >= canvas.height || snake[0].y < 0) {
        game_over();
    }
    var snk_found = snake.find(function (snk, idx) {
        if (idx < 3 || idx >= snake.length) { return false; }
        return aabb(snake[0], snk, node_size - 1, node_size - 1);
    });
    if (snk_found) { game_over(); }
    setTimeout(move_snake, 100);
}

function game_over() {
    alert("Mr. Snake has died this morning. Please come to his funeral.");
    document.location.reload();
}

function draw_snake() {
    snake.forEach(function (elt) {
        draw_rect(elt.x, elt.y, node_size, node_size);
    })
}

function get_pos_from_dir(dir, x, y) {
    var x = x;
    var y = y;
    if (dir == dir_enum.Left)
        x += node_size;
    else if (dir == dir_enum.Right)
        x -= node_size;
    else if (dir == dir_enum.Up)
        y += node_size;
    else if (dir == dir_enum.Down)
        y -= node_size;
    return [x, y];
}

function eat() {
    if (aabb(snake[0], food, node_size, 5)) {
        make_food();
        last = snake[snake.length - 1];
        [x, y] = get_pos_from_dir(last.dir, last.x, last.y);
        snake.push(make_node(x, y));
        snake[snake.length - 1].dir = last.dir;
    }
}

function keyPressHandler(e) {
    /* Do what you must here */
    dir = e.keyCode;
    switch (dir) {
        case 39:
            snake[0].changeDir(dir_enum.Right);
            break;
        case 37:
            snake[0].changeDir(dir_enum.Left);
            break;
        case 38:
            snake[0].changeDir(dir_enum.Up);
            break;
        case 40:
            snake[0].changeDir(dir_enum.Down);
            break;
    }
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    eat();
    draw_snake();
    draw_rect(food.x, food.y, 5, 5);
    draw_stuff(snake.length);
    requestAnimationFrame(draw);
}

make_food();
move_snake();
draw();