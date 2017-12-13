// main.pde ---

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

int nextTick;
int tickStep;

Window win;

void setupGlobal(Atlas atlas) {
  tickStep = 33;
  nextTick = 0;
  win = new Window(0, 0);
  GameEntity ship = new FrictionObject
    (new DynamicObject
     (new SpritedObject
      (new GameEntityImpl(400, 300),
       atlas.get("playerShip1_green.png")),
      new KeyboardController()));
  win.addChild(ship);
}

void setup() {
  size(1200, 800);
  imageMode(CENTER);
  setupGlobal(setupAtlas());
}

void computeNextTick() {
  nextTick = millis() + tickStep;
}

boolean shouldDraw() {
  return millis() >= nextTick;
}

void draw() {
  while(!shouldDraw()) {
    // wait until the next tick to draw
  }
  float dt = tickStep / 1000.0;
  win.update(dt);
  win.beginDraw();
  win.endDraw();
  computeNextTick();
}
