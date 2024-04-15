class Bullet extends Radial {
  
  Bullet(float x, float y, float z, float rotation, float elevation) {
    position = new PVector(x, y, z);
    velocity = new PVector(cos(rotation), -cos(elevation), sin(rotation));
  }
  
  void update() {
  }
  
  void draw() {
  }
  
}
