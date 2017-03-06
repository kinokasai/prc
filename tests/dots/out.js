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
  this.x = 400;
  this.y = 200;
  this.vx = 1;
  this.vy = 1;
  this.speed = 2;
}

point.prototype.step = function(e) {
  var x_ = undefined;
  var y_ = undefined;
  x = this.x;
  y = this.y;
  switch(e.id) {
    case event_enum.Collide:
      var vx = e.vx;
      var vy = e.vy;
      this.vx = vx;
      this.vy = vy;
      break;
    case event_enum.Move:
      
      [x, y] = this.move_point.step(this.x, this.y, this.vx, this.vy, this.speed);
      break;
    case event_enum.SpeedUp:
      
      this.speed = addu(this.speed, 1);
      break;
    case event_enum.SpeedDown:
      
      this.speed = subu(this.speed, 1);
      break;
  };
  this.x = x;
  this.y = y;
  return this;
}
point.prototype.collide = function (vx, vy) {
  this.step({id: event_enum.Collide, vx:vx, vy:vy});
  return this;
}

point.prototype.move = function (x, y) {
  this.step({id: event_enum.Move, x:x, y:y});
  return this;
}

point.prototype.speedDown = function () {
  this.step({id: event_enum.SpeedDown});
  return this;
}

point.prototype.speedUp = function () {
  this.step({id: event_enum.SpeedUp});
  return this;
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
  
