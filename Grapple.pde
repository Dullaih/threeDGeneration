class Grapple {

  float speed;
  PVector velocity = new PVector(), rVelocity = new PVector(), position = new PVector(), playerPos = new PVector(), initial = new PVector();
  boolean isDead;
  PVector tl = new PVector(), tr = new PVector(), bl = new PVector(), br = new PVector(), hook = new PVector(), difference = new PVector();
  boolean max, min, colliding;

  Grapple(PVector position, float speed, PVector target) {
    this.position.set(position);
    initial.set(position);
    difference = PVector.sub(target, position);
    rVelocity = difference.normalize();
    this.speed = speed;
    hook.set(position.x, position.y, position.z);
  }

  void update(PVector playerPos) {
    tl.set(playerPos.x-5, playerPos.y-10, playerPos.z);
    tr.set(playerPos.x+5, playerPos.y-10, playerPos.z);
    bl.set(playerPos.x-5, playerPos.y, playerPos.z);
    br.set(playerPos.x+5, playerPos.y, playerPos.z);
    if (!max) {
      velocity.x = rVelocity.x*speed;
      velocity.y = rVelocity.y*speed;
      velocity.z = rVelocity.z*speed;
    } else if (!min) {
      velocity.x = -rVelocity.x*speed;
      velocity.y = -rVelocity.y*speed;
      velocity.z = -rVelocity.z*speed;
    } 
    if (colliding) {
      velocity.x = 0;
      velocity.y = 0;
      velocity.z = 0;
    }
    
    //for (int i = 0; i < 20; i++) {
    //  position.x = lerp(initial.x, velocity.x, i/20);
    //  position.y = lerp(initial.y, velocity.y, i/20);
    //  position.z = lerp(initial.z, velocity.z, i/20);
    //}

    position.x += velocity.x*dt;
    position.y += velocity.y*dt;
    position.z += velocity.z*dt;

    hook.set(position.x, position.y, position.z);

    if (abs(PVector.sub(initial, hook).x) > 2000 || abs(PVector.sub(initial, hook).y) > 2000 || abs(PVector.sub(initial, hook).z) > 2000) {
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
    translate(playerPos.x, playerPos.y, playerPos.z);
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
    
    
    translate(hook.x, hook.y, hook.z);
    sphere(10);
    
    popMatrix();
  }
}
