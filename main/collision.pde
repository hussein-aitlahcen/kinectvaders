// collision.pde ---

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

interface CollisionBehavior {
  ArrayList<GameEvent> collides(final GameEntity a, final GameEntity b);
}

interface CollisionAtomicBehavior {
  GameEvent collides(final GameEntity a, final GameEntity b);
}

final class CompositeCollisionBehavior implements CollisionBehavior {
  final ArrayList<CollisionAtomicBehavior> atomicBehaviors;
  CompositeCollisionBehavior(final ArrayList<CollisionAtomicBehavior> atomicBehaviors) {
    this.atomicBehaviors = atomicBehaviors;
  }
  @Override
  ArrayList<GameEvent> collides(final GameEntity a, final GameEntity b) {
    final ArrayList<GameEvent> events = new ArrayList<GameEvent>();
    for(CollisionAtomicBehavior atomicBehavior : this.atomicBehaviors) {
      events.add(atomicBehavior.collides(a, b));
    }
    return events;
  }
}

final class DestroyOnEntityCollision implements CollisionAtomicBehavior {
  final EntityType type;
  DestroyOnEntityCollision(final EntityType type) {
    this.type = type;
  }
  @Override
  GameEvent collides(final GameEntity a, final GameEntity b) {
    if(b.getType() == this.type) {
      return new DestructionEvent(a);
    }
    return GameEvent.BASIC_NO_OPERATION;
  }
}

final class DummyCollisionBehavior implements CollisionBehavior {
  @Override
  ArrayList<GameEvent> collides(final GameEntity a, final GameEntity b) {
    return new ArrayList<GameEvent>();
  }
}
