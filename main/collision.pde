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

interface Collidable extends GameEntity, Visible {
  Rectangle getArea();
  boolean collides(final Collidable target);
}

class NonCollisionObject extends GameEntityWrap<Visible> implements Collidable {
  NonCollisionObject(final Visible origin) {
    super(origin);
  }
  @Override
  Sprite getSprite() {
    return this.origin.getSprite();
  }
  Rectangle getArea() {
    return new Rectangle(0, 0, 0, 0);
  }
  @Override
  boolean collides(final Collidable target) {
    return false;
  }
}

class CollisionObject extends GameEntityWrap<Visible> implements Collidable {
  CollisionObject(final Visible origin) {
    super(origin);
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    final Rectangle area = this.getArea();
    fill(255, 255, 255, 50);
    rect(-area.width / 2, -area.height / 2, area.width, area.height);
  }
  @Override
  Sprite getSprite() {
    return this.origin.getSprite();
  }
  @Override
  Rectangle getArea() {
    final Sprite sprite = this.getSprite();
    final float spriteHalfWidth = sprite.width() / 2.0;
    final float spriteHalfHeight = sprite.height() / 2.0;
    return new Rectangle(getX() - spriteHalfWidth,
                         getY() - spriteHalfHeight,
                         sprite.width(),
                         sprite.height());

  }
  @Override
  boolean collides(final Collidable target) {
    if(target instanceof NonCollisionObject)
      return false;
    final Rectangle sourceArea = getArea();
    final Rectangle targetArea = target.getArea();
    return sourceArea.intersect(targetArea);
  }
}
