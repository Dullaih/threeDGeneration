class Player extends AABB {

  int level = 1;

  Player(float xPos, float yPos) {
    x = xPos;
    y = yPos;

    setSize(75, 75);
  }

  void update() {
    if (Keyboard.isDown(Keyboard.LEFT)) {
      velocity.x = -250;
    }
    if (Keyboard.isDown(Keyboard.RIGHT)) {
      velocity.x = 250;
    }
    if (Keyboard.isDown(Keyboard.UP)) {
      velocity.y = -250;
    }
    if (Keyboard.isDown(Keyboard.DOWN)) {
      velocity.y = 250;
    }
    
    x += velocity.x * dt;
    y += velocity.y * dt;
    
    velocity.x *= 0.95;
    velocity.y *= 0.95;
    
    super.update();
  }

  void draw() {
    fill(#FF2483);
    rect(x - halfW, y - halfH, w, h);
  }
}
