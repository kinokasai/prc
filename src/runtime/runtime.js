var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

function draw_rect(x, y, w, h) {
    ctx.beginPath();
    ctx.rect(x, y, w, h);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
}
