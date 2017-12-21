// sprite.pde ---

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

interface Visible extends GameEntity {
  Sprite getSprite();
}

class SpritedObject extends GameEntityWrap<GameEntity> implements Visible {
  final float opacity;
  final Sprite sprite;
  SpritedObject(final GameEntity origin, final Sprite sprite) {
    this(origin, sprite, 255);
  }
  SpritedObject(final GameEntity origin, final Sprite sprite, final float opacity) {
    super(origin);
    this.opacity = opacity;
    this.sprite = sprite;
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    if(isActive()) {
      tint(255, this.opacity);
      image(this.sprite.img, 0, 0);
      tint(255, 255);
    }
  }
  Sprite getSprite() {
    return this.sprite;
  }
}
