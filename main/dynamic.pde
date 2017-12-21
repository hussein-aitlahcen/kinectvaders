// dynamic.pde ---

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

interface Moveable extends GameEntity {
  PVector getVelocity();
  void setVelocity(final PVector velocity);
  PVector getMaxVelocity();
  void setMaxVelocity(final PVector maxVelocity);
}

class ParentPositionObject extends GameEntityWrap<GameEntity> {
  PMatrix parentMatrix;
  ParentPositionObject(final GameEntity origin) {
    super(origin);
  }
  @Override
  void beginDraw() {
    parentMatrix = getMatrix();
    popMatrix();
    super.beginDraw();
  }
  @Override
  void endDraw() {
    super.endDraw();
    resetMatrix();
    pushMatrix();
    setMatrix(parentMatrix);
  }
}

class DynamicObject extends GameEntityWrap<GameEntity> implements Moveable {
  final Controller controller;
  PVector velocity;
  PVector maxVelocity;
  DynamicObject(final GameEntity origin, final Controller controller) {
    this(origin, controller, new PVector(0, 0), new PVector(500, 500));
  }
  DynamicObject(final GameEntity origin, final Controller controller, final PVector velocity) {
    this(origin, controller, velocity, velocity);
  }
  DynamicObject(final GameEntity origin, final Controller controller, final PVector velocity, final PVector maxVelocity) {
    super(origin);
    this.controller = controller;
    this.velocity = velocity;
    this.maxVelocity = maxVelocity;
  }
  @Override
  void update(final float dt) {
    super.update(dt);
    final PVector impulsion = this.controller
      .impulsion()
      .normalize();
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
  void setVelocity(final PVector velocity) {
    this.velocity = velocity;
  }
  @Override
  PVector getMaxVelocity() {
    return this.maxVelocity;
  }
  @Override
  void setMaxVelocity(final PVector maxVelocity) {
    this.maxVelocity = maxVelocity;
  }
}
