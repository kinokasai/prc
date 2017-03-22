var event_enum = Object.freeze({
  Collide: 1,
  None: 2,
  ArrowUp: 3,
  ArrowDown: 4
});

function event_type() {}

event_type.Collide = function () {
  return {
    id: event_enum.Collide
  }
}

event_type.None = function () {
  return {
    id: event_enum.None
  }
}

event_type.ArrowUp = function () {
  return {
    id: event_enum.ArrowUp
  }
}

event_type.ArrowDown = function () {
  return {
    id: event_enum.ArrowDown
  }
}

var atm_enum = Object.freeze({
  MoveUp: 5,
  MoveDown: 6
});

function atm_type() {}

atm_type.MoveUp = function () {
  return {
    id: atm_enum.MoveUp
  }
}

atm_type.MoveDown = function () {
  return {
    id: atm_enum.MoveDown
  }
}

function point() {
  this.x = undefined;
  this.y = undefined;
  this.st = undefined;
  this.speed = undefined;
  this.up = new up();
  this.down = new down();
}

point.prototype.reset = function () {
  this.up.reset();
  this.down.reset();
  this.x = 200;
  this.y = 200;
  this.speed = 1;
  this.st = atm_enum.MoveUp;
  return this;
}

point.prototype.step = function (e) {
  var x = undefined;
  var y = undefined;
  var st = undefined;
  var speed = undefined;
  x = this.x;
  st = this.st;
  switch (st) {
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
  return this;
}
point.prototype.collide = function () {
  this.step(event_type.Collide());
  return this;
}

point.prototype.none = function () {
  this.step(event_type.None());
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

function up() {}

up.prototype.reset = function () {

}

up.prototype.step = function (e, y, speed) {
  var st = undefined;
  st = atm_enum.MoveUp;
  switch (e.id) {
    case event_enum.None:

      y = subu(y, speed);
      break;
    case event_enum.Collide:

      st = atm_enum.MoveDown;
      break;
    case event_enum.ArrowUp:

      speed = addu(speed, 1);
      break;
    case event_enum.ArrowDown:

      speed = subu(speed, 1);
      break;
  };
  return [st, y, speed];
}

function down() {}

down.prototype.reset = function () {

}

down.prototype.step = function (e, y, speed) {
  var st = undefined;
  st = atm_enum.MoveDown;
  switch (e.id) {
    case event_enum.None:

      y = addu(y, speed);
      break;
    case event_enum.Collide:

      st = atm_enum.MoveUp;
      break;
    case event_enum.ArrowUp:

      speed = subu(speed, 1);
      break;
    case event_enum.ArrowDown:

      speed = addu(speed, 1);
      break;
  };
  return [st, y, speed];
}