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

import java.util.function.*;
import java.util.Arrays;

interface Game extends GameEntity {
}

class GameImpl extends GameEntityImpl implements Game {
  int nextEntityId;
  final Atlas atlas;
  GameImpl(final int x, final int y) {
    super(EntityType.WORLD, Player.NEUTRAL, "world", x, y);
    this.nextEntityId = 1;
    this.atlas = setupAtlas();
    addChild(createAlly(400, 500, "playerShip1_green.png"));
    addChild(createStatic(Player.ENEMY, 400, 600, atlas.get("meteorBrown_big1.png")));
    addChild(createEnemy(400, 200, "enemyBlack1.png"));
  }
  @Override
  void update(final float dt) {
    super.update(dt);
    super.updateChildren(dt);
    final ArrayList<GameEntity> entities = children();
    for(int i = 0; i < entities.size() - 1; i++) {
      final GameEntity a = entities.get(i);
      for(int j = i + 1; j < entities.size(); j++) {
        final GameEntity b = entities.get(j);
        if(!a.isActive()) {
          break;
        }
        if(!b.isActive()) {
          continue;
        }
        if(a.owner() != b.owner()) {
          if(a.intersect(b) && b.intersect(a)) {
            a.collides(b);
            b.collides(a);
          }
        }
      }
    }
  }
  @Override
  void beginDraw() {
    super.beginDraw();
    noStroke();
    background(127);
  }
  Canon createBasicCanon(final String sprite, final String collisionSprite, final PVector direction) {
    return new BasicCanon(atlas.get(sprite),
                          atlas.get(collisionSprite),
                          direction,
                          500,
                          2,
                          1,
                          2,
                          0.5);
  }
  GameEntity createAlly(final float x, final float y, final String sprite) {
    return createShip(Player.ALLY,
                      x,
                      y,
                      new KeyboardController(),
                      sprite,
                      "playerShip1_damage1.png",
                      Integer.MAX_VALUE,
                      createBasicCanon("laserBlue03.png", "laserBlue08.png", new PVector(0, -1)));
  }
  GameEntity createEnemy(final float x, final float y, final String sprite) {
      return createShip(Player.ENEMY,
                        x,
                        y,
                        new AiController(),
                        sprite,
                        "laserRed08.png",
                        4,
                        createBasicCanon("laserRed03.png", "laserRed08.png", new PVector(0, 1)));

  }
  GameEntity createStatic(final Player owner, final float x, final float y, final Sprite sprite) {
    return createEntity(EntityType.STATIC,
                        owner,
                        sprite,
                        x,
                        y);
  }
  GameEntity createShip(final Player player,
                        final float x,
                        final float y,
                        final Controller controller,
                        final String shipSprite,
                        final String collisionSprite,
                        final int durability,
                        final Canon canon) {
    return new CanonObject
      (new RatioHud
       (new CollisionObject
        (new DurableObject
         (new CollisionEffectObject
          (new FrictionObject
           (new DynamicObject
            (createEntity(EntityType.SHIP, player, atlas.get(shipSprite), x, y),
             controller,
             new PVector(0, 0),
             new PVector(500, 500)),
            0.05),
           atlas.get(collisionSprite),
           0.5),
          durability),
         Collision.IGNORE_OWNER(player)),
        0, 30),
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
        id + "/" + player + "/" + type + "/" + nextEntityId++,
        x,
        y,
        sprite.getWidth(),
        sprite.getHeight()),
       sprite);
  }
}
