var event_enum = Object.freeze({
  Collide: 1,
  Move: 2,
  SpeedDown: 3,
  SpeedUp: 4
});

function event_type() {}

event_type.Collide = function(vx_, vy_) {
  return {id: event_enum.Collide, vx_:vx_, vy_:vy_}
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
  this.speed = undefined;
  this.y = undefined;
  this.x = undefined;
  this.vy = undefined;
  this.vx = undefined;
}

point.prototype.reset = function() {
  this.speed = 2;
  this.y = 200;
  this.x = 400;
  this.vy = 1;
  this.vx = 1;
  return this;
}

point.prototype.step = function(e) {
  var max_speed = undefined;
  var t1 = undefined;
  var t2 = undefined;
  var t3 = undefined;
  var t4 = undefined;
  var t5 = undefined;
  max_speed = 20;
  t1 = this.vx;
  t2 = this.vy;
  switch(e.id) {
    case event_enum.Collide:
      var vx_ = e.vx_;
      var vy_ = e.vy_;
      t1 = vx_;
      break;
  };
  switch(e.id) {
    case event_enum.Collide:
      var vx_ = e.vx_;
      var vy_ = e.vy_;
      t2 = vy_;
      break;
  };
  this.vx = t1;
  this.vy = t2;
  t3 = this.x;
  t4 = this.y;
  switch(e.id) {
    case event_enum.Move:
      
      t3 = addu(this.x, mult(this.vx, this.speed));
      break;
  };
  switch(e.id) {
    case event_enum.Move:
      
      t4 = addu(this.y, mult(this.vy, this.speed));
      break;
  };
  this.x = t3;
  this.y = t4;
  t5 = this.speed;
  switch(e.id) {
    case event_enum.SpeedUp:
      
      t5 = min(max_speed, addu(this.speed, 1));
      break;
    case event_enum.SpeedDown:
      
      t5 = min(max_speed, subu(this.speed, 1));
      break;
  };
  this.speed = t5;
  return this;
}
point.prototype.collide = function (vx_, vy_) {
  this.step(event_type.Collide(vx_, vy_));
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

