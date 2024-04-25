class Grapple {

  float speed;
  PVector velocity = new PVector(), rVelocity = new PVector(), position = new PVector(), start = new PVector(), initial = new PVector();
  boolean isDead;
  PVector tl = new PVector(), tr = new PVector(), bl = new PVector(), br = new PVector(), hook = new PVector();
  boolean max, min;

  Grapple(PVector position, float speed, PVector target) {
    this.position.set(position);
    initial.set(position);
    PVector difference = PVector.sub(target, position);
    rVelocity = difference.normalize();
    this.speed = speed;
  }

  void update(PVector start) {
    tl.set(start.x-5, start.y-10, start.z);
    tr.set(start.x+5, start.y-10, start.z);
    bl.set(start.x-5, start.y, start.z);
    br.set(start.x+5, start.y, start.z);
    if (!max) {
      velocity.x = rVelocity.x*speed;
      velocity.y = rVelocity.y*speed;
      velocity.z = rVelocity.z*speed;
    }
    else if (!min){
      velocity.x = -rVelocity.x*speed;
      velocity.y = -rVelocity.y*speed;
      velocity.z = -rVelocity.z*speed;
    }
    else {
      velocity.x = 0;
      velocity.y = 0;
      velocity.z = 0;
    }

      position.x += velocity.x*dt;
      position.y += velocity.y*dt;
      position.z += velocity.z*dt;

    hook.set(position.x, position.y, position.z);

    if (abs(PVector.sub(initial, hook).z) > 1500) {
      max = true;
      min = false;
    }
    if (abs(PVector.sub(initial, hook).z) < 25 && max) {
      min = true;
      //max = false;
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
    if (max) {
      translate(hook.x, hook.y, hook.z);
      sphere(10);
    }
    popMatrix();
  }
}
