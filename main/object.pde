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

enum EntityType {
  WORLD(-1),
  SHIP(0),
  PROJECTILE(1),
  STATIC(2),
  BONUS(3);

  final int id;
  EntityType(final int id) {
    this.id = id;
  }
}

interface Updatable {
  void update(final float dt);
}

interface Drawable {
  void beginDraw();
  void endDraw();
}

interface Composite extends Updatable {
  void addChild(final GameEntity child);
  void removeChild(final GameEntity child);
  ArrayList<GameEntity> children();
}

interface Positionable {
  float getX();
  float getY();
  float getAngle();
  void setX(final float x);
  void setY(final float y);
  void setAngle(final float angle);
}

interface Identifiable {
  int getId();
}

interface GameEntity extends Composite,
                             Positionable,
                             Drawable,
                             Identifiable,
                             Rectangle {
  EntityType getType();
  Player owner();
  void setDestroyable(final boolean destroyable);
  boolean shouldBeDestroyed();
  ArrayList<GameEvent> collides(final GameEntity a, final GameEntity b);
}

class GameEntityImpl implements GameEntity {
  final int id;
  final EntityType type;
  final ArrayList<GameEntity> childs;
  final Player owner;
  final CollisionBehavior collisionBehavior;
  float x;
  float y;
  float angle;
  float height;
  float width;
  boolean destroyable;
  GameEntityImpl(final EntityType type,
                 final Player owner,
                 final int id,
                 final float x,
                 final float y,
                 final CollisionBehavior collisionBehavior) {
    this(type, owner, id, x, y, 0, 0, collisionBehavior);
  }
  GameEntityImpl(final EntityType type,
                 final Player owner,
                 final int id,
                 final float x,
                 final float y,
                 final float width,
                 final float height,
                 final CollisionBehavior collisionBehavior) {
    this(type, owner, id, x, y, width, height, 0, collisionBehavior);
  }
  GameEntityImpl(final EntityType type,
                 final Player owner,
                 final int id,
                 final float x,
                 final float y,
                 final float width,
                 final float height,
                 final float angle,
                 final CollisionBehavior collisionBehavior) {
    this.type = type;
    this.id = id;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.angle = angle;
    this.owner = owner;
    this.destroyable = false;
    this.collisionBehavior = collisionBehavior;
    this.childs = new ArrayList<GameEntity>();
  }
  @Override
  EntityType getType() {
    return this.type;
  }
  @Override
  Player owner() {
    return this.owner;
  }
  @Override
  int getId() {
    return this.id;
  }
  @Override
  boolean shouldBeDestroyed() {
    return this.destroyable;
  }
  @Override
  void setDestroyable(final boolean destroyable) {
    this.destroyable = destroyable;
  }
  @Override
  ArrayList<GameEntity> children() {
    ArrayList<GameEntity> children = new ArrayList<GameEntity>();
    children.addAll(this.childs);
    for(GameEntity child : this.childs) {
      children.addAll(child.children());
    }
    return children;
  }
  @Override
  void update(final float dt) {
    for(int i = this.childs.size() - 1; i >= 0; i--) {
      this.childs.get(i).update(dt);
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
  void addChild(final GameEntity child) {
    this.childs.add(child);
  }
  @Override
  void removeChild(final GameEntity child) {
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
  @Override
  float getAngle() {
    return this.angle;
  }
  @Override
  void setAngle(final float angle) {
    this.angle = angle;
  }
  @Override
  ArrayList<GameEvent> collides(final GameEntity a, final GameEntity b) {
    return this.collisionBehavior.collides(a, b);
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
  @Override
  float getWidth() {
    return this.width;
  }
  @Override
  float getHeight() {
    return this.height;
  }
}

class GameEntityWrap<T extends GameEntity> implements GameEntity {
  final T origin;
  GameEntityWrap(final T origin) {
    this.origin = origin;
  }
  @Override
  EntityType getType() {
    return this.origin.getType();
  }
  @Override
  Player owner() {
    return this.origin.owner();
  }
  @Override
  int getId() {
    return this.origin.getId();
  }
  @Override
  boolean shouldBeDestroyed() {
    return this.origin.shouldBeDestroyed();
  }
  @Override
  void setDestroyable(final boolean destroyable) {
    this.origin.setDestroyable(destroyable);
  }
  @Override
  ArrayList<GameEntity> children() {
    return this.origin.children();
  }
  @Override
  void update(final float dt) {
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
  void addChild(final GameEntity child) {
    this.origin.addChild(child);
  }
  @Override
  void removeChild(final GameEntity child) {
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
  void setX(final float x) {
    this.origin.setX(x);
  }
  @Override
  void setY(final float y) {
    this.origin.setY(y);
  }
  @Override
  float getAngle() {
    return this.origin.getAngle();
  }
  @Override
  void setAngle(final float angle) {
    this.origin.setAngle(angle);
  }
  @Override
  ArrayList<GameEvent> collides(final GameEntity a, final GameEntity b) {
    return this.origin.collides(a, b);
  }
  @Override
  boolean intersect(final Rectangle other) {
    return this.origin.intersect(other);
  }
  @Override
  float getWidth() {
    return this.origin.getWidth();
  }
  @Override
  float getHeight() {
    return this.origin.getHeight();
  }
}
