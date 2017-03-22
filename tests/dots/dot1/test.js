var test = require('kludjs');
var fs = require('fs');
eval(fs.readFileSync(__dirname + '/out.js')+'');
eval(fs.readFileSync(__dirname + '/runtime.js')+'');

test("Down Movement test", function () {
  var p = new point().reset();
  /* Down test */
  p.st = atm_enum.MoveDown;
  var y = p.y;
  p.none();
  ok(y < p.y, "Moved down");
  var prev_speed = p.speed;
  p.arrowDown().none();
  ok(prev_speed < p.speed, "Speed increased");
  var prev_speed = p.speed;
  p.arrowUp().none();
  ok(prev_speed > p.speed, "Speed decreased");
  p.collide().none();
  ok(p.st === atm_enum.MoveUp, "Changed direction on collide");
});

test("Up test", function() {
  var p = new point().reset();
  p.st = atm_enum.MoveUp;
  var y = p.y;
  p.none();
  ok(y > p.y, "moved up");
});