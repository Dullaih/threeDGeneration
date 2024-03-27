class Wall extends AABB {

  Wall(float x, float y) {
    this.x = x;
    this.y = y;
    setSize(random(50, 200), random(50, 200));
  }

  void update() {

    super.update();
  }

  void draw() {
    fill(0);
    rect(x - halfW, y - halfH, w, h);
  }
}
