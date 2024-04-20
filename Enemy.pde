class Enemy extends AABB {

  Radial detectionRadius = new Radial();
  boolean lockedOn;
  float yaw = 0, pitch = 0, xz = 0;
  float shootCD = 3;
  PVector position;
  PVector forwardVector = new PVector();
  float pYaw = 0, dYaw = 0;

  Enemy(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    setSize(150, 150, 150);
    detectionRadius.setSize(1200);
    detectionRadius.position.set(x, y, z);
    position = new PVector(x, y, z);
    forwardVector.set(yaw, pitch);
  }

  void update() {

    if (lockedOn)
    {
      lockOn();
      shoot();
    }
    
    pYaw = yaw;
    super.update();
  }

  void draw() {
    fill(200, 0, 50);
    stroke(0);
    pushMatrix();
    translate(x, y, z);
    rotateY(forwardVector.x);
    rotateX(forwardVector.y);
    box(w, h, d);
    translate(0, 0, halfD/1.5);
    sphere(halfW/2);
    //sphere(detectionRadius.radius);
    popMatrix();
  }

  void lockOn() {
    PVector direction = PVector.sub(player.camera.position, position);
    direction = direction.normalize();
    
    xz = (float) sqrt(direction.x * direction.x + direction.z * direction.z);
    yaw = (float) atan2(direction.x, direction.z);
    pitch = (float) atan2(-direction.y, xz);
    if(yaw == abs(yaw)) dYaw += abs(yaw) - abs(pYaw);
    else dYaw -= abs(yaw) - abs(pYaw);
    //println(dYaw);
    PVector endVector = new PVector (dYaw, pitch);
    forwardVector = easing(forwardVector, endVector, 0.5);
  }
  
  void shoot() {
    shootCD -= dt;
    if(shootCD <= 0) {
      Bullet b = new Bullet(position, 600, player.camera.position);
      b.lifetime = 5;
      enemyBullets.add(b);
      shootCD = 3;
    }
  }
}
