class Player extends AABB {

  boolean isGrounded;
  float modifier = 1;
  float acceleration = 20;
  float maxSpeed = 800;
  Camera camera = new Camera();
  float grappleDist = 0;
  PVector difference = new PVector();

  Player(float xPos, float yPos, float zPos) {
    x = xPos;
    y = yPos;
    z = zPos;

    setSize(100, 100, 100);
  }

  void update() {
    velocity.y += GRAVITY*2*dt;

    camera.update(x, y, z);

    if (grapple.colliding) GrappleMovement();
    else {
      if (Keyboard.isDown(Keyboard.LEFT)) {
        velocity.x += sin(camera.rotationAngle)*acceleration*modifier;
        velocity.z += cos(camera.rotationAngle)*-acceleration*modifier;
      }
      if (Keyboard.isDown(Keyboard.RIGHT)) {
        velocity.x += sin(camera.rotationAngle)*-acceleration*modifier;
        velocity.z += cos(camera.rotationAngle)*acceleration*modifier;
      }
      if (Keyboard.isDown(Keyboard.UP)) {
        velocity.x += cos(camera.rotationAngle)*acceleration*modifier;
        velocity.z += sin(camera.rotationAngle)*acceleration*modifier;
      }
      if (Keyboard.isDown(Keyboard.DOWN)) {
        velocity.x += cos(camera.rotationAngle)*-acceleration*modifier;
        velocity.z += sin(camera.rotationAngle)*-acceleration*modifier;
      }
    }
    if (Keyboard.isDown(Keyboard.SPACE)) {
      grapple.min = true;
      grapple.colliding = false;
      if (isGrounded) velocity.y = -maxSpeed;
    }
    if (Keyboard.onDown(Keyboard.SHIFT)) {
      modifier = 40;
      grapple.min = true;
      grapple.colliding = false;
    }

    if (velocity.x > maxSpeed*modifier) velocity.x = maxSpeed*modifier;
    if (velocity.x < -maxSpeed*modifier) velocity.x = -maxSpeed*modifier;
    if (velocity.z > maxSpeed*modifier) velocity.z = maxSpeed*modifier;
    if (velocity.z < -maxSpeed*modifier) velocity.z = -maxSpeed*modifier;

    x += velocity.x * dt;
    y += velocity.y * dt;
    z += velocity.z * dt;

    if (Mouse.onDown(Mouse.LEFT)) {
      Bullet b = new Bullet(camera.position, 2000, cameraEndpoint);
      bullets.add(b);
    }
    if (Mouse.onDown(Mouse.RIGHT)) {
      grapple = new Grapple(camera.position, 3000, cameraEndpoint);
    }


    velocity.x *= 0.92;
    //velocity.y *= 0.95;
    velocity.z *= 0.92;

    isGrounded = false;
    if (modifier > 1) modifier *= 0.85;
    else modifier = 1;
    super.update();
  }

  void draw() {
    //noFill();
    pushMatrix();
    translate(x, y, z);
    rotateY(-camera.rotationAngle);
    //box(w, h, d);
    popMatrix();
  }

  void GrappleMovement() {
    grappleDist = dist(x, y, z, grapple.hook.x, grapple.hook.y, grapple.hook.z);
    difference = PVector.sub(grapple.hook, new PVector(x, y, z));
    float interpolate = 30/grappleDist;
    if (grappleDist > 50) {
      x = lerp(x, grapple.hook.x, interpolate);
      y = lerp(y, grapple.hook.y, interpolate);
      z = lerp(z, grapple.hook.z, interpolate);
    }
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
}
