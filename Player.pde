class Player extends AABB {

  boolean isGrounded;
  float modifier = 1;
  float acceleration = 80;
  float maxSpeed = 1000;
  Camera camera = new Camera();
  float grappleDist = 0;
  PVector difference = new PVector();
  float px = 0, py = 0, pz = 0;
  float health = 3;
  float charges = 3, chargeTime = 5;
  boolean hasCharges = true, hasDash = true;
  float dashCharges = 2, dashTime = 4;

  Player(float xPos, float yPos, float zPos) {
    x = xPos;
    y = yPos;
    z = zPos;

    setSize(100, 100, 100);
  }

  void update() {
    if (!grapple.colliding) velocity.y += GRAVITY*2*dt;

    camera.update(x, y, z);

    if (grapple.colliding) {
      GrappleMovement();
      if(!grapple.pColliding) charges--;
    }
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

    if (grapple.pColliding && !grapple.colliding) {
      //println("stopopo");
      velocity.x = (x-px)*acceleration;
      velocity.y = (y-py)*acceleration/2;
      velocity.z = (z-pz)*acceleration;
    }

    if (Keyboard.onDown(Keyboard.SHIFT) && hasDash) {
      modifier = 20;
      acceleration = 80;
      grapple.min = true;
      grapple.colliding = false;
      dashCharges--;
    }

    if (velocity.x > maxSpeed*modifier) velocity.x = maxSpeed*modifier;
    if (velocity.x < -maxSpeed*modifier) velocity.x = -maxSpeed*modifier;
    if (velocity.z > maxSpeed*modifier) velocity.z = maxSpeed*modifier;
    if (velocity.z < -maxSpeed*modifier) velocity.z = -maxSpeed*modifier;
    println(velocity.x + " | " + velocity.z);

    x += velocity.x * dt;
    y += velocity.y * dt;
    z += velocity.z * dt;

    if (Mouse.onDown(Mouse.LEFT)) {
      shot.play();
      Bullet b = new Bullet(camera.position, 4000, cameraEndpoint);
      bullets.add(b);  
    }
    if (Mouse.onDown(Mouse.RIGHT) && hasCharges) {
      grapple = new Grapple(camera.position, 3000, cameraEndpoint);
      snap.amp(0.2);
      snap.play();
    }

    if (charges == 0) {
      hasCharges = false;
    }
    else hasCharges = true;
    
    if (charges < 3) {
      chargeTime -= dt;
      if(chargeTime <= 0) {
        charges++;
        chargeTime = 5;
      }
    }
    
    if (dashCharges == 0) {
      hasDash = false;
    }
    else hasDash = true;
    
    if (dashCharges < 2) {
      dashTime -= dt;
      if(dashTime <= 0) {
        dashCharges++;
        dashTime = 4;
      }
    }

    if (player.health == 0) {
      exit();
    }

    velocity.x *= 0.92;
    //velocity.y *= 0.95;
    velocity.z *= 0.92;

    isGrounded = false;
    if (modifier > 1) modifier *= 0.85;
    else modifier = 1;
    if (acceleration > 80 && !grapple.colliding) acceleration *=.98;
    else acceleration = 80;
    px = x;
    py = y;
    pz = z;
    grapple.pColliding = grapple.colliding;
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
      acceleration *= 1.5;
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
