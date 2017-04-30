function aabb(a, b, size) {
    return a.x + size >= b.x && b.x + size >= a.x &&
        a.y + size >= b.y && b.y + size >= a.y;
}

function draw_rect(x, y, w, h) {
    ctx.beginPath();
    ctx.rect(x, y, w, h);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}