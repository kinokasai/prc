/* Standard math functions */

function add(a, b) {
    return a + b;
}

function addu(a, b) {
    return Math.min(a + b, Number.MAX_SAFE_INTEGER);
}

function sub(a, b) {
    return a - b;
}

function subu(a, b) {
    return Math.max(a - b, Number.MIN_SAFE_INTEGER);
}

function neg(a) {
    return -a;
}

function mult(a, b) {
    return a * b;
}

function div(a, b) {
    return a / b;
}

/* Boolean ops */

function or(a, b) {
    return a || b;
}

function and(a, b) {
    return a && b;
}

function not(a) {
    return !a;
}

/* Comparison ops */

function greater_than(a, b) {
    return a > b;
}

function egreater_than(a, b) {
    return a >= b;
}

function less_than(a, b) {
    return a < b;
}

function e_less_than(a, b) {
    return a <= b;
}

function equals(a, b) {
    return a === b;
}

/* Sine functions */

function cos(a) {
    return Math.cos(a);
}

function sin(a) {
    return Math.sin(a);
}

function tan(a) {
    return Math.tan(a);
}
var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

function draw_rect(x, y, w, h) {
    ctx.beginPath();
    ctx.rect(x, y, w, h);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}
