// timer.pde ---

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

class ExpirableObject extends GameEntityWrap<GameEntity> {
  float cooldown;
  ExpirableObject(final GameEntity origin, final float cooldown) {
    super(origin);
    this.cooldown = cooldown;
  }
  @Override
  void update(float dt) {
    super.update(dt);
    this.cooldown -= dt;
    if(this.cooldown <= 0) {
      this.setDestroyable(true);
    }
  }
}
