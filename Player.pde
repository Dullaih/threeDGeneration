class Player extends AABB {
  
  Player(float xPos, float yPos, float zPos) {
    x = xPos;
    y = yPos;
    z = zPos;

    setSize(75, 75, 75);
  }

  void update() {
    
    if (Keyboard.isDown(Keyboard.LEFT)) {
      velocity.x = -250;
    }
    if (Keyboard.isDown(Keyboard.RIGHT)) {
      velocity.x = 250;
    }
    if (Keyboard.isDown(Keyboard.UP)) {
      velocity.z = -250;
    }
    if (Keyboard.isDown(Keyboard.DOWN)) {
      velocity.z = 250;
    }
    if(Keyboard.isDown(Keyboard.SPACE)) {
      velocity.y = 100;
    }
    if(Keyboard.isDown(Keyboard.SHIFT)) {
      velocity.y = -100;
    }
    
    x += velocity.x * dt;
    y += velocity.y * dt;
    z += velocity.z * dt;
    
    velocity.x *= 0.95;
    velocity.y *= 0.95;
    velocity.z *= 0.95;
    
    playerCamera();
    
    super.update();
  }

  void draw() {
    noFill();
    pushMatrix();
    translate(x, y, z);
    //rotate(angle);
    box(w, h, d);
    popMatrix();
  }
  
  @Override void applyFix(PVector fix) {
    x += fix.x;
    y += fix.y;
    z += fix.z;
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
    if (fix.z != 0) {
      // If we move the player up or down, the player must have hit a floor or ceiling, so we set vertical velocity to zero.
      velocity.y = 0;
      if (fix.z < 0) {
        // If we move the player up, we must have hit a floor.
      }
      if (fix.z > 0) {
        // If we move the player down, we must have hit our head on a ceiling.
      }
    }
    // recalculate AABB (since we moved the object AND we might have other collisions to fix yet this frame):
    calcAABB();
  }
  
  void playerCamera() {
    camera(x, y, z, x-1000, map(mouseY, 0, height, -height*2, height*2), map(-mouseX, 0, -width, width*2, -width*2), 0.0, 1.0, 0.0);
    //angle = atan2(x+mouseX, y+mouseY);
  }
}
