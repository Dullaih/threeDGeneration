class Camera {

  float x, y;
  float tx, ty;
  float distance;
  float dx, dy;

  Player target;

  Camera(Player p) {
    target = p;
    tx = target.x - width/2;
    ty = target.y - height/2;
    x = tx;
    y = ty;
  }

  void update() {
    //get and offset player position
    tx = target.x - width/2;
    ty = target.y - height/2;
    
    //calc distance between player and offset
    dx = tx - x;
    dy = ty - y;
    
    //move camera position with easing from dx and dy
    x += dx * 0.1;
    y += dy * 0.1;
  }
}
