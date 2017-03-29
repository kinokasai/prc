var event_enum = Object.freeze({
  Collide: 1,
  Move: 2,
  ArrowUp: 3,
  ArrowDown: 4
});

function event_type() {}

event_type.Collide = function() {
  return {id: event_enum.Collide}
}

event_type.Move = function() {
  return {id: event_enum.Move}
}

event_type.ArrowUp = function() {
  return {id: event_enum.ArrowUp}
}

event_type.ArrowDown = function() {
  return {id: event_enum.ArrowDown}
}

var atm_enum = Object.freeze({
  MoveUp: 5,
  MoveDown: 6
});

function atm_type() {}

atm_type.MoveUp = function() {
  return {id: atm_enum.MoveUp}
}

atm_type.MoveDown = function() {
  return {id: atm_enum.MoveDown}
}

function point() {
  this.speed = undefined;
  this.y = undefined;
  this.st = undefined;
  this.x = undefined;
  this.down = new down();
  this.up = new up();
}

point.prototype.reset = function() {
  this.down.reset();
  this.up.reset();
  this.down.reset();
  this.up.reset();
  this.speed = 1;
  this.y = 200;
  this.st = atm_enum.MoveUp;
  this.x = 200;
  return this;
}

point.prototype.step = function(e) {
  var t0 = undefined;
  var t1 = undefined;
  var t2 = undefined;
  var t3 = undefined;
  var t4 = undefined;
  var t5 = undefined;
  var t6 = undefined;
  var t7 = undefined;
  var t8 = undefined;
  var t9 = undefined;
  this.x = 200;
  t0 = this.st;
  [t1, t2, t3] = this.up.step(e, this.y, this.speed);
  [t4, t5, t6] = this.down.step(e, this.y, this.speed);
  switch(t0) {
    case atm_enum.MoveUp:
      
      t7 = t1;
      break;
    case atm_enum.MoveDown:
      
      t7 = t4;
      break;
  };
  switch(t0) {
    case atm_enum.MoveUp:
      
      t8 = t2;
      break;
    case atm_enum.MoveDown:
      
      t8 = t5;
      break;
  };
  switch(t0) {
    case atm_enum.MoveUp:
      
      t9 = t3;
      break;
    case atm_enum.MoveDown:
      
      t9 = t6;
      break;
  };
  this.st = t7;
  this.y = t8;
  this.speed = t9;
  return this;
}
point.prototype.collide = function () {
  this.step(event_type.Collide());
  return this;
}

point.prototype.move = function () {
  this.step(event_type.Move());
  return this;
}

point.prototype.arrowUp = function () {
  this.step(event_type.ArrowUp());
  return this;
}

point.prototype.arrowDown = function () {
  this.step(event_type.ArrowDown());
  return this;
}

    function up() {
  }
  
  up.prototype.reset = function() {
    
    return this;
  }
  
  up.prototype.step = function(e, y, speed) {
    var st = undefined;
    st = atm_enum.MoveUp;
    switch(e.id) {
      case event_enum.Move:
        
        y = subu(y, speed);
        break;
    };
    switch(e.id) {
      case event_enum.Collide:
        
        st = atm_enum.MoveDown;
        break;
    };
    switch(e.id) {
      case event_enum.ArrowUp:
        
        speed = addu(speed, 1);
        break;
      case event_enum.ArrowDown:
        
        speed = subu(speed, 1);
        break;
    };
    return [st, y, speed];
  }
  
    function down() {
    }
    
    down.prototype.reset = function() {
      
      return this;
    }
    
    down.prototype.step = function(e, y, speed) {
      var st = undefined;
      st = atm_enum.MoveDown;
      switch(e.id) {
        case event_enum.Move:
          
          y = addu(y, speed);
          break;
      };
      switch(e.id) {
        case event_enum.Collide:
          
          st = atm_enum.MoveUp;
          break;
      };
      switch(e.id) {
        case event_enum.ArrowUp:
          
          speed = subu(speed, 1);
          break;
        case event_enum.ArrowDown:
          
          speed = addu(speed, 1);
          break;
      };
      return [st, y, speed];
    }
    
