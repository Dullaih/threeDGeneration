class Wall extends AABB {

  Wall(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    setSize(2000, 10, 2000);
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
}
