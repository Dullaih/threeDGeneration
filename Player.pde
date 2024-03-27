class Player extends AABB {

  int level = 1;

  Player(float xPos, float yPos) {
    x = xPos;
    y = yPos;

    setSize(75, 75);
  }

  void update() {
    
    calcAngleToMouse();
    
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
    pushMatrix();
    translate(x, y);
    rotate(angle);
    rect(-halfW, -halfH, w, h);
    popMatrix();
  }
  
  @Override void applyFix(PVector fix) {
    x += fix.x;
    y += fix.y;
    if (fix.x != 0) {
      // If we move the player left or right, the player must have hit a wall, so we set horizontal velocity to zero.
      velocity.x = 0;
    }
    if (fix.y != 0) {
      // If we move the player up or down, the player must have hit a floor or ceiling, so we set vertical velocity to zero.
      velocity.y = 0;
      if (fix.y < 0) {
        // If we move the player up, we must have hit a floor.
      }
      if (fix.y > 0) {
        // If we move the player down, we must have hit our head on a ceiling.
      }
    }
    // recalculate AABB (since we moved the object AND we might have other collisions to fix yet this frame):
    calcAABB();
  }
}
