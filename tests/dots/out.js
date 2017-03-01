var event_enum = Object.freeze({
  Collide: 1,
  None: 2,
  Left: 3,
  Right: 4
});

function point() {
  this.x = undefined;
  this.y = undefined;
  this.speed = undefined;
  this.move = new move();
}

point.prototype.reset = function() {
  this.move.reset();
  this.vx = 1;
  this.vy = 1;
  this.speed = 2;
}

point.prototype.step = function(e, x, y, vx, vy) {
  switch(e) {
    case event_enum.Collide:
      this.vx = vx;
      this.vy = vy;
      break;
    case event_enum.None:
      [x, y] = this.move.step(x, y, this.vx, this.vy, this.speed);
      break;
    case event_enum.Left:
      this.speed = minus(this.speed, 1);
      break;
    case event_enum.Right:
      this.speed = plus(this.speed, 1);
      break;
  };
  return [x, y];
}

  function move() {
  }
  
  move.prototype.reset = function() {
    
  }
  
  move.prototype.step = function(x, y, vx, vy, speed) {
    x = plus(x, times(vx, speed));
    y = plus(y, times(vy, speed));
    return [x, y];
  }
  
