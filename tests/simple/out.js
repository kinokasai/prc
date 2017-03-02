var bool_enum = Object.freeze({
  True: 1,
  False: 2
});

var dir_enum = Object.freeze({
  Left: 3,
  Right: 4
});

function main() {
  this.x = undefined;
  this.move_x = new move_x();
}

main.prototype.reset = function() {
  this.move_x.reset();
  this.x = 0;
}

main.prototype.step = function(ck, key) {
  var x = undefined;
  x = this.x;
  switch(ck) {
    case true:
      [x] = this.move_x.step(key, this.x);
      break;
  };
  this.x = x;
  return [x];
}

  function move_x() {
  }
  
  move_x.prototype.reset = function() {
    
  }
  
  move_x.prototype.step = function(key, x) {
    var x_ = undefined;
    switch(key) {
      case dir_enum.Left:
        x_ = minus(x, 20);
        break;
      case dir_enum.Right:
        x_ = plus(x, 20);
        break;
    };
    return [x_];
  }
  
