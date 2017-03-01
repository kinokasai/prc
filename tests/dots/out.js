var event_enum = Object.freeze({
  Collide: 1,
  None: 2
});

function point() {
  this.x = undefined;
  this.y = undefined;
  this.speed = undefined;
}

point.prototype.reset = function() {
  this.x = 200;
  this.y = 200;
  this.vx = 1;
  this.vy = 1;
  this.speed = 1;
}

point.prototype.step = function(e, vx, vy) {
  var x = undefined;
  var y = undefined;
  switch(e) {
    case event_enum.Collide:
      this.vx = vx;
      this.vy = vy;
      break;
  };
  x = times(plus(this.x, this.vx), this.speed);
  y = times(plus(this.y, this.vy), this.speed);
  this.x = x;
  this.y = y;
  return [x, y];
}

