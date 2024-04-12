import java.awt.Robot;

float dt = 0;
float prevTime = 0;
Robot robot;
float floorWidth = 15, floorLength = 15, wallHeight = 3;

Player player;
ArrayList<Enemy> enemies = new ArrayList();
ArrayList<Tile> tiles = new ArrayList();

final float GRAVITY = 981;


void setup() {
  size(1280, 720, P3D);
  //fullScreen(P3D);
  //noCursor();
  player = new Player(500, -1000, 500);
  try {
    robot = new Robot();
  }
  catch (Exception e) {
  }

  int offsetX = 150, offsetZ = 150;

  for (int i = 0; i < floorWidth; i++) {
    Tile t = new Tile(offsetX*i, 0, 0);
    tiles.add(t);

    for (int j = 0; j < floorLength; j++) {
      Tile z = new Tile(offsetX*i, 0, offsetZ*j);
      tiles.add(z);
    }
  }

  for (int i = 0; i < 4; i++) {
    if(i < 2) {
      Tile t = new Tile(offsetX*7, -150, offsetZ*(floorWidth-1)*i);
      t.setSize(offsetX*(floorLength-2), 500, 150);
      tiles.add(t);
    }
    else {
      Tile t = new Tile(offsetX*(floorLength-1)*(i-2), -150, offsetZ*7);
      t.setSize(150, 500, offsetZ*(floorWidth-2));
      tiles.add(t);
    }
  }
}


void draw() {
  //BACKGROUND AND DT
  calcDeltaTime();
  background(128);

  pushMatrix();


  //SPAWN OBJECTS



  //UPDATE OBJECTS

  //robot.mouseMove(width/2, height/2);


  for (int i = 0; i < tiles.size(); i++) {
    Tile t = tiles.get(i);
    t.update();
    if (t.checkCollision(player)) {
      player.applyFix(player.findOverlapFix(t));
    }
  }

  player.update();

  //LATE UPDATE OBJECTS
  Keyboard.update();
  Mouse.update();



  //DRAW OBJECTS
  for (int i = 0; i < tiles.size(); i++) {
    Tile t = tiles.get(i);
    t.draw();
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
