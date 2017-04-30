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

function pointhehe() {
  this.t3 = undefined;
  this.t2 = undefined;
  this.t4 = new move();
}

pointhehe.prototype.reset = function() {
  this.t4.reset();
  this.t4.reset();
  this.t3 = 0;
  this.t2 = 0;
  return this;
}

pointhehe.prototype.step = function(e) {
  var x = undefined;
  var y = undefined;
  var t1 = undefined;
  var new_x = undefined;
  var new_y = undefined;
  x = this.t2;
  y = this.t3;
  t1 = this.t4.step(e.d, x, y);
  [new_x, new_y] = t1;
  this.t2 = new_x;
  this.t3 = new_y;
  return this;
}
pointhehe.prototype.get_y = function() {
  return this.t3;
}

pointhehe.prototype.set_y = function (new_value) {
  this.t3 = new_value;
  return this;
}

pointhehe.prototype.get_x = function() {
  return this.t2;
}

pointhehe.prototype.set_x = function (new_value) {
  this.t2 = new_value;
  return this;
}

pointhehe.prototype.get_new_x = function() {
  return this.t1;
}

pointhehe.prototype.set_new_x = function (new_value) {
  this.t1 = new_value;
  return this;
}

pointhehe.prototype.move = function (d) {
  this.step(event_type.Move(d));
  return this;
}

  function move() {
  }
  
  move.prototype.reset = function() {
    
    return this;
  }
  
  move.prototype.step = function(dir, x, y) {
    var x_ = undefined;
    var y_ = undefined;
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
  
