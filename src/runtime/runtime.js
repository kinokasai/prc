function draw_rect(x, y, w, h) {
    ctx.beginPath();
    ctx.rect(x, y, w, h);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}

function rand_int(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}