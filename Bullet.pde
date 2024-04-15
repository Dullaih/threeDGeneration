class Bullet extends Radial {
  
  Bullet(float x, float y, float z, float rotation, float elevation) {
    PVector position = new PVector(x, y, z);
    PVector velocity = new PVector(cos(rotation), 0, sin(rotation));
  }
  
  void update() {
  }
  
  void draw() {
  }
  
}
