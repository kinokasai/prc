var event_enum = Object.freeze({
  Collide: 1,
  None: 2,
  Up: 3,
  Down: 4
});

var atm_enum = Object.freeze({
  MoveUp: 5,
  MoveDown: 6
});

function point() {
  this.x = undefined;
  this.y = undefined;
  this.st = undefined;
  this.speed = undefined;
  this.up = new up();
  this.down = new down();
}

point.prototype.reset = function() {
  this.up.reset();
  this.down.reset();
  this.x = 200;
  this.y = 200;
  this.speed = 1;
  this.st = atm_enum.MoveUp;
}

point.prototype.step = function(e) {
  var x = undefined;
  var y = undefined;
  var st = undefined;
  var speed = undefined;
  x = this.x;
  st = this.st;
  switch(st) {
    case atm_enum.MoveUp:
      [st, y, speed] = this.up.step(e, this.y, this.speed);
      break;
    case atm_enum.MoveDown:
      [st, y, speed] = this.down.step(e, this.y, this.speed);
      break;
  };
  this.st = st;
  this.y = y;
  this.speed = speed;
  return [x, y];
}

    function up() {
  }
  
  up.prototype.reset = function() {
    
  }
  
  up.prototype.step = function(e, y, speed) {
    var st = undefined;
    st = atm_enum.MoveUp;
    switch(e) {
      case event_enum.None:
        y = minus(y, speed);
        break;
      case event_enum.Collide:
        st = atm_enum.MoveDown;
        break;
      case event_enum.Up:
        speed = plus(speed, 1);
        break;
      case event_enum.Down:
        speed = minus(speed, 1);
        break;
    };
    return [st, y, speed];
  }
  
    function down() {
    }
    
    down.prototype.reset = function() {
      
    }
    
    down.prototype.step = function(e, y, speed) {
      var st = undefined;
      st = atm_enum.MoveDown;
      switch(e) {
        case event_enum.None:
          y = plus(y, speed);
          break;
        case event_enum.Collide:
          st = atm_enum.MoveUp;
          break;
        case event_enum.Up:
          speed = minus(speed, 1);
          break;
        case event_enum.Down:
          speed = plus(speed, 1);
          break;
      };
      return [st, y, speed];
    }
    
