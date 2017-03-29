var dir_enum = Object.freeze({
  Up: 1,
  Left: 2,
  Down: 3,
  Right: 4
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

var event_enum = Object.freeze({
  Move: 5,
  MoveSecond: 6,
  ChangeDir: 7
});

function event_type() {}

event_type.Move = function() {
  return {id: event_enum.Move}
}

event_type.MoveSecond = function(x_, y_) {
  return {id: event_enum.MoveSecond, x_:x_, y_:y_}
}

event_type.ChangeDir = function(d_) {
  return {id: event_enum.ChangeDir, d_:d_}
}

function snake_node() {
  this.y = undefined;
  this.x = undefined;
  this.d = undefined;
  this.cdown = new cdown();
  this.cup = new cup();
  this.cright = new cright();
  this.cleft = new cleft();
}

snake_node.prototype.reset = function() {
  this.cdown.reset();
  this.cup.reset();
  this.cright.reset();
  this.cleft.reset();
  this.cdown.reset();
  this.cup.reset();
  this.cright.reset();
  this.cleft.reset();
  this.y = 0;
  this.x = 0;
  this.d = dir_enum.Right;
  return this;
}

snake_node.prototype.step = function(e) {
  var t0 = undefined;
  var t1 = undefined;
  var t2 = undefined;
  var t3 = undefined;
  var t4 = undefined;
  var t5 = undefined;
  var t6 = undefined;
  var t7 = undefined;
  switch(e.id) {
    case event_enum.ChangeDir:
      var d_ = e.d_;
      t0 = d_;
      break;
  };
  t1 = this.cleft.step(t0);
  t2 = this.cright.step(t0);
  t3 = this.cup.step(t0);
  t4 = this.cdown.step(t0);
  t5 = this.d;
  switch(e.id) {
    case event_enum.ChangeDir:
      var d_ = e.d_;
      switch(t5) {
        case dir_enum.Left:
          
          t5 = t1;
          break;
        case dir_enum.Right:
          
          t5 = t2;
          break;
        case dir_enum.Up:
          
          t5 = t3;
          break;
        case dir_enum.Down:
          
          t5 = t4;
          break;
      };
      break;
  };
  t6 = this.x;
  switch(e.id) {
    case event_enum.Move:
      
      switch(t5) {
        case dir_enum.Left:
          
          t6 = sub(this.x, node_size);
          break;
        case dir_enum.Right:
          
          t6 = add(this.x, node_size);
          break;
      };
      break;
    case event_enum.MoveSecond:
      var x_ = e.x_;
      var y_ = e.y_;
      t6 = x_;
      break;
  };
  t7 = this.y;
  switch(e.id) {
    case event_enum.Move:
      
      switch(t5) {
        case dir_enum.Up:
          
          t7 = sub(this.y, node_size);
          break;
        case dir_enum.Down:
          
          t7 = add(this.y, node_size);
          break;
      };
      break;
    case event_enum.MoveSecond:
      var x_ = e.x_;
      var y_ = e.y_;
      t7 = y_;
      break;
  };
  this.d = t5;
  this.x = t6;
  this.y = t7;
  return this;
}
snake_node.prototype.move = function () {
  this.step(event_type.Move());
  return this;
}

snake_node.prototype.moveSecond = function (x_, y_) {
  this.step(event_type.MoveSecond(x_, y_));
  return this;
}

snake_node.prototype.changeDir = function (d_) {
  this.step(event_type.ChangeDir(d_));
  return this;
}

        function cleft() {
  }
  
  cleft.prototype.reset = function() {
    
    return this;
  }
  
  cleft.prototype.step = function(d) {
    var next_dir = undefined;
    next_dir = d;
    switch(d) {
      case dir_enum.Right:
        
        next_dir = dir_enum.Left;
        break;
    };
    return next_dir;
  }
  
        function cright() {
    }
    
    cright.prototype.reset = function() {
      
      return this;
    }
    
    cright.prototype.step = function(d) {
      var next_dir = undefined;
      next_dir = d;
      switch(d) {
        case dir_enum.Left:
          
          next_dir = dir_enum.Right;
          break;
      };
      return next_dir;
    }
    
        function cup() {
      }
      
      cup.prototype.reset = function() {
        
        return this;
      }
      
      cup.prototype.step = function(d) {
        var next_dir = undefined;
        next_dir = d;
        switch(d) {
          case dir_enum.Down:
            
            next_dir = dir_enum.Up;
            break;
        };
        return next_dir;
      }
      
        function cdown() {
        }
        
        cdown.prototype.reset = function() {
          
          return this;
        }
        
        cdown.prototype.step = function(d) {
          var next_dir = undefined;
          next_dir = d;
          switch(d) {
            case dir_enum.Up:
              
              next_dir = dir_enum.Down;
              break;
          };
          return next_dir;
        }
        
