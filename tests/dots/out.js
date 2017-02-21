var key_enum = Object.freeze({
  Left: 1,
  Right: 2
});

function point() {
  this.theta = undefined;
  this.speed = undefined;
}

point.prototype.reset = function() {
  this.theta = 0;
  this.speed = 1;
}

point.prototype.step = function(k) {
  var x = undefined;
  var y = undefined;
  switch(k) {
    case key_enum.Left:
      this.speed = minus(this.speed, 1);
      break;
    case key_enum.Right:
      this.speed = plus(this.speed, 1);
      break;
  };
  this.theta = plus(this.theta, div(this.speed, 100));
  x = plus(times(cos(this.theta), 80), 200);
  y = plus(times(sin(this.theta), 80), 200);
  return [x, y];
}

