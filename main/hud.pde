// text.pde ---

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

class RatioHud extends GameEntityWrap<Durable> {
  final float x;
  final float y;
  RatioHud(final Durable origin, final float x, final float y) {
    super(origin);
    this.x = x;
    this.y = y;
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    if(isActive()) {
      pushMatrix();
      translate(x, y);
      final float w = 60;
      final float h = 10;
      final float ratio = (float)Math.max(1, this.origin.getDurability()) / this.origin.getMaxDurability();
      if(ratio > 0.5) {
        fill(50, 200, 50);
      } else {
        fill(255, 69, 0);
      }
      rect(this.x, this.y, w * ratio, h);
      popMatrix();
    }
  }
}
