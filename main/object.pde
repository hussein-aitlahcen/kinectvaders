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
                             Identifiable {
}

class GameEntityImpl implements GameEntity {
  final int id;
  float x;
  float y;
  float angle;
  final ArrayList<GameEntity> childs;
  final Player owner;
  GameEntityImpl(final Player owner, final int id, final int x, final int y) {
    this(owner, id, x, y, 0);
  }
  GameEntityImpl(final Player owner, final int id, final int x, final int y, final float angle) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.owner = owner;
    this.childs = new ArrayList<GameEntity>();
  }
  @Override
  int getId() {
    return this.id;
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
    for(GameEntity child : this.childs) {
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
}

class GameEntityWrap<T extends GameEntity> implements GameEntity {
  final T origin;
  GameEntityWrap(final T origin) {
    this.origin = origin;
  }
  @Override
  int getId() {
    return this.origin.getId();
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
}
