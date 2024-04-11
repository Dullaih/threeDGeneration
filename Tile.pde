class Tile extends AABB {

  Tile(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    setSize(100, 100, 100);
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
}'
