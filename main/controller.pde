interface Controller {
  PVector impulsion();
}

class KeyboardController implements Controller {
  PVector impulsion() {
    return new PVector(impulsionX(), impulsionY());
  }

  int impulsionY() {
    if(keyPressed && key == CODED) {
      if(keyCode == DOWN) {
        return 1;
      }
      else if(keyCode == UP) {
        return -1;
      }
    }
    return 0;
  }

  int impulsionX() {
    if(keyPressed && key == CODED) {
      if(keyCode == LEFT) {
        return -1;
      }
      else if(keyCode == RIGHT) {
        return 1;
      }
    }
    return 0;
  }
}
