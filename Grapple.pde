class Grapple {

  float speed;
  PVector velocity = new PVector(), rVelocity = new PVector(), position = new PVector(), start = new PVector();
  boolean isDead;
  PVector tl = new PVector(), tr = new PVector(), bl = new PVector(), br = new PVector(), hook = new PVector();
  boolean max;

  Grapple(PVector position, float speed, PVector target) {
    this.position.set(position);
    PVector difference = PVector.sub(target, position);
    rVelocity = difference.normalize();
    this.speed = speed;
    max = false;
  }

  void update(PVector start) {
    tl.set(start.x-5, start.y-10, start.z);
    tr.set(start.x+5, start.y-10, start.z);
    bl.set(start.x-5, start.y, start.z);
    br.set(start.x+5, start.y, start.z);
    velocity.x = rVelocity.x*speed;
    velocity.y = rVelocity.y*speed;
    velocity.z = rVelocity.z*speed;

    if(!max) {
      position.x += velocity.x*dt;
      position.y += velocity.y*dt;
      position.z += velocity.z*dt;
    }

    hook.set(position.x, position.y, position.z);
    
    if (abs(PVector.sub(start, hook).z) > 1500) {
      max = true;
    }
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
    if(max) {
      translate(hook.x, hook.y, hook.z);
      sphere(10);
    }
    popMatrix();
  }
}
