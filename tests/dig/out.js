var bool_enum = Object.freeze({
  True: 1,
  False: 2
});

function bool_type() {}

bool_type.True = function() {
  return {id: true}
}

bool_type.False = function() {
  return {id: false}
}

var atm_enum = Object.freeze({
  Wait: 3,
  Countdown: 4,
  Fall: 5,
  Stop: 6
});

function atm_type() {}

atm_type.Wait = function() {
  return {id: atm_enum.Wait}
}

atm_type.Countdown = function() {
  return {id: atm_enum.Countdown}
}

atm_type.Fall = function() {
  return {id: atm_enum.Fall}
}

atm_type.Stop = function() {
  return {id: atm_enum.Stop}
}

function update_rock() {
  this.y = undefined;
  this.st = undefined;
  this.cd = new countdown();
  this.fall = new fall();
  this.wait = new wait();
}

update_rock.prototype.reset = function() {
  this.cd.reset();
  this.fall.reset();
  this.wait.reset();
  this.y = 0;
  this.st = atm_enum.Wait;
}

update_rock.prototype.step = function(collide, stop) {
  var y = undefined;
  var st = undefined;
  y = this.y;
  st = this.st;
  switch(st) {
    case atm_enum.Wait:
      
      [st] = this.wait.step(collide);
      break;
    case atm_enum.Countdown:
      
      [st] = this.cd.step();
      break;
    case atm_enum.Fall:
      
      [st, y] = this.fall.step(y, stop);
      break;
  };
  this.y = y;
  this.st = st;
  return [y];
}

function wait() {
  this.useless = undefined;
}

wait.prototype.reset = function() {
  
}

wait.prototype.step = function(collide) {
  var t = undefined;
  switch(collide) {
    case true:
      
      t = atm_enum.Countdown;
      break;
    case false:
      
      t = atm_enum.Wait;
      break;
  };
  return [t];
}

function countdown() {
  this.count = undefined;
}

countdown.prototype.reset = function() {
  this.count = 300;
}

countdown.prototype.step = function() {
  var x = undefined;
  var t = undefined;
  x = subu(this.count, 1);
  b = less_than(x, 0);
  switch(b) {
    case true:
      
      t = atm_enum.Fall;
      break;
    case false:
      
      t = atm_enum.Countdown;
      break;
  };
  this.count = x;
  return [t];
}

function fall() {
  this.imuseless = undefined;
}

fall.prototype.reset = function() {
  
}

fall.prototype.step = function(y_in, stop) {
  var y = undefined;
  var diff = undefined;
  var t = undefined;
  switch(stop) {
    case true:
      
      diff = 0;
      break;
    case false:
      
      diff = 4;
      break;
  };
  y = addu(y_in, diff);
  switch(stop) {
    case true:
      
      t = atm_enum.Stop;
      break;
    case false:
      
      t = atm_enum.Fall;
      break;
  };
  return [t, y];
}

