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
  this.y = undefined;
  this.x = undefined;
  this.theta = undefined;
  this.speed = undefined;
}

point.prototype.reset = function() {
  this.y = 250;
  this.x = 100;
  this.theta = 0;
  this.speed = 1;
  return this;
}

point.prototype.step = function(e) {
  var t2 = undefined;
  var t3 = undefined;
  var t5 = undefined;
  var t4 = undefined;
  t2 = subu(this.speed, 1);
  t3 = addu(this.speed, 1);
  switch(e.id) {
    case event_enum.Left:
      
      t5 = t2;
      break;
    case event_enum.Right:
      
      t5 = t3;
      break;
    case event_enum.Move:
      
      t5 = this.speed;
      break;
  };
  this.speed = t5;
  t4 = addu(this.theta, div(this.speed, 100));
  this.theta = t4;
  this.x = addu(mult(cos(this.theta), 80), 200);
  this.y = addu(mult(sin(this.theta), 80), 200);
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

