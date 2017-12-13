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
