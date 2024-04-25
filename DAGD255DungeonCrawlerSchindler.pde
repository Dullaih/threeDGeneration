import java.awt.Robot;

Robot robot;

Grapple hook;

float dt = 0;
float prevTime = 0;
float floorWidth = 21, floorLength = 69, wallHeight = 6; //only use odd numbers for floor length/width
int offsetX = 150, offsetY = -150, offsetZ = 150;
int halfFloorW = (int) floorWidth/2, halfFloorL = (int) floorLength/2;
PVector cameraEndpoint = new PVector();

Player player;
ArrayList<Enemy> enemies = new ArrayList();
ArrayList<Tile> tiles = new ArrayList();
ArrayList<Tile> spawnTiles = new ArrayList();
ArrayList<Bullet> bullets = new ArrayList();
ArrayList<Bullet> enemyBullets = new ArrayList();

final float GRAVITY = 981;


void setup() {
  size(1280, 720, P3D);
  //fullScreen(P3D);
  //noCursor();
  player = new Player(offsetX*(halfFloorW-1), -3000, offsetZ*2);
  try {
    robot = new Robot();
  }
  catch (Exception e) {
  }

  Tile floor = new Tile(offsetX*halfFloorW, 225, offsetZ*halfFloorL); //make floor
  floor.setSize(offsetX*(floorWidth-2), 150, offsetZ*(floorLength-2));
  tiles.add(floor);
  
  for (int i = 0; i < 4; i++) { //make walls
    if (i < 2) {
      Tile t = new Tile(offsetX*halfFloorW, -300, offsetZ*(floorLength-1)*i);
      t.setSize(offsetX*(floorWidth-2), -offsetY*wallHeight, 150);
      tiles.add(t);
    } else {
      Tile t = new Tile(offsetX*(floorWidth-1)*(i-2), -300, offsetZ*halfFloorL);
      t.setSize(150, -offsetY*wallHeight, offsetZ*(floorLength-2));
      tiles.add(t);
    }
  }
  
  for (int h = 0; h < wallHeight; h++) { //generate spawn areas
    for (int i = 0; i < floorWidth-2; i++) {
      Tile t = new Tile(offsetX*i+offsetX, offsetY*h-offsetY/2, offsetZ*8);
      spawnTiles.add(t);
      for (int j = 8; j < floorLength-2; j++) {
        Tile z = new Tile(offsetX*i+offsetX, offsetY*h-offsetY/2, offsetZ*j+offsetZ);
        spawnTiles.add(z);
      }
    }
  }
  
  for(int i = 0; i < 10; i++) {
    Tile currTile = spawnTiles.get((int)random(spawnTiles.size()-1));
    Enemy e = new Enemy(currTile.x, currTile.y, currTile.z);
    enemies.add(e);
    for(int j = (int)currTile.y; j < 0; j -= offsetY) {
      for(int k = 0; k < spawnTiles.size(); k++) {
        Tile z = spawnTiles.get(k);
        if(z.x == currTile.x && z.y == j - offsetY && z.z == currTile.z) {
          tiles.add(z);
          spawnTiles.remove(z);
        }
      }
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

  //robot.mouseMove(width/2, height/2); //lock mouse to center of screen


  for (int i = 0; i < tiles.size(); i++) { //visible tile collisions
    Tile t = tiles.get(i);
    t.update();
    if (t.checkCollision(player)) { //with player
      player.applyFix(player.findOverlapFix(t));
    }
    if (player.camera.checkAABBCollision(t)) { //with camera
      //println("hit");
    }
    for (int j = 0; j < bullets.size(); j++) { //with bullets
      Bullet b = bullets.get(j);
      if (b.checkAABBCollision(t)) b.isDead = true;
    }
    //else println("no");
  }

  for (int i = 0; i < enemies.size(); i++) { //enemy collisions
    Enemy e = enemies.get(i);
    e.update();
    Radial detect = e.detectionRadius;
    for (int j = 0; j < bullets.size(); j++) { //with bullets
      Bullet b = bullets.get(j);
      if(b.checkAABBCollision(e)) {
        e.isDead = true; b.isDead = true;
      }
    }
    if (detect.checkAABBCollision(player)) { //with player entering their area
      e.lockedOn = true;
    }
    else e.lockedOn = false;
    if (e.isDead) enemies.remove(e);
  }
  
  for (int i = 0; i < bullets.size(); i++) { //bullet update
    Bullet b = bullets.get(i);
    b.update();
    if (b.isDead) bullets.remove(b);
  }
  
  for (int i = 0; i < enemyBullets.size(); i++) { //bullet update
    Bullet b = enemyBullets.get(i);
    b.update();
    if (b.isDead) enemyBullets.remove(b);
  }
  
  if(hook != null && !hook.min) hook.update(new PVector(player.x, player.y, player.z));
  
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
  
  for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.draw();
  }
  
  for (int i = 0; i < enemyBullets.size(); i++) {
    Bullet b = enemyBullets.get(i);
    b.draw();
  }

  //for (int i = 0; i < spawnTiles.size(); i++) {
  //  Tile t = spawnTiles.get(i);
  //  t.draw();
  //}
  
  if(hook != null && !hook.min) hook.draw();

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
