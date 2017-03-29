var event_enum = Object.freeze({
  Collide: 1,
  Move: 2
});

function event_type() {}

event_type.Collide = function(vx_, vy_) {
  return {id: event_enum.Collide, vx_:vx_, vy_:vy_}
}

event_type.Move = function() {
  return {id: event_enum.Move}
}

function point() {
  this.vy = undefined;
  this.vx = undefined;
  this.y = undefined;
  this.x = undefined;
}

point.prototype.reset = function() {
  this.vy = 1;
  this.vx = 1;
  this.y = 200;
  this.x = 200;
  return this;
}

point.prototype.step = function(e) {
  var speed = undefined;
  var t1 = undefined;
  var t2 = undefined;
  var t3 = undefined;
  var t4 = undefined;
  speed = 1;
  t1 = this.x;
  switch(e.id) {
    case event_enum.Move:
      
      t1 = mult(addu(this.x, this.vx), speed);
      break;
  };
  t2 = this.y;
  switch(e.id) {
    case event_enum.Move:
      
      t2 = mult(addu(this.y, this.vy), speed);
      break;
  };
  t3 = this.vx;
  t4 = this.vy;
  switch(e.id) {
    case event_enum.Collide:
      var vx_ = e.vx_;
      var vy_ = e.vy_;
      t3 = vx_;
      break;
  };
  switch(e.id) {
    case event_enum.Collide:
      var vx_ = e.vx_;
      var vy_ = e.vy_;
      t4 = vy_;
      break;
  };
  this.x = t1;
  this.y = t2;
  this.vx = t3;
  this.vy = t4;
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

