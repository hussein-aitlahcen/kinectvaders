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

import java.util.Arrays;
import java.util.ArrayDeque;

interface Game extends GameEntity {
  void onEvents(final ArrayList<GameEvent> event);
  GameEntity createEntity(final EntityType type,
                          final Player player,
                          final Sprite sprite,
                          final float x,
                          final float y);
}

class GameImpl extends GameEntityImpl implements Game {
  int nextEntityId;
  final ArrayDeque<GameEvent> eventQueue;
  final Atlas atlas;
  GameImpl(int x, int y) {
    super(EntityType.WORLD, Player.NEUTRAL, 0, x, y, new DummyCollisionBehavior());
    this.nextEntityId = 1;
    this.eventQueue = new ArrayDeque<GameEvent>();
    this.atlas = setupAtlas();
    addChild(createAlly(400, 500, "playerShip1_green.png"));
    addChild(createStatic(Player.ENEMY, 400, 600, "meteorBrown_big1.png"));
    addChild(createEnemy(400, 200, "enemyBlack1.png"));
  }
  @Override
  ArrayList<GameEntity> children() {
    final ArrayList<GameEntity> entities = super.children();
    entities.remove(this);
    return entities;
  }
  @Override
  void update(final float dt) {
    super.update(dt);
    final ArrayList<GameEntity> entities = children();
    for(int i = 0; i < entities.size() - 1; i++) {
      for(int j = i + 1; j < entities.size(); j++) {
        final GameEntity a = entities.get(i);
        final GameEntity b = entities.get(j);
        if(a.shouldBeDestroyed()) {
          onEvent(new DestructionEvent(a));
          continue;
        }
        if(b.shouldBeDestroyed()) {
          continue;
        }
        if(a.owner() != b.owner()) {
          if(a.intersect(b) && b.intersect(a)) {
            onEvents(a.collides(a, b));
            onEvents(b.collides(b, a));
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
  void onEvent(final GameEvent event) {
    this.eventQueue.offer(event);
  }
  @Override
  void onEvents(final ArrayList<GameEvent> events) {
    for(GameEvent event : events) {
      onEvent(event);
    }
  }
  void processEvents() {
    while(this.eventQueue.size() > 0) {
      final GameEvent event = this.eventQueue.poll();
      if(event instanceof DestructionEvent) {
        processDestruction((DestructionEvent)event);
      }
    }
  }
  void processDestruction(final DestructionEvent event) {
    this.removeChild(event.entity);
  }
  GameEntity createAlly(final float x,
                        final float y,
                        final String sprite) {
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
  GameEntity createEnemy(final float x,
                         final float y,
                         final String sprite) {
      return createShip(Player.ENEMY,
                        x,
                        y,
                        new AiController(),
                        sprite,
                        new BasicCanon(new BasicCanonSpec(),
                                       atlas.get("laserRed03.png"),
                                       new PVector(0, 1),
                                       this));
  }
  GameEntity createStatic(final Player owner,
                          final float x,
                          final float y,
                          final String sprite) {
    return createEntity(EntityType.STATIC,
                        owner,
                        atlas.get(sprite),
                        x,
                        y);
  }
  GameEntity createShip(final Player player,
                        final float x,
                        final float y,
                        final Controller controller,
                        final String shipSprite,
                        final Canon canon) {
    return new CanonObject
      (new FrictionObject
       (new DynamicObject
        (createEntity(EntityType.SHIP, player, atlas.get(shipSprite), x, y),
         controller)),
       canon);
  }
  GameEntity createEntity(final EntityType type,
                          final Player player,
                          final Sprite sprite,
                          final float x,
                          final float y) {
    return new SpritedObject
      (new GameEntityImpl
       (type,
        player,
        nextEntityId++,
        x,
        y,
        sprite.img.width,
        sprite.img.height,
        new CompositeCollisionBehavior(composeCollision(new DestroyOnEntityCollision(EntityType.PROJECTILE),
                                                        new DestroyOnEntityCollision(EntityType.SHIP)))),
        sprite);
  }

  ArrayList<CollisionAtomicBehavior> composeCollision(final CollisionAtomicBehavior... behaviors) {
    return new ArrayList<CollisionAtomicBehavior>(Arrays.asList(behaviors));
  }
}
