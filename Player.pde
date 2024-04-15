class Player extends AABB {

  float rotationAngle, elevationAngle;
  float centerX, centerY, centerZ;
  float dx = 0, dy = 0;
  boolean isGrounded;
  float modifier = 1;
  float acceleration = 20;
  float speed = 600;
  PVector cameraPosition = new PVector();

  Player(float xPos, float yPos, float zPos) {
    x = xPos;
    y = yPos;
    z = zPos;

    setSize(75, 75, 75);
  }

  void update() {
    velocity.y += GRAVITY*dt;

    playerCamera();

    if (Keyboard.isDown(Keyboard.SHIFT) && isGrounded) {
      modifier = 1.5;
    }
    if (Keyboard.isDown(Keyboard.LEFT)) {
      velocity.x += sin(rotationAngle)*acceleration*modifier;
      velocity.z += cos(rotationAngle)*-acceleration*modifier;
    }
    if (Keyboard.isDown(Keyboard.RIGHT)) {
      velocity.x += sin(rotationAngle)*-acceleration*modifier;
      velocity.z += cos(rotationAngle)*acceleration*modifier;
    }
    if (Keyboard.isDown(Keyboard.UP)) {
      velocity.x += cos(rotationAngle)*acceleration*modifier;
      velocity.z += sin(rotationAngle)*acceleration*modifier;
    }
    if (Keyboard.isDown(Keyboard.DOWN)) {
      velocity.x += cos(rotationAngle)*-acceleration*modifier;
      velocity.z += sin(rotationAngle)*-acceleration*modifier;
    }
    if (Keyboard.isDown(Keyboard.SPACE) && isGrounded) {
      velocity.y = -speed;
    }

    if (velocity.x > speed*modifier) velocity.x = speed*modifier;
    if (velocity.x < -speed*modifier) velocity.x = -speed*modifier;
    if (velocity.z > speed*modifier) velocity.z = speed*modifier;
    if (velocity.z < -speed*modifier) velocity.z = -speed*modifier;

    x += velocity.x * dt;
    y += velocity.y * dt;
    z += velocity.z * dt;

    velocity.x *= 0.92;
    //velocity.y *= 0.95;
    velocity.z *= 0.92;

    isGrounded = false;
    modifier = 1;
    super.update();
  }

  void draw() {
    //noFill();
    pushMatrix();
    translate(x, y, z);
    rotateY(-rotationAngle);
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
        isGrounded = true;
      }
      if (fix.y > 0) {
        // If we move the player down, we must have hit our head on a ceiling.
      }
    }
    if (fix.z != 0) {
      // If we move the player up or down, the player must have hit a floor or ceiling, so we set vertical velocity to zero.
      velocity.z = 0;
      if (fix.z < 0) {
      }
      if (fix.z > 0) {
      }
    }
    // recalculate AABB (since we moved the object AND we might have other collisions to fix yet this frame):
    calcAABB();
  }

  void playerCamera() {

    dx += width/2-mouseX;
    dy += height/2-mouseY;
    if (dy > height) dy = height;
    if (dy < 10) dy = 10;


    rotationAngle = map(-dx, 0, width, 0, TWO_PI);
    elevationAngle = map(dy, 0, height, 0, PI);
    //rotationAngle = map(mouseX, 0, width, 0, TWO_PI);
    //elevationAngle = map(mouseY, 0, height, 0, PI);
    float rotationMultiplier = 1000;
    float cameraOffset = 75;

    centerX = cos(rotationAngle) * sin(elevationAngle);
    centerY = cos(elevationAngle);
    centerZ = sin(rotationAngle) * sin(elevationAngle);
    camera(x-(centerX*cameraOffset), y-75, z-(centerZ*cameraOffset), centerX*rotationMultiplier + x, centerY*rotationMultiplier + y, centerZ*rotationMultiplier + z, 0.0, 1.0, 0.0);
    //float fov = PI/2;
    //float cameraZ = (height/2.0) / tan(fov/2);
    //perspective(fov, 1, cameraZ/10.0, cameraZ*10.0);
    //frustum(-40, 0, 0, 40, 40, 800);

    println(centerX + " | " + centerY + " | " + centerZ + " | " + x + " | " + y + " | " + z);
  }
}
