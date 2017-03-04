var event_enum = Object.freeze({
  Collide: 1,
  Move: 2,
  SpeedDown: 3,
  SpeedUp: 4
});

function point() {
  this.x = undefined;
  this.y = undefined;
  this.speed = undefined;
  this.move_point = new move();
}

point.prototype.reset = function() {
  this.move_point.reset();
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
    case event_enum.Move:
      [x, y] = this.move_point.step(x, y, this.vx, this.vy, this.speed);
      break;
    case event_enum.SpeedUp:
      this.speed = addu(this.speed, 1);
      break;
    case event_enum.SpeedDown:
      this.speed = subu(this.speed, 1);
      break;
  };
  return [x, y];
}
point.prototype.collide = function (vx, vy) {
  return this.step(event_enum.Collide, undefined, undefined, vx, vy);
}

point.prototype.move = function (x, y) {
  return this.step(event_enum.Move, x, y, undefined, undefined);
}

point.prototype.speedDown = function () {
  return this.step(event_enum.SpeedDown, undefined, undefined, undefined, undefined);
}

point.prototype.speedUp = function () {
  return this.step(event_enum.SpeedUp, undefined, undefined, undefined, undefined);
}

  function move() {
  }
  
  move.prototype.reset = function() {
    
  }
  
  move.prototype.step = function(x, y, vx, vy, speed) {
    x = addu(x, mult(vx, speed));
    y = addu(y, mult(vy, speed));
    return [x, y];
  }
  
