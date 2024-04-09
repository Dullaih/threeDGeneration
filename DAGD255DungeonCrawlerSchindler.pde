float dt = 0;
float prevTime = 0;

Player player;
ArrayList<Enemy> enemies = new ArrayList();
ArrayList<Wall> walls = new ArrayList();


void setup() {
  size(1280, 720, P3D);
  player = new Player(width/2, height/2, 0);

  Wall w = new Wall(540, 720, -400);
  walls.add(w);
  Wall z = new Wall(-540, 720, -400);
  walls.add(z);
}

void draw() {
  //BACKGROUND AND DT
  calcDeltaTime();
  background(128);

  pushMatrix();


  //SPAWN OBJECTS



  //UPDATE OBJECTS

  for (int i = 0; i < walls.size(); i++) {
    Wall w = walls.get(i);
    w.update();
    if (w.checkCollision(player)) {
      player.applyFix(player.findOverlapFix(w));
    }
  }

  player.update();

  //LATE UPDATE OBJECTS
  Keyboard.update();
  Mouse.update();



  //DRAW OBJECTS
  for (int i = 0; i < walls.size(); i++) {
    Wall w = walls.get(i);
    w.draw();
  }



  player.draw();

  //println(keyCode);

  popMatrix();
  //DRAW HUD
}

void calcDeltaTime() {
  float currTime = millis();
  dt = (currTime - prevTime) /1000.0;
  prevTime = currTime;
}

void keyPressed() {
  Keyboard.handleKeyDown(keyCode);
}

void keyReleased() {
  Keyboard.handleKeyUp(keyCode);
}

void mousePressed() {
  if (mouseButton == LEFT) Mouse.handleKeyDown(Mouse.LEFT);
  if (mouseButton == RIGHT) Mouse.handleKeyDown(Mouse.RIGHT);
  if (mouseButton == CENTER) Mouse.handleKeyDown(Mouse.CENTER);
}

void mouseReleased() {
  if (mouseButton == LEFT) Mouse.handleKeyUp(Mouse.LEFT);
  if (mouseButton == RIGHT) Mouse.handleKeyUp(Mouse.RIGHT);
  if (mouseButton == CENTER) Mouse.handleKeyUp(Mouse.CENTER);
}
