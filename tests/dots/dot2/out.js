var event_enum = Object.freeze({
  Collide: 1,
  Move: 2,
  SpeedDown: 3,
  SpeedUp: 4
});

function event_type() {}

event_type.Collide = function(vx, vy) {
  return {id: event_enum.Collide, vx:vx, vy:vy}
}

event_type.Move = function() {
  return {id: event_enum.Move}
}

event_type.SpeedDown = function() {
  return {id: event_enum.SpeedDown}
}

event_type.SpeedUp = function() {
  return {id: event_enum.SpeedUp}
}

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
  var x = undefined;
  var y = undefined;
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
      
      this.speed = min(max_speed, addu(this.speed, 1));
      break;
    case event_enum.SpeedDown:
      
      this.speed = min(max_speed, subu(this.speed, 1));
      break;
  };
  this.x = x;
  this.y = y;
  return this;
}
point.prototype.collide = function (vx, vy) {
  this.step(event_type.Collide(vx, vy));
  return this;
}

point.prototype.move = function () {
  this.step(event_type.Move());
  return this;
}

point.prototype.speedDown = function () {
  this.step(event_type.SpeedDown());
  return this;
}

point.prototype.speedUp = function () {
  this.step(event_type.SpeedUp());
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
  
