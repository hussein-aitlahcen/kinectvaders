// rectangle.pde ---

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

final class Rectangle {
  final float x;
  final float y;
  final float width;
  final float height;
  Rectangle(final float x, final float y, final float width, final float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  boolean intersect(final Rectangle other) {
    if(x + width < other.x || y + height < other.y) {
      return false;
    }
    if(other.x + other.width < x || other.y + other.height < y) {
      return false;
    }
    return true;
  }

  @Override
  String toString() {
    return "x=" + x + ", y=" + y + ", w=" + width + ", h=" + height;
  }
}
