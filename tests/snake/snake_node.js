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
  ChangeDir: 6
});

function event_type() {}

event_type.Move = function() {
  return {id: event_enum.Move}
}

event_type.ChangeDir = function(d) {
  return {id: event_enum.ChangeDir, d:d}
}

var delta_enum = Object.freeze({
  Delta: 7
});

function delta_type() {}

delta_type.Delta = function(x, y) {
  return {id: delta_enum.Delta, x:x, y:y}
}

function snake_head() {
  this.t5 = undefined;
  this.t4 = undefined;
  this.t3 = undefined;
  this.t13 = new change_dir();
  this.t12 = new move();
}

snake_head.prototype.reset = function() {
  this.t13.reset();
  this.t12.reset();
  this.t13.reset();
  this.t12.reset();
  this.t5 = 0;
  this.t4 = 0;
  this.t3 = dir_enum.Right;
  return this;
}

snake_head.prototype.step = function(e) {
  var dir = undefined;
  var x = undefined;
  var y = undefined;
  var t1 = undefined;
  var t2 = undefined;
  var new_x = undefined;
  var new_y = undefined;
  var new_dir = undefined;
  var new_x = undefined;
  var new_y = undefined;
  var new_dir = undefined;
  dir = this.t3;
  x = this.t4;
  y = this.t5;
  switch(e.id) {
    case event_enum.Move:
      
      t1 = this.t12.step(dir, x, y);
      break;
  };
  switch(e.id) {
    case event_enum.ChangeDir:
      
      t2 = this.t13.step(dir, e.d, x, y);
      break;
  };
  switch(e.id) {
    case event_enum.ChangeDir:
      
      [new_x, new_y, new_dir] = t2;
      break;
  };
  switch(e.id) {
    case event_enum.Move:
      
      [new_x, new_y, new_dir] = t1;
      break;
  };
  this.t3 = new_dir;
  this.t4 = new_x;
  this.t5 = new_y;
  return this;
}
snake_head.prototype.get_y = function() {
  return this.t5;
}

snake_head.prototype.set_y = function (new_value) {
  this.t5 = new_value;
  return this;
}

snake_head.prototype.get_x = function() {
  return this.t4;
}

snake_head.prototype.set_x = function (new_value) {
  this.t4 = new_value;
  return this;
}

snake_head.prototype.get_dir = function() {
  return this.t3;
}

snake_head.prototype.set_dir = function (new_value) {
  this.t3 = new_value;
  return this;
}

snake_head.prototype.get_new_x = function() {
  return this.t2;
}

snake_head.prototype.set_new_x = function (new_value) {
  this.t2 = new_value;
  return this;
}

snake_head.prototype.get_new_x = function() {
  return this.t1;
}

snake_head.prototype.set_new_x = function (new_value) {
  this.t1 = new_value;
  return this;
}

snake_head.prototype.move = function () {
  this.step(event_type.Move());
  return this;
}

snake_head.prototype.changeDir = function (d) {
  this.step(event_type.ChangeDir(d));
  return this;
}

            function snake_node() {
  this.t7 = undefined;
  this.t6 = undefined;
}

snake_node.prototype.reset = function() {
  this.t7 = 0;
  this.t6 = 0;
  return this;
}

snake_node.prototype.step = function(delta) {
  var x = undefined;
  var y = undefined;
  x = this.t6;
  y = this.t7;
  this.t6 = delta.x;
  this.t7 = delta.y;
  return this;
}
snake_node.prototype.get_y = function() {
  return this.t7;
}

snake_node.prototype.set_y = function (new_value) {
  this.t7 = new_value;
  return this;
}

snake_node.prototype.get_x = function() {
  return this.t6;
}

snake_node.prototype.set_x = function (new_value) {
  this.t6 = new_value;
  return this;
}

