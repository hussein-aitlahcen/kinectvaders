// controller.pde ---

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

interface Controller {
  PVector impulsion();
}

class DummyController implements Controller {
  @Override
  PVector impulsion() {
    return new PVector(0, 0);
  }
}

class AiController implements Controller {
  @Override
  PVector impulsion() {
    return new PVector(0, 0);
  }
}

class KeyboardController implements Controller {
  @Override
  PVector impulsion() {
    return new PVector(impulsionX(), impulsionY());
  }
  int impulsionY() {
    if(isKeyPressed(DOWN)) {
      return 1;
    }
    else if(isKeyPressed(UP)) {
      return -1;
    }
    return 0;
  }
  int impulsionX() {
    if(isKeyPressed(RIGHT)) {
      return 1;
    }
    else if(isKeyPressed(LEFT)) {
      return -1;
    }
    return 0;
  }
}
