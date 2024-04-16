class Radial {
  
  PVector position = new PVector(), velocity = new PVector();
  float radius;
  boolean isDead;
  
  Radial() {
  }
  
  void update() {
  }
  
  void draw() {
  }
  
  void setSize(float radius) {
    this.radius = radius;
  }
  
  boolean checkAABBCollision(AABB box) {
    float clampX = max(box.sideL, min(position.x, box.sideR));
    float clampY = max(box.sideT, min(position.y, box.sideB));
    float clampZ = max(box.sideF, min(position.z, box.sideD));
    
    float distance = sqrt(sq(clampX-position.x) + sq(clampY-position.y) + sq(clampZ-position.z));
    
    return distance < radius;
  }
  
  boolean checkRadialCollision(Radial other) {
    float distance = sqrt(sq(position.x - other.position.x) + sq(position.y - other.position.y) + sq(position.z - other.position.z));
    
    return distance < radius + other.radius;
  }
  
}
