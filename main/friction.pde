// friction.pde ---

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

interface Frictionable extends GameEntity {
  float getFriction();
  void setFriction(float friction);
}

class FrictionObject extends GameEntityWrap<Moveable> implements Frictionable, Moveable {
  float friction;
  FrictionObject(final Moveable origin) {
    super(origin);
    this.friction = 0.05;
  }
  @Override
  void update(final float dt) {
    super.update(dt);
    // simulate friction
    final float frictionFactor = 1.0 - friction;
    final PVector velocity = this.getVelocity();
    final PVector newVelocity = new PVector(velocity.x * frictionFactor,
                                            velocity.y * frictionFactor);
    this.setVelocity(newVelocity);
  }
  @Override
  float getFriction() {
    return this.friction;
  }
  @Override
  void setFriction(final float friction) {
    this.friction = friction;
  }
  @Override
  PVector getVelocity() {
    return this.origin.getVelocity();
  }
  @Override
  void setVelocity(final PVector velocity) {
    this.origin.setVelocity(velocity);
  }
  @Override
  PVector getMaxVelocity() {
    return this.origin.getMaxVelocity();
  }
  @Override
  void setMaxVelocity(final PVector maxVelocity) {
    this.origin.setMaxVelocity(maxVelocity);
  }
}
