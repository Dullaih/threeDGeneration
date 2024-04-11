import java.awt.Robot;

float dt = 0;
float prevTime = 0;
Robot robot;

Player player;
ArrayList<Enemy> enemies = new ArrayList();
ArrayList<Tile> tiles = new ArrayList();

final float GRAVITY = 981;


void setup() {
  //size(1280, 720, P3D);
  fullScreen(P3D);
  noCursor();
  player = new Player(0,-1000,0);
  try { robot = new Robot(); }
  catch (Exception e) {}
  
  int offsetX = 100; int offsetZ = 100;
  for(int i = 0; i < 20; i++) {
    Tile t = new Tile(offsetX*i, 0, 0);
    tiles.add(t);
    for(int j = 0; j < 20; j++) {
      Tile z = new Tile(offsetX*i, 0, offsetZ*j);
      tiles.add(z);
    }
  }
  //Wall z = new Wall(-840, 720, -800);
  //walls.add(z);
}

void draw() {
  //BACKGROUND AND DT
  calcDeltaTime();
  background(128);

  pushMatrix();


  //SPAWN OBJECTS



  //UPDATE OBJECTS
  
  robot.mouseMove(width/2,height/2);
  

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
