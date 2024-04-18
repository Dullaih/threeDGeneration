class Bullet extends Radial {
  
  float speed;
  PVector velocity = new PVector();
  float lifetime = 1;
  
  Bullet(PVector position, float speed) {
    this.position.set(position);
    PVector difference = PVector.sub(cameraEndpoint, position);
    rVelocity = difference.normalize();
    this.speed = speed;
    setSize(5);
  }
  
  void update() {
    velocity.x = rVelocity.x*speed;
    velocity.y = rVelocity.y*speed;
    velocity.z = rVelocity.z*speed;
    
    position.x += velocity.x*dt;
    position.y += velocity.y*dt;
    position.z += velocity.z*dt;
    
    lifetime -= dt;
    if(lifetime <= 0) isDead = true;
  }
  
  void draw() {
    pushMatrix();
    fill(200);
    translate(position.x, position.y, position.z);
    sphere(5);
    popMatrix();
  }
  
}
