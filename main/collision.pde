// collision.pde ---

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

import java.util.function.*;

interface Durable extends GameEntity {
  int getMaxDurability();
  int getDurability();
  void setDurability(final int durability);
}

static class Collision {
  static final Predicate<GameEntity> IGNORE_OWNER(final Player player) {
    return new Predicate<GameEntity>() {
      public boolean test(final GameEntity entity) {
        return entity.owner() == player;
      }
    };
  }
}

class CollisionEffectObject extends GameEntityWrap<GameEntity> {
  final Sprite sprite;
  final float duration;
  CollisionEffectObject(final GameEntity origin, final Sprite sprite, final float duration) {
    super(origin);
    this.sprite = sprite;
    this.duration = duration;
  }
  @Override
  void collides(final GameEntity entity) {
    super.collides(entity);
    addChild
      (new ParentPositionObject
       (new ExpirableObject
        (new SpritedObject
         (createChild
          (EntityType.EFFECT,
           this.getX(),
           this.getY(),
           this.sprite.getWidth(),
           this.sprite.getHeight()),
          this.sprite),
         this.duration)));
  }
}

class CollisionObject extends GameEntityWrap<Durable> implements Durable {
  final Predicate<GameEntity> ignorableEntityPredicate;
  CollisionObject(final Durable origin, final Predicate<GameEntity> predicate) {
    super(origin);
    this.ignorableEntityPredicate = predicate;
  }
  @Override
  void collides(final GameEntity entity) {
    if(this.getDurability() <= 0)
      return;
    if(this.ignorableEntityPredicate.test(entity))
      return;
    super.collides(entity);
    this.setDurability(this.getDurability() - 1);
  }
  @Override
  int getDurability() {
    return this.origin.getDurability();
  }
  @Override
  int getMaxDurability() {
    return this.origin.getMaxDurability();
  }
  @Override
  void setDurability(final int durability) {
    this.origin.setDurability(durability);
  }
  @Override
  boolean intersect(final Rectangle other) {
    final float halfWidth = this.getWidth() / 2;
    final float halfHeight = this.getHeight() / 2;
    final float upperLeftX = this.getX() - halfWidth;
    final float upperLeftY = this.getY() - halfHeight;
    final float halfWidthA = other.getWidth() / 2;
    final float halfHeightA = other.getHeight() / 2;
    final float upperLeftXA = other.getX() - halfWidthA;
    final float upperLeftYA = other.getY() - halfHeightA;
    if(upperLeftX + this.getWidth() < upperLeftXA || upperLeftY + this.getHeight() < upperLeftYA) {
      return false;
    }
    if(upperLeftXA + other.getWidth() < upperLeftX || upperLeftYA + other.getHeight() < upperLeftYA) {
      return false;
    }
    return true;
  }
}

class DurableObject extends GameEntityWrap<GameEntity> implements Durable {
  final int maxDurability;
  int durability;
  DurableObject(final GameEntity origin, final int maxDurability) {
    super(origin);
    this.maxDurability = maxDurability;
    this.durability = maxDurability;
  }
  @Override
  void update(final float dt) {
    super.update(dt);
    if(this.durability <= 0) {
      this.setDestroyable(true);
    }
  }
  @Override
  int getDurability() {
    return this.durability;
  }
  @Override
  int getMaxDurability() {
    return this.maxDurability;
  }
  @Override
  void setDurability(final int durability) {
    this.durability = durability;
  }
}
