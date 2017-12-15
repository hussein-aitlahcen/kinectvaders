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
  GameEntity createEntity(final Player owner, final float x, final float y);
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
        if(a.shouldBeDestroyed()) {
          onEvent(new DestructionEvent(a));
        }
        if(b.shouldBeDestroyed()) {
          onEvent(new DestructionEvent(b));
        }
        if(a.shouldBeDestroyed() || b.shouldBeDestroyed()) {
          continue;
        }
        if((a instanceof Collidable) && (b instanceof Collidable)) {
          final Collidable ca = (Collidable)a;
          final Collidable cb = (Collidable)b;
          if(ca.collides(cb)) {
            onEvent(new CollisionEvent(ca, cb));
          }
        }
      }
    }
    processEvents();
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    noStroke();
    background(127);
  }
  @Override
  void onEvent(GameEvent event) {
    this.eventQueue.offer(event);
  }
  void processEvents() {
    while(this.eventQueue.size() > 0) {
      final GameEvent event = this.eventQueue.poll();
      if(event instanceof CollisionEvent) {
        processCollision((CollisionEvent)event);
      }
      else if(event instanceof DestructionEvent) {
        processDestruction((DestructionEvent)event);
      }
    }
  }
  void processCollision(final CollisionEvent event) {
    if(event.source.owner() != event.target.owner()) {
      onEvent(new DestructionEvent(event.source));
      onEvent(new DestructionEvent(event.target));
    }
  }
  void processDestruction(final DestructionEvent event) {
    this.removeChild(event.entity);
  }
  GameEntity createAlly(final float x, final float y, final String sprite) {
    return createShip(Player.ALLY,
                      x,
                      y,
                      new KeyboardController(),
                      sprite,
                      new BasicCanon(new BasicCanonSpec(),
                                     atlas.get("laserBlue03.png"),
                                     new PVector(0, -1),
                                     this));
  }
  GameEntity createEnemy(final float x, final float y, final String sprite) {
      return createShip(Player.ENEMY,
                        x,
                        y,
                        new AiController(),
                        sprite,
                        new BasicCanon(new BasicCanonSpec(),
                                       atlas.get("laserBlue03.png"),
                                       new PVector(0, 1),
                                       this));
  }
  GameEntity createShip(final Player player,
                        final float x,
                        final float y,
                        final Controller controller,
                        final String shipSprite,
                        final Canon canon) {
    return new CollisionObject
      (new SpritedObject
       (new CanonObject
        (new FrictionObject
         (new DynamicObject
          (createEntity(player, x, y),
           controller)),
         canon),
        atlas.get(shipSprite)));
  }
  GameEntity createEntity(final Player player, final float x, final float y) {
    return new GameEntityImpl(player, nextEntityId++, x, y);
  }
}
