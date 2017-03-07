var dir_enum = Object.freeze({
  Up: 1,
  Left: 2,
  Down: 3,
  Right: 4
});

var event_enum = Object.freeze({
  Move: 5,
  MoveSecond: 6,
  ChangeDir: 7
});

function node() {
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

node.prototype.reset = function() {
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
}

node.prototype.step = function(e) {
  var x_ = undefined;
  var y_ = undefined;
  var d_ = undefined;
  x_ = this.x;
  y_ = this.y;
  d_ = this.d;
  switch(e.id) {
    case event_enum.ChangeDir:
      var d = e.d;
      switch(d_) {
        case dir_enum.Left:
          
          [d_] = this.cleft.step(d);
          break;
        case dir_enum.Right:
          
          [d_] = this.cright.step(d);
          break;
        case dir_enum.Up:
          
          [d_] = this.cup.step(d);
          break;
        case dir_enum.Down:
          
          [d_] = this.cdown.step(d);
          break;
      };
      break;
    case event_enum.Move:
      
      switch(d_) {
        case dir_enum.Left:
          
          [x_] = this.move_left.step(x_);
          break;
        case dir_enum.Right:
          
          [x_] = this.move_right.step(x_);
          break;
        case dir_enum.Up:
          
          [y_] = this.move_up.step(y_);
          break;
        case dir_enum.Down:
          
          [y_] = this.move_down.step(y_);
          break;
      };
      break;
    case event_enum.MoveSecond:
      var x = e.x;
      var y = e.y;
      x_ = x;
      y_ = y;
      break;
  };
  this.x = x_;
  this.y = y_;
  this.d = d_;
  return this;
}
node.prototype.move = function () {
  this.step({id: event_enum.Move});
  return this;
}

node.prototype.moveSecond = function (x, y) {
  this.step({id: event_enum.MoveSecond, x:x, y:y});
  return this;
}

node.prototype.changeDir = function (d) {
  this.step({id: event_enum.ChangeDir, d:d});
  return this;
}

                function change_left() {
  }
  
  change_left.prototype.reset = function() {
    
  }
  
  change_left.prototype.step = function(d) {
    var next_dir = undefined;
    next_dir = d;
    switch(d) {
      case dir_enum.Right:
        
        next_dir = dir_enum.Left;
        break;
    };
    return [next_dir];
  }
  
                function change_right() {
    }
    
    change_right.prototype.reset = function() {
      
    }
    
    change_right.prototype.step = function(d) {
      var next_dir = undefined;
      next_dir = d;
      switch(d) {
        case dir_enum.Left:
          
          next_dir = dir_enum.Right;
          break;
      };
      return [next_dir];
    }
    
                function change_up() {
      }
      
      change_up.prototype.reset = function() {
        
      }
      
      change_up.prototype.step = function(d) {
        var next_dir = undefined;
        next_dir = d;
        switch(d) {
          case dir_enum.Down:
            
            next_dir = dir_enum.Up;
            break;
        };
        return [next_dir];
      }
      
                function change_down() {
        }
        
        change_down.prototype.reset = function() {
          
        }
        
        change_down.prototype.step = function(d) {
          var next_dir = undefined;
          next_dir = d;
          switch(d) {
            case dir_enum.Up:
              
              next_dir = dir_enum.Down;
              break;
          };
          return [next_dir];
        }
        
                function left() {
          }
          
          left.prototype.reset = function() {
            
          }
          
          left.prototype.step = function(x) {
            x = sub(x, node_size);
            return [x];
          }
          
                function right() {
            }
            
            right.prototype.reset = function() {
              
            }
            
            right.prototype.step = function(x) {
              x = add(x, node_size);
              return [x];
            }
            
                function up() {
              }
              
              up.prototype.reset = function() {
                
              }
              
              up.prototype.step = function(y) {
                y = sub(y, node_size);
                return [y];
              }
              
                function down() {
                }
                
                down.prototype.reset = function() {
                  
                }
                
                down.prototype.step = function(y) {
                  y = add(y, node_size);
                  return [y];
                }
                
