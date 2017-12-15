// game.pde ---

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

import java.util.ArrayDeque;

interface Game extends GameEntity {
  void onEvent(final GameEvent event);
}

class GameImpl extends GameEntityImpl implements Game {
  int nextEntityId;
  final ArrayDeque<GameEvent> eventQueue;
  final Atlas atlas;
  GameImpl(int x, int y) {
    super(Player.NEUTRAL, 0, x, y);
    this.nextEntityId = 1;
    this.eventQueue = new ArrayDeque<GameEvent>();
    this.atlas = setupAtlas();
    addChild(createAlly(400, 500, "playerShip1_green.png"));
    addChild(createEnemy(400, 200, "enemyBlack1.png"));
  }
  @Override
  ArrayList<GameEntity> children() {
    final ArrayList<GameEntity> entities = super.children();
    entities.remove(this);
    return entities;
  }
  @Override
  void update(float dt) {
    super.update(dt);
    final ArrayList<GameEntity> entities = children();
    for(int i = 0; i < entities.size() - 1; i++) {
      for(int j = i + 1; j < entities.size(); j++) {
        final GameEntity a = entities.get(i);
        final GameEntity b = entities.get(j);
        if((a instanceof Collidable) && (b instanceof Collidable)) {
          final Collidable ca = (Collidable)a;
          final Collidable cb = (Collidable)b;
          if(ca.collides(cb)) {
            onEvent(new CollisionEvent(ca, cb));
          }
        }
      }
    }
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    background(127);
  }
  @Override
  void onEvent(GameEvent event) {
    this.eventQueue.offer(event);
  }
  GameEntity createAlly(final int x, final int y, final String sprite) {
    return createShip(Player.ALLY, x, y, new KeyboardController(), sprite);
  }
  GameEntity createEnemy(final int x, final int y, final String sprite) {
    return createShip(Player.ENEMY, x, y, new AiController(), sprite);
  }
  GameEntity createShip(final Player player, final int x, final int y, final Controller controller, final String sprite) {
    return new CollisionObject
      (new SpritedObject
       (new FrictionObject
        (new DynamicObject
         (new GameEntityImpl(player, nextEntityId++, x, y),
          controller)),
        atlas.get(sprite)));
  }
}
