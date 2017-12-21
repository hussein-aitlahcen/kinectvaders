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
  EFFECT(3),
  BONUS(4);

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
  void updateChildren(final float dt);
  ArrayList<GameEntity> children();
}

interface Positionable {
  float getAbsX();
  float getAbsY();
  float getX();
  float getY();
  float getWidth();
  float getHeight();
  float getAngle();
  void setX(final float x);
  void setY(final float y);
  void setAngle(final float angle);
  void pushM();
  void popM();
}

interface Identifiable {
  String getId();
}

interface GameEntity extends Composite,
                             Positionable,
                             Drawable,
                             Identifiable {
  GameEntity getParent(final int level);
  EntityType getType();
  Player getOwner();
  int getNextChildId();
  void setDestroyable(final boolean destroyable);
  boolean shouldBeDestroyed();
  boolean isActive();
  boolean intersect(final GameEntity entity);
  void collides(final GameEntity entity);
}

class GameEntityImpl implements GameEntity {
  final GameEntity parent;
  final int id;
  final EntityType type;
  final ArrayList<GameEntity> childs;
  final Player owner;
  int nextChildId;
  float x;
  float y;
  float angle;
  float height;
  float width;
  boolean destroyable;
  GameEntityImpl(final GameEntity parent,
                 final EntityType type,
                 final Player owner,
                 final int id,
                 final float x,
                 final float y,
                 final float width,
                 final float height,
                 final float angle) {
    this.parent = parent;
    this.nextChildId = 0;
    this.type = type;
    this.id = id;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.angle = angle;
    this.owner = owner;
    this.destroyable = false;
    this.childs = new ArrayList<GameEntity>();
  }
  @Override
  int getNextChildId() {
    return this.nextChildId++;
  }
  @Override
  GameEntity getParent(final int level) {
    if(level == 0)
      return this.parent;
    return this.parent.getParent(level - 1);
  }
  @Override
  EntityType getType() {
    return this.type;
  }
  @Override
  Player getOwner() {
    return this.owner;
  }
  @Override
  String getId() {
    if(this.parent == null)
      return "root/" + this.type + "/" + this.id;
    return this.parent.getId() + "/" + this.type + "/" + this.id;
  }
  @Override
  boolean shouldBeDestroyed() {
    return this.children().size() == 0 && this.destroyable;
  }
  @Override
  boolean isActive() {
    return !this.destroyable;
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
  }
  @Override
  void updateChildren(final float dt) {
    for(int i = this.childs.size() - 1; i >= 0; i--) {
      final GameEntity child = this.childs.get(i);
      if(child.isActive()) {
        child.update(dt);
      }
      child.updateChildren(dt);
      if(child.shouldBeDestroyed()) {
        this.childs.remove(child);
      }
    }
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
  float getAbsX() {
    if(this.parent == null) {
      return this.x;
    }
    return this.parent.getAbsX() + this.x;
  }
  @Override
  float getAbsY() {
    if(this.parent == null) {
      return this.y;
    }
    return this.parent.getAbsY() + this.y;
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
  void pushM() {
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.angle);
  }
  void popM() {
    popMatrix();
  }
  @Override
  void beginDraw() {
    pushM();
  }
  @Override
  void endDraw() {
    for(GameEntity child : this.childs) {
      child.beginDraw();
      child.endDraw();
    }
    popM();
  }
  @Override
  void collides(final GameEntity entity) {
  }
  @Override
  boolean intersect(final GameEntity other) {
    return false;
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
  int getNextChildId() {
    return this.origin.getNextChildId();
  }
  @Override
  GameEntity getParent(final int level) {
    return this.origin.getParent(level);
  }
  GameEntity getParent() {
    return this.origin.getParent(0);
  }
  @Override
  EntityType getType() {
    return this.origin.getType();
  }
  @Override
  Player getOwner() {
    return this.origin.getOwner();
  }
  @Override
  String getId() {
    return this.origin.getId();
  }
  @Override
  boolean shouldBeDestroyed() {
    return this.origin.shouldBeDestroyed();
  }
  @Override
  boolean isActive() {
    return this.origin.isActive();
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
  void updateChildren(final float dt) {
    this.origin.updateChildren(dt);
  }
  @Override
  void pushM() {
    this.origin.pushM();
  }
  @Override
  void popM() {
    this.origin.popM();
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
  float getAbsX() {
    return this.origin.getAbsX();
  }
  @Override
  float getAbsY() {
    return this.origin.getAbsY();
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
  void collides(final GameEntity entity) {
    this.origin.collides(entity);
  }
  @Override
  boolean intersect(final GameEntity other) {
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
