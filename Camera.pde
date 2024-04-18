class Camera extends Radial {

  float rotationAngle, elevationAngle;
  float centerX, centerY, centerZ;
  float dx = 0, dy = 0;

  Camera() {
    setSize(80);
  }

  void update(float x, float y, float z) {
    dx += width/2-mouseX;
    dy += height/2-mouseY;
    if (dy > height) dy = height;
    if (dy < 10) dy = 10;


    rotationAngle = map(-dx, 0, width, 0, TWO_PI);
    elevationAngle = map(dy, 0, height, 0, PI);
    //rotationAngle = map(mouseX, 0, width, 0, TWO_PI);
    //elevationAngle = map(mouseY, 0, height, 0, PI);
    float distanceMultiplier = 1000;
    float cameraOffset = 75;

    centerX = cos(rotationAngle) * sin(elevationAngle);
    centerY = cos(elevationAngle);
    centerZ = sin(rotationAngle) * sin(elevationAngle);
    position.set(x-(centerX*cameraOffset), y-100, z-(centerZ*cameraOffset));
    cameraEndpoint.set(centerX*distanceMultiplier + x, centerY*distanceMultiplier + y, centerZ*distanceMultiplier + z);
    camera(position.x, position.y, position.z, cameraEndpoint.x, cameraEndpoint.y, cameraEndpoint.z, 0.0, 1.0, 0.0);
    //float fov = PI/2;
    //float cameraZ = (height/2.0) / tan(fov/2);
    //perspective(fov, 1, cameraZ/10.0, cameraZ*10.0);
    //frustum(-40, 0, 0, 40, 40, 800);

    //println(centerX + " | " + centerY + " | " + centerZ + " | " + x + " | " + y + " | " + z);
  }

  void draw() {
  }
}
