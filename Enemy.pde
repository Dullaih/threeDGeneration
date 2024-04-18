class Enemy extends AABB {
  
  Radial detectionRadius = new Radial();

  Enemy(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    setSize(150, 150, 150);
    detectionRadius.setSize(600);
  }

  void update() {
    
    super.update();
  }

  void draw() {
    fill(0);
    stroke(255);
    pushMatrix();
    translate(x, y, z);
    box(w, h, d);
    popMatrix();
  }
  
  void lockOn() {
  }
}
