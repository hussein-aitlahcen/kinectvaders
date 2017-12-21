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
  int getDurability();
  float getDuration();
  PVector getVelocity();
  float getFiringRate();
  Sprite getSprite();
  Sprite getCollisionSprite();
  float getCollisionDuration();
}

class BasicCanon implements Canon {
  final Sprite sprite;
  final Sprite collisionSprite;
  final PVector velocity;
  final float duration;
  final int durability;
  final float firingRate;
  final float collisionDuration;
  BasicCanon(final Sprite sprite,
             final Sprite collisionSprite,
             final PVector direction,
             final float velocity,
             final float duration,
             final int durability,
             final float firingRate,
             final float collisionDuration) {
    this.sprite = sprite;
    this.collisionSprite = collisionSprite;
    this.velocity = PVector.mult(direction, velocity);
    this.duration = duration;
    this.durability = durability;
    this.firingRate = firingRate;
    this.collisionDuration = collisionDuration;
  }
  @Override
  float getDuration() {
    return this.duration;
  }
  @Override
  int getDurability() {
    return this.durability;
  }
  @Override
  PVector getVelocity() {
    return this.velocity;
  }
  @Override
  float getFiringRate() {
    return this.firingRate;
  }
  @Override
  Sprite getSprite() {
    return this.sprite;
  }
  @Override
  Sprite getCollisionSprite() {
    return this.collisionSprite;
  }
  @Override
  float getCollisionDuration() {
    return this.collisionDuration;
  }
}

class CanonObject extends GameEntityWrap<GameEntity> {
  final Canon canon;
  float fireCooldown;
  CanonObject(final GameEntity origin, final Canon canon) {
    super(origin);
    this.canon = canon;
    this.fireCooldown = 0;
  }
  @Override
  void update(final float dt) {
    super.update(dt);
    this.fireCooldown -= dt;
    if(fireCooldown <= 0) {
      fireCooldown = 1 / canon.getFiringRate();
      getParent().addChild
         (new ExpirableObject
          (new CollisionObject
           (new DurableObject
            (new CollisionEffectObject
             (new DynamicObject
              (new SpritedObject
               (new GameEntityImpl(this.getParent(),
                                   EntityType.PROJECTILE,
                                   this.getOwner(),
                                   this.getNextChildId(),
                                   getX(),
                                   getY(),
                                   canon.getSprite().getWidth(),
                                   canon.getSprite().getWidth(),
                                   0f),
                canon.getSprite()),
               new DummyController(),
               canon.getVelocity(),
               canon.getVelocity()),
              canon.getCollisionSprite(),
              canon.getCollisionDuration()),
             canon.getDurability()),
             Collision.IGNORE_OWNER(this.getOwner())),
           canon.getDuration()));
    }
  }
}