snake_node.prototype.delta = function (x, y) {
  this.step(delta_type.Delta(x, y));
  return this;
}

            function move() {
  }
  
  move.prototype.reset = function() {
    
    return this;
  }
  
  move.prototype.step = function(dir, x, y) {
    var new_dir = undefined;
    var new_x = undefined;
    var new_y = undefined;
    switch(dir) {
      case dir_enum.Left:
        
        new_dir = dir;
        break;
      case dir_enum.Right:
        
        new_dir = dir;
        break;
      case dir_enum.Down:
        
        new_dir = dir;
        break;
      case dir_enum.Up:
        
        new_dir = dir;
        break;
    };
    switch(dir) {
      case dir_enum.Left:
        
        new_x = sub(x, node_size);
        break;
      case dir_enum.Right:
        
        new_x = add(x, node_size);
        break;
      case dir_enum.Down:
        
        new_x = x;
        break;
      case dir_enum.Up:
        
        new_x = x;
        break;
    };
    switch(dir) {
      case dir_enum.Left:
        
        new_y = y;
        break;
      case dir_enum.Right:
        
        new_y = y;
        break;
      case dir_enum.Down:
        
        new_y = add(y, node_size);
        break;
      case dir_enum.Up:
        
        new_y = sub(y, node_size);
        break;
    };
    return [new_x, new_y, new_dir];
  }
  
            function change_dir() {
    this.t17 = new cleft();
    this.t16 = new cright();
    this.t15 = new cup();
    this.t14 = new cdown();}
    
    change_dir.prototype.reset = function() {
      this.t17.reset();
      this.t16.reset();
      this.t15.reset();
      this.t14.reset();
      this.t17.reset();
      this.t16.reset();
      this.t15.reset();
      this.t14.reset();
      return this;
    }
    
    change_dir.prototype.step = function(dir, wdir, x, y) {
      var t10 = undefined;
      var t11 = undefined;
      var t8 = undefined;
      var t9 = undefined;
      var new_dir = undefined;
      t10 = this.t14.step(wdir);
      t11 = this.t15.step(wdir);
      t8 = this.t16.step(wdir);
      t9 = this.t17.step(wdir);
      switch(dir) {
        case dir_enum.Right:
          
          new_dir = t8;
          break;
        case dir_enum.Left:
          
          new_dir = t9;
          break;
        case dir_enum.Down:
          
          new_dir = t10;
          break;
        case dir_enum.Up:
          
          new_dir = t11;
          break;
      };
      return [x, y, new_dir];
    }
    change_dir.prototype.get_new_dir = function() {
      return this.t11;
    }
    
    change_dir.prototype.set_new_dir = function (new_value) {
      this.t11 = new_value;
      return this;
    }
    
    
            function cright() {
      }
      
      cright.prototype.reset = function() {
        
        return this;
      }
      
      cright.prototype.step = function(d) {
        var next_dir = undefined;
        switch(d) {
          case dir_enum.Right:
            
            next_dir = d;
            break;
          case dir_enum.Up:
            
            next_dir = d;
            break;
          case dir_enum.Down:
            
            next_dir = d;
            break;
          case dir_enum.Left:
            
            next_dir = dir_enum.Right;
            break;
        };
        return next_dir;
      }
      
            function cleft() {
        }
        
        cleft.prototype.reset = function() {
          
          return this;
        }
        
        cleft.prototype.step = function(d) {
          var next_dir = undefined;
          switch(d) {
            case dir_enum.Right:
              
              next_dir = dir_enum.Left;
              break;
            case dir_enum.Up:
              
              next_dir = d;
              break;
            case dir_enum.Down:
              
              next_dir = d;
              break;
            case dir_enum.Left:
              
              next_dir = d;
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
            switch(d) {
              case dir_enum.Right:
                
                next_dir = d;
                break;
              case dir_enum.Up:
                
                next_dir = dir_enum.Down;
                break;
              case dir_enum.Down:
                
                next_dir = d;
                break;
              case dir_enum.Left:
                
                next_dir = d;
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
              switch(d) {
                case dir_enum.Right:
                  
                  next_dir = d;
                  break;
                case dir_enum.Up:
                  
                  next_dir = d;
                  break;
                case dir_enum.Down:
                  
                  next_dir = dir_enum.Up;
                  break;
                case dir_enum.Left:
                  
                  next_dir = d;
                  break;
              };
              return next_dir;
            }
            
