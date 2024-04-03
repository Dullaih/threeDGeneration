class Enemy extends AABB {

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
    setSize(150, 150, 150);
  }

  void update() {
    
    super.update();
  }

  void draw() {
    fill(200, 0, 0);
    box(x - halfW, y - halfW, 60);
  }
}
