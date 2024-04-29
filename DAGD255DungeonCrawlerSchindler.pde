//copyright Nathan Schindler 2024
//FPS dungeoncrawler
//WASD movement; LCLICK to shoot (semiauto); LSHIFT to dash (max 2 charges [4 second cooldown per charge]); RCLICK to grapple (max 3 charges [5 sec cooldown per charge])

import processing.sound.*;
import java.awt.Robot;

SoundFile music;
SoundFile shot;
SoundFile kill;
SoundFile snap;

Robot robot;

Grapple grapple;

Level level;

float dt = 0;
float prevTime = 0;

PVector cameraEndpoint = new PVector();
int offsetX = 150, offsetY = -150, offsetZ = 150;

Player player;
ArrayList<Enemy> enemies = new ArrayList();
ArrayList<Tile> tiles = new ArrayList();
ArrayList<Tile> spawnTiles = new ArrayList();
ArrayList<Bullet> bullets = new ArrayList();
ArrayList<Bullet> enemyBullets = new ArrayList();

final float GRAVITY = 981;


void setup() {
  //size(1280, 720, P3D);
  level = new Level();
  fullScreen(P3D);
  noCursor();
  player = new Player(offsetX*(level.halfFloorW-1), -3000, offsetZ*2);
  grapple = new Grapple(player.camera.position, 2000, cameraEndpoint);
  try {
    robot = new Robot();
  }
  catch (Exception e) {
  }
  
  music = new SoundFile(this, "Cyber Shift.wav");
  shot = new SoundFile(this, "shot.wav");
  kill = new SoundFile(this, "kill.wav");
  snap = new SoundFile(this, "snap.wav");
  
  music.amp(0.3);
  music.loop();
}


void draw() {
  //BACKGROUND AND DT
  calcDeltaTime();
  background(128);

  pushMatrix();


  //SPAWN OBJECTS



  //UPDATE OBJECTS

  robot.mouseMove(width/2, height/2); //lock mouse to center of screen


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
    if (t.checkPointCollision(grapple.hook) && !grapple.min) { //with grapple
      grapple.colliding = true;
    }
  }

  for (int i = 0; i < enemies.size(); i++) { //enemy collisions
    Enemy e = enemies.get(i);
    e.update();
    Radial detect = e.detectionRadius;
    for (int j = 0; j < bullets.size(); j++) { //with bullets
      Bullet b = bullets.get(j);
      if (b.checkAABBCollision(e)) {
        kill.amp(0.5);
        kill.play();
        e.isDead = true;
        b.isDead = true;
      }
    }
    if (detect.checkAABBCollision(player)) { //with player entering their area
      e.lockedOn = true;
    } else e.lockedOn = false;
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
    if (b.checkAABBCollision(player)) {
      //println("hit");
      player.health--;
      b.isDead = true;
    }
    if (b.isDead) enemyBullets.remove(b);
  }

  if (grapple != null && !grapple.min) grapple.update(new PVector(player.x, player.y, player.z));

  if (player.y > 4000) {
    for (int i = enemies.size(); i > 0; i--) {
      enemies.remove(i-1);
    }
    for (int i = tiles.size(); i > 0; i--) {
      tiles.remove(i-1);
    }
    for (int i = spawnTiles.size(); i > 0; i--) {
      spawnTiles.remove(i-1);
    }
    level = new Level();
    grapple = new Grapple(player.camera.position, 2000, cameraEndpoint);
    player.x = offsetX*(level.halfFloorW-1);
    player.y = -2000;
    player.z = offsetZ*2;
  }
  
  level.update();

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

  if (grapple != null && !grapple.max && !grapple.min) grapple.draw();

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
