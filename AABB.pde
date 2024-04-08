class AABB {
  float x, y, z, w, h, d; // Location and Size of each AABB object.
  float halfW, halfH, halfD;
  float angle;

  float sideL;
  float sideR;
  float sideT;
  float sideB;
  float sideF;
  float sideD;

  PVector velocity = new PVector();
  boolean isDead = false;

  AABB() {
    // All child classes of AABB must call the setSize() function
    // in their constructors.
  }

  void update() {
    calcAABB();
  }

  void draw() {
  }

  void setSize(float w, float h, float d) {
    this.w = w;
    this.h = h;
    this.d = d;
    halfW = w/2;
    halfH = h/2;
    halfD = d/2;
  }

  void calcAABB() {
    sideL = x - halfW;
    sideR = x + halfW;
    sideT = y - halfH;
    sideB = y + halfH;
    sideF = z - halfD;
    sideD = z + halfD;
  }

  boolean checkCollision(AABB other) {
    if (sideR < other.sideL) return false;
    if (sideL > other.sideR) return false;
    if (sideB < other.sideT) return false;
    if (sideT > other.sideB) return false;
    if (sideD < other.sideF) return false;
    if (sideF > other.sideD) return false;
    return true;
  }
  
  /**
   * This method finds the best solution for moving (this) AABB out from an (other)
   * AABB object. The method compares four possible solutions: moving (this) box
   * left, right, up, or down. We only want to choose one of those four solutions.
   * The BEST solution is whichever one is the smallest. So after finding the four
   * solutions, we compare their absolute values to discover the smallest.
   * We then return a vector of how far to move (this) AABB.
   * NOTE: you should first verify that (this) and (other) are overlapping before
   * calling this method.
   * @param  other  The (other) AABB object that (this) AABB is overlapping with.
   * @return  The vector that respresents how far (and in which direction) to move (this) AABB.
   */
  public PVector findOverlapFix(AABB other) {

    float moveL = other.sideL - sideR; // how far to move this box so it's to the LEFT of the other box.
    float moveR = other.sideR - sideL; // how far to move this box so it's to the RIGHT of the other box.
    float moveU = other.sideT - sideB; // how far to move this box so it's to the TOP of the other box.
    float moveD = other.sideB - sideT; // how far to move this box so it's to the BOTTOM of the other box.
    float moveB = other.sideD - sideF;
    float moveF = other.sideF - sideD;

    // The above values are potentially negative numbers; the sign indicates what direction to move.
    // But we want to find out which ABSOLUTE value is smallest, so we get a non-signed version of each.

    float absMoveL = abs(moveL);
    float absMoveR = abs(moveR);
    float absMoveU = abs(moveU);
    float absMoveD = abs(moveD);
    float absMoveB = abs(moveB);
    float absMoveF = abs(moveF);

    PVector result = new PVector();

    result.x = (absMoveL < absMoveR) ? moveL : moveR; // store the smaller horizontal value.
    result.y = (absMoveU < absMoveD) ? moveU : moveD; // store the smaller vertical value.
    result.z = (absMoveB < absMoveF) ? moveB : moveF; // store the smaller depth value

    if (abs(result.y) < abs(result.x) && abs(result.y) < abs(result.z)) {
      // If the vertical value is smaller, set horizontal to zero.
      result.x = 0;
    } else if (abs(result.x) < abs(result.y) && abs(result.x) < abs(result.z)) {
      // If the horizontal value is smaller, set vertical to zero.
      result.y = 0;
    } else {
      result.z = 0;
    }
    
    println(result);

    return result;
  }

  void applyFix(PVector fix) {
    x += fix.x;
    y += fix.y;
    z += fix.z;
    if (fix.x != 0) {
      // If we move the player left or right, the player must have hit a wall, so we set horizontal velocity to zero.
      velocity.x = 0;
    }
    if (fix.y != 0) {
      // If we move the player up or down, the player must have hit a floor or ceiling, so we set vertical velocity to zero.
      velocity.y = 0;
      if (fix.y < 0) {
        // If we move the player up, we must have hit a floor.
      }
      if (fix.y > 0) {
        // If we move the player down, we must have hit our head on a ceiling.
      }
    }
    if (fix.z != 0) {
      // If we move the player up or down, the player must have hit a floor or ceiling, so we set vertical velocity to zero.
      velocity.z = 0;
      if (fix.z < 0) {
        // If we move the player up, we must have hit a floor.
      }
      if (fix.z > 0) {
        // If we move the player down, we must have hit our head on a ceiling.
      }
    }
    // recalculate AABB (since we moved the object AND we might have other collisions to fix yet this frame):
    calcAABB();
  }
}
