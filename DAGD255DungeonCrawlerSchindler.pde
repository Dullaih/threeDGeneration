import java.awt.Robot;

Robot robot;

float dt = 0;
float prevTime = 0;
float floorWidth = 15, floorLength = 15, wallHeight = 3;
PVector cameraEndpoint = new PVector();

Player player;
ArrayList<Enemy> enemies = new ArrayList();
ArrayList<Tile> tiles = new ArrayList();
ArrayList<Tile> spawnTiles = new ArrayList();
ArrayList<Bullet> bullets = new ArrayList();
ArrayList<Bullet> enemyBullets = new ArrayList();

final float GRAVITY = 981;


void setup() {
  //size(1280, 720, P3D);
  fullScreen(P3D);
  //noCursor();
  player = new Player(500, -1200, 500);
  try {
    robot = new Robot();
  }
  catch (Exception e) {
  }

  int offsetX = 150, offsetY = -150, offsetZ = 150;

  Tile floor = new Tile(offsetX*7, 0, offsetZ*7);
  floor.setSize(offsetX*(floorWidth-2), 0, offsetZ*(floorLength-2));
  tiles.add(floor);
  for (int h = 0; h < 1; h++) {
    for (int i = 0; i < floorWidth-2; i++) {
      Tile t = new Tile(offsetX*i+offsetX, offsetY*h+offsetY, offsetZ);
      spawnTiles.add(t);
      for (int j = 0; j < floorLength-2; j++) {
        Tile z = new Tile(offsetX*i+offsetX, offsetY*h+offsetY, offsetZ*j+offsetZ);
        spawnTiles.add(z);
      }
    }
  }

  for (int i = 0; i < 4; i++) {
    if (i < 2) {
      Tile t = new Tile(offsetX*7, -150, offsetZ*(floorWidth-1)*i);
      t.setSize(offsetX*(floorLength-2), 500, 150);
      tiles.add(t);
    } else {
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

  robot.mouseMove(width/2, height/2);


  for (int i = 0; i < tiles.size(); i++) {
    Tile t = tiles.get(i);
    t.update();
    if (t.checkCollision(player)) {
      player.applyFix(player.findOverlapFix(t));
    }
    if (player.camera.checkAABBCollision(t)) {
      //println("hit");
    }
    for (int j = 0; j < bullets.size(); j++) {
      Bullet b = bullets.get(j);
      if(b.checkAABBCollision(t)) b.isDead = true;
    }
    //else println("no");
  }

  for (int i = 0; i < bullets.size(); i++) {
    Bullet b = bullets.get(i);
    b.update();
    if (b.isDead) bullets.remove(b);
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

  for (int i = 0; i < bullets.size(); i++) {
    Bullet b = bullets.get(i);
    b.draw();
  }

  //for (int i = 0; i < spawnTiles.size(); i++) {
  //  Tile t = spawnTiles.get(i);
  //  t.draw();
  //}

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
