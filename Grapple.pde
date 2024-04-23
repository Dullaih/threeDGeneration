class Grapple {

  float speed;
  PVector velocity = new PVector(), rVelocity = new PVector(), position = new PVector(), start = new PVector();
  float lifetime = 1;
  boolean isDead;
  PVector tl = new PVector(), tr = new PVector(), bl = new PVector(), br = new PVector(), hook = new PVector();

  Grapple(PVector position, float speed, PVector target) {
    this.position.set(position);
    PVector difference = PVector.sub(target, position);
    rVelocity = difference.normalize();
    this.speed = speed;
  }

  void update(PVector start) {
    tl.set(start.x-5, start.y-10, start.z);
    tr.set(start.x+5, start.y-10, start.z);
    bl.set(start.x-5, start.y, start.z);
    br.set(start.x+5, start.y, start.z);
    velocity.x = rVelocity.x*speed;
    velocity.y = rVelocity.y*speed;
    velocity.z = rVelocity.z*speed;

    if (abs(PVector.sub(start, hook).z) > 1000) {
      position.x -= velocity.x*dt;
      position.y -= velocity.y*dt;
      position.z -= velocity.z*dt;
    } else if (abs(PVector.sub(start, hook).z) < 10) {
    } else {
      position.x += velocity.x*dt;
      position.y += velocity.y*dt;
      position.z += velocity.z*dt;
    }

    hook.set(position.x, position.y, position.z);


    lifetime -= dt;
    if (lifetime <= 0) isDead = true;
  }

  void draw() {
    pushMatrix();
    stroke(0, 255, 0);
    translate(start.x, start.y, start.z);
    //strokeWeight(10);
    //line(0, 0, 0, position.x, position.y, position.z);
    //strokeWeight(1);
    beginShape();

    vertex(tl.x, tl.y, tl.z);
    vertex(tr.x, tr.y, tr.z);
    vertex(hook.x, hook.y, hook.z);

    vertex(tr.x, tr.y, tr.z);
    vertex(br.x, br.y, br.z);
    vertex(hook.x, hook.y, hook.z);

    vertex(br.x, br.y, br.z);
    vertex(bl.x, bl.y, bl.z);
    vertex(hook.x, hook.y, hook.z);

    vertex(bl.x, bl.y, bl.z);
    vertex(tl.x, tl.y, tl.z);
    vertex(hook.x, hook.y, hook.z);

    endShape();
    popMatrix();
  }
}
