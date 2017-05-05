var event_enum = Object.freeze({
  Move: 1
});

function event_type() {}

event_type.Move = function(d) {
  return {id: event_enum.Move, d:d}
}

var dir_enum = Object.freeze({
  Up: 2,
  Left: 3,
  Down: 4,
  Right: 5
});

function dir_type() {}

dir_type.Up = function() {
  return {id: dir_enum.Up}
}

dir_type.Left = function() {
  return {id: dir_enum.Left}
}

dir_type.Down = function() {
  return {id: dir_enum.Down}
}

dir_type.Right = function() {
  return {id: dir_enum.Right}
}

function point() {
  this.t3 = undefined;
  this.t2 = undefined;
  this.t4 = new move();
}

point.prototype.reset = function() {
  this.t4.reset();
  this.t4.reset();
  this.t3 = 0;
  this.t2 = 0;
  return this;
}

point.prototype.step = function(e) {
  var e = undefined;
  x = this.t2;
  y = this.t3;
  t1 = this.t4.step(e.d, x, y);
  [new_x, new_y] = t1;
  this.t2 = new_x;
  this.t3 = new_y;
  return this;
}
point.prototype.get_y = function() {
  return this.t3;
}

point.prototype.set_y = function (new_value) {
  this.t3 = new_value;
  return this;
}

point.prototype.get_x = function() {
  return this.t2;
}

point.prototype.set_x = function (new_value) {
  this.t2 = new_value;
  return this;
}

point.prototype.get_new_x = function() {
  return this.t1;
}

point.prototype.set_new_x = function (new_value) {
  this.t1 = new_value;
  return this;
}

point.prototype.move = function (d) {
  this.step(event_type.Move(d));
  return this;
}

  function move() {
  }
  
  move.prototype.reset = function() {
    
    return this;
  }
  
  move.prototype.step = function(dir, x, y) {
    var dir = undefined;
    var x = undefined;
    var y = undefined;
    switch(dir) {
      case dir_enum.Left:
        
        x_ = sub(x, 20);
        break;
      case dir_enum.Right:
        
        x_ = add(x, 20);
        break;
      case dir_enum.Down:
        
        x_ = x;
        break;
      case dir_enum.Up:
        
        x_ = x;
        break;
    };
    switch(dir) {
      case dir_enum.Left:
        
        y_ = y;
        break;
      case dir_enum.Right:
        
        y_ = y;
        break;
      case dir_enum.Down:
        
        y_ = add(y, 20);
        break;
      case dir_enum.Up:
        
        y_ = sub(y, 20);
        break;
    };
    return [x_, y_];
  }
  
