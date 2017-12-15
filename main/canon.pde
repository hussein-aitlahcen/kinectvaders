// canon.pde ---

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

interface Canon {
  void update(final float dt);
  void trigger(final GameEntity entity);
}

interface CanonSpec {
  float projectileDurability();
  float projectileVelocity();
  float firingRate();
}

class BasicCanonSpec implements CanonSpec {
  @Override
  float projectileDurability() {
    return 2;
  }
  @Override
  float projectileVelocity() {
    return 500;
  }
  @Override
  float firingRate() {
    return 2;
  }
}

class BasicCanon implements Canon {
  final CanonSpec spec;
  final Sprite projectileSprite;
  final Game game;
  final PVector direction;
  float fireCooldown;
  BasicCanon(final CanonSpec spec, final Sprite projectileSprite, final PVector direction, final Game game) {
    this.spec = spec;
    this.projectileSprite = projectileSprite;
    this.game = game;
    this.direction = PVector.mult(direction, spec.projectileVelocity());
    this.fireCooldown = 0;
  }
  void update(final float dt) {
    fireCooldown -= dt;
  }
  GameEntity createProjectile(final GameEntity parent) {
    return new CollisionObject
      (new SpritedObject
       (new DynamicObject
        (new ExpirableObject
         (game.createEntity(parent.owner(), parent.getX(), parent.getY()), this.spec.projectileDurability()),
         new DummyController(), this.direction),
        this.projectileSprite));
  }
  void trigger(final GameEntity entity) {
    if(fireCooldown <= 0) {
      fireCooldown = 1 / spec.firingRate();
      game.addChild(createProjectile(entity));
    }
  }
}

class CanonObject extends GameEntityWrap<GameEntity> {
  final Canon canon;
  CanonObject(final GameEntity origin, final Canon canon) {
    super(origin);
    this.canon = canon;
  }
  @Override
  void update(float dt) {
    super.update(dt);
    canon.update(dt);
    canon.trigger(this);
  }
}
