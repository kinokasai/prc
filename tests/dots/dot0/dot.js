var event_enum = Object.freeze({
  Left: 1,
  Right: 2,
  Move: 3
});

function event_type() {}

event_type.Left = function() {
  return {id: event_enum.Left}
}

event_type.Right = function() {
  return {id: event_enum.Right}
}

event_type.Move = function() {
  return {id: event_enum.Move}
}

function point() {
  this.t1 = undefined;
  this.t4 = undefined;
  this.t3 = undefined;
  this.t2 = undefined;
}

point.prototype.reset = function() {
  this.t1 = 1;
  this.t4 = 250;
  this.t3 = 100;
  this.t2 = 0;
  return this;
}

point.prototype.step = function(e) {
  var speed = undefined;
  var theta = undefined;
  var x = undefined;
  var y = undefined;
  var new_speed = undefined;
  var new_speed = undefined;
  var new_speed = undefined;
  speed = this.t1;
  theta = this.t2;
  x = this.t3;
  y = this.t4;
  switch(e.id) {
    case event_enum.Move:
      
      new_speed = speed;
      break;
  };
  switch(e.id) {
    case event_enum.Right:
      
      new_speed = addu(speed, 1);
      break;
  };
  switch(e.id) {
    case event_enum.Left:
      
      new_speed = subu(speed, 1);
      break;
  };
  this.t2 = addu(theta, div(speed, 100));
  this.t3 = addu(mult(cos(theta), 80), 200);
  this.t4 = addu(mult(sin(theta), 80), 200);
  this.t1 = new_speed;
  return this;
}
point.prototype.get_y = function() {
  return this.t4;
}

point.prototype.set_y = function (new_value) {
  this.t4 = new_value;
  return this;
}

point.prototype.get_x = function() {
  return this.t3;
}

point.prototype.set_x = function (new_value) {
  this.t3 = new_value;
  return this;
}

point.prototype.get_theta = function() {
  return this.t2;
}

point.prototype.set_theta = function (new_value) {
  this.t2 = new_value;
  return this;
}

point.prototype.get_speed = function() {
  return this.t1;
}

point.prototype.set_speed = function (new_value) {
  this.t1 = new_value;
  return this;
}

point.prototype.left = function () {
  this.step(event_type.Left());
  return this;
}

point.prototype.right = function () {
  this.step(event_type.Right());
  return this;
}

point.prototype.move = function () {
  this.step(event_type.Move());
  return this;
}

