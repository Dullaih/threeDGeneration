class Player extends AABB {
  
  float rotationAngle, elevationAngle, direction;

  Player(float xPos, float yPos, float zPos) {
    x = xPos;
    y = yPos;
    z = zPos;

    setSize(75, 75, 75);
  }

  void update() {
    playerCamera();

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
    if (Keyboard.isDown(Keyboard.SPACE)) {
      velocity.y = 100;
    }
    if (Keyboard.isDown(Keyboard.SHIFT)) {
      velocity.y = -100;
    }

    x += velocity.x * dt;
    y += velocity.y * dt;
    z += velocity.z * dt;

    velocity.x *= 0.95;
    velocity.y *= 0.95;
    velocity.z *= 0.95;

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
    rotationAngle = map(mouseX, 0, width, 0, TWO_PI);
    elevationAngle = map(mouseY, 0, height, 0, PI);
    

    float centerX = cos(rotationAngle) * sin(elevationAngle);
    float centerY = -cos(elevationAngle);
    float centerZ = sin(rotationAngle) * sin(elevationAngle);
    camera(x, y, z, centerX*1000, centerY*1000, centerZ*1000, 0.0, 1.0, 0.0);

    println(cos(rotationAngle/2) + " | " + centerX + " | " + centerY + " | " + centerZ);
  }
}
