// gameobject.pde ---

// Copyright (C) 2017 Hussein Ait-Lahcen

// Author: Hussein Ait-Lahcen <hussein.aitlahcen@gmail.com>

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

interface Updatable {
  void update(float dt);
}

interface Drawable {
  void beginDraw();
  void endDraw();
}

interface Composite extends Updatable {
  void addChild(GameEntity child);
  void removeChild(GameEntity child);
}

interface Positionable {
  float getX();
  float getY();
  float getAngle();
  void setX(float x);
  void setY(float y);
  void setAngle(float angle);
}

interface Frictionable {
  float getFriction();
  void setFriction(float friction);
}

interface Moveable extends Positionable {
  PVector getVelocity();
  void setVelocity(PVector velocity);
  PVector getMaxVelocity();
  void setMaxVelocity(PVector maxVelocity);
}

interface GameEntity extends Composite, Positionable, Drawable {
}

class GameEntityImpl implements GameEntity {
  float x;
  float y;
  float angle;
  ArrayList<GameEntity> childs;
  GameEntityImpl(int x, int y) {
    this(x, y, 0);
  }
  GameEntityImpl(int x, int y, float angle) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.childs = new ArrayList<GameEntity>();
  }
  @Override
  void update(float dt) {
    for(GameEntity child: this.childs) {
      child.update(dt);
    }
  }
  @Override
  void beginDraw() {
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.angle);
  }
  @Override
  void endDraw() {
    for(GameEntity child : this.childs) {
      child.beginDraw();
      child.endDraw();
    }
    popMatrix();
  }
  @Override
  void addChild(GameEntity child) {
    this.childs.add(child);
  }
  @Override
  void removeChild(GameEntity child) {
    this.childs.remove(child);
  }
  @Override
  float getX() {
    return this.x;
  }
  @Override
  float getY() {
    return this.y;
  }
  @Override
  void setX(float x) {
    this.x = x;
  }
  @Override
  void setY(float y) {
    this.y = y;
  }
  float getAngle() {
    return this.angle;
  }
  void setAngle(float angle) {
    this.angle = angle;
  }
}

class GameEntityWrap<T extends GameEntity> implements GameEntity {
  T origin;
  GameEntityWrap(T origin) {
    this.origin = origin;
  }
  @Override
  void update(float dt) {
    this.origin.update(dt);
  }
  @Override
  void beginDraw() {
    this.origin.beginDraw();
  }
  @Override
  void endDraw() {
    this.origin.endDraw();
  }
  @Override
  void addChild(GameEntity child) {
    this.origin.addChild(child);
  }
  @Override
  void removeChild(GameEntity child) {
    this.origin.removeChild(child);
  }
  @Override
  float getX() {
    return this.origin.getX();
  }
  @Override
  float getY() {
    return this.origin.getY();
  }
  @Override
  void setX(float x) {
    this.origin.setX(x);
  }
  @Override
  void setY(float y) {
    this.origin.setY(y);
  }
  @Override
  float getAngle() {
    return this.origin.getAngle();
  }
  @Override
  void setAngle(float angle) {
    this.origin.setAngle(angle);
  }
}

class Window extends GameEntityImpl {
  Window(int x, int y) {
    super(x, y);
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    background(127);
  }
}

class SpritedObject extends GameEntityWrap<GameEntity> {
  Sprite sprite;
  SpritedObject(GameEntity origin, Sprite sprite) {
    super(origin);
    this.sprite = sprite;
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    image(this.sprite.img, 0, 0);
  }
}

class DynamicObject extends GameEntityWrap<GameEntity> implements Moveable {
  Controller controller;
  PVector velocity;
  PVector maxVelocity;
  DynamicObject(GameEntity origin, Controller controller) {
    super(origin);
    this.velocity = new PVector(0, 0);
    this.maxVelocity = new PVector(500, 500);
    this.controller = controller;
  }
  @Override
  void update(float dt) {
    super.update(dt);
    PVector impulsion = this.controller.impulsion();
    if(impulsion.x != 0) {
      this.velocity.x = this.maxVelocity.x * impulsion.x;
    }
    if(impulsion.y != 0) {
      this.velocity.y = this.maxVelocity.y * impulsion.y;
    }
    this.origin.setX(this.origin.getX() + this.velocity.x * dt);
    this.origin.setY(this.origin.getY() + this.velocity.y * dt);
  }
  @Override
  PVector getVelocity() {
    return this.velocity;
  }
  @Override
  void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }
  @Override
  PVector getMaxVelocity() {
    return this.maxVelocity;
  }
  @Override
  void setMaxVelocity(PVector maxVelocity) {
    this.maxVelocity = maxVelocity;
  }
}

class FrictionObject extends GameEntityWrap<DynamicObject> implements Frictionable {
  float friction;
  FrictionObject(DynamicObject origin) {
    super(origin);
    this.friction = 0.05;
  }
  @Override
  void update(float dt) {
    super.update(dt);
    // simulate friction
    this.origin.velocity.x *= (1.0 - this.friction);
    this.origin.velocity.y *= (1.0 - this.friction);
  }
  @Override
  float getFriction() {
    return this.friction;
  }
  @Override
  void setFriction(float friction) {
    this.friction = friction;
  }
}
