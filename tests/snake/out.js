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

event_type.MoveSecond = function(x, y) {
  return {id: event_enum.MoveSecond, x:x, y:y}
}

event_type.ChangeDir = function(d) {
  return {id: event_enum.ChangeDir, d:d}
}

function snake_node() {
  this.x = undefined;
  this.y = undefined;
  this.d = undefined;
  this.move_left = new left();
  this.move_right = new right();
  this.move_down = new down();
  this.move_up = new up();
  this.cleft = new change_left();
  this.cright = new change_right();
  this.cdown = new change_down();
  this.cup = new change_up();
}

snake_node.prototype.reset = function() {
  this.move_left.reset();
  this.move_right.reset();
  this.move_down.reset();
  this.move_up.reset();
  this.cleft.reset();
  this.cright.reset();
  this.cdown.reset();
  this.cup.reset();
  this.x = 0;
  this.y = 0;
  this.d = dir_enum.Right;
  return this;
}

snake_node.prototype.step = function(e) {
  var x_ = undefined;
  var y_ = undefined;
  var d_ = undefined;
  x_ = this.x;
  y_ = this.y;
  d_ = this.d;
  switch(e.id) {
    case event_enum.ChangeDir:
      
      switch(d_) {
        case dir_enum.Left:
          
          d_ = this.cleft.step(e.d);
          break;
        case dir_enum.Right:
          
          d_ = this.cright.step(e.d);
          break;
        case dir_enum.Up:
          
          d_ = this.cup.step(e.d);
          break;
        case dir_enum.Down:
          
          d_ = this.cdown.step(e.d);
          break;
      };
      break;
    case event_enum.Move:
      
      switch(d_) {
        case dir_enum.Left:
          
          x_ = this.move_left.step(x_);
          break;
        case dir_enum.Right:
          
          x_ = this.move_right.step(x_);
          break;
        case dir_enum.Up:
          
          y_ = this.move_up.step(y_);
          break;
        case dir_enum.Down:
          
          y_ = this.move_down.step(y_);
          break;
      };
      break;
    case event_enum.MoveSecond:
      
      x_ = e.x;
      y_ = e.y;
      break;
  };
  this.x = x_;
  this.y = y_;
  this.d = d_;
  return this;
}
snake_node.prototype.move = function () {
  this.step(event_type.Move());
  return this;
}

snake_node.prototype.moveSecond = function (x, y) {
  this.step(event_type.MoveSecond(x, y));
  return this;
}

snake_node.prototype.changeDir = function (d) {
  this.step(event_type.ChangeDir(d));
  return this;
}

                function change_left() {
  }
  
  change_left.prototype.reset = function() {
    
    return this;
  }
  
  change_left.prototype.step = function(d) {
    var next_dir = undefined;
    next_dir = d;
    switch(d) {
      case dir_enum.Right:
        
        next_dir = dir_enum.Left;
        break;
    };
    return next_dir;
  }
  
                function change_right() {
    }
    
    change_right.prototype.reset = function() {
      
      return this;
    }
    
    change_right.prototype.step = function(d) {
      var next_dir = undefined;
      next_dir = d;
      switch(d) {
        case dir_enum.Left:
          
          next_dir = dir_enum.Right;
          break;
      };
      return next_dir;
    }
    
                function change_up() {
      }
      
      change_up.prototype.reset = function() {
        
        return this;
      }
      
      change_up.prototype.step = function(d) {
        var next_dir = undefined;
        next_dir = d;
        switch(d) {
          case dir_enum.Down:
            
            next_dir = dir_enum.Up;
            break;
        };
        return next_dir;
      }
      
                function change_down() {
        }
        
        change_down.prototype.reset = function() {
          
          return this;
        }
        
        change_down.prototype.step = function(d) {
          var next_dir = undefined;
          next_dir = d;
          switch(d) {
            case dir_enum.Up:
              
              next_dir = dir_enum.Down;
              break;
          };
          return next_dir;
        }
        
                function left() {
          }
          
          left.prototype.reset = function() {
            
            return this;
          }
          
          left.prototype.step = function(x) {
            x = sub(x, node_size);
            return x;
          }
          
                function right() {
            }
            
            right.prototype.reset = function() {
              
              return this;
            }
            
            right.prototype.step = function(x) {
              x = add(x, node_size);
              return x;
            }
            
                function up() {
              }
              
              up.prototype.reset = function() {
                
                return this;
              }
              
              up.prototype.step = function(y) {
                y = sub(y, node_size);
                return y;
              }
              
                function down() {
                }
                
                down.prototype.reset = function() {
                  
                  return this;
                }
                
                down.prototype.step = function(y) {
                  y = add(y, node_size);
                  return y;
                }
                
