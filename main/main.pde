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

HashMap<Integer, Boolean> keys;
double nextTick;
double tickStep;
double nextDraw;
double drawStep;
double lastTick;
int gameWidth = 1600;
int gameHeight = 1000;
Game game;

void setup() {
  size(1600, 1000);
  imageMode(CENTER);
  rectMode(CENTER);
  keys = new HashMap<Integer, Boolean>();
  tickStep = 1000 / 128;
  drawStep = 1000 / 40;
  nextTick = 0;
  game = new GameImpl(0, 0);
}

void checkUpdate() {
  if(millis() < nextTick)
    return;
  double begin = millis();
  float dt = (float)(begin - lastTick) * 0.001;
  lastTick = begin;
  game.update(dt);
  game.beginDraw();
  game.endDraw();
  double end = millis();
  double lag = end - begin;
  nextTick = begin + tickStep - lag;
}

void checkDraw() {
  if(millis() < nextDraw)
    return;
  double begin = millis();
  game.beginDraw();
  game.endDraw();
  double end = millis();
  double lag = end - begin;
  nextDraw = begin + drawStep - lag;
}

void draw() {
  checkUpdate();
  checkDraw();
}

void keyPressed() {
  toggleKeyPressed(keyCode, true);
}

void keyReleased() {
  toggleKeyPressed(keyCode, false);
}

boolean isKeyPressed(final int code) {
  if(keys.containsKey(code)) {
    return keys.get(code);
  }
  return false;
}

void toggleKeyPressed(final int code, final boolean pressed) {
  keys.put(code, pressed);
}
