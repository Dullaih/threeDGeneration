class Enemy extends AABB {

  Radial detectionRadius = new Radial();
  boolean lockedOn;

  Enemy(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    setSize(150, 150, 150);
    detectionRadius.setSize(600);
    detectionRadius.position.set(x, y, z);
  }

  void update() {
    
    if(lockedOn) lockOn();
    super.update();
  }

  void draw() {
    fill(200, 0, 50);
    stroke(255);
    pushMatrix();
    translate(x, y, z);
    box(w, h, d);
    sphere(detectionRadius.radius);
    popMatrix();
  }

  void lockOn() {
    PVector position = new PVector(x, y, z);
    PVector direction = PVector.sub(player.camera.position, position);
    direction = direction.normalize();

    float yaw = (float) atan2(direction.x, direction.z);
    float xz = (float) sqrt(direction.x * direction.x + direction.z * direction.z);
    float pitch = (float) atan2(-direction.y, xz);
    pushMatrix();
    rotateX(yaw); rotateZ(pitch);
    popMatrix();
  }
}
