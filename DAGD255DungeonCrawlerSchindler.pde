float dt = 0;
float prevTime = 0;

Player player;
Camera camera;

ArrayList<Enemy> enemies = new ArrayList();

void setup() {
  size(1280, 720);
  player = new Player(width/2, height/2);
  camera = new Camera(player);
  
  for(int i = 0; i < 10; i++) {
    Enemy e = new Enemy(random(width), random(height));
    enemies.add(e);
  }
}

void draw() {
  //BACKGROUND AND DT
  calcDeltaTime();
  background(128);
  
  pushMatrix();
  translate(-camera.x, -camera.y);


  //SPAWN OBJECTS



  //UPDATE OBJECTS
  camera.update();
  
  for(int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.update();
  }
  
  player.update();


  //LATE UPDATE OBJECTS
  Keyboard.update();
  Mouse.update();



  //DRAW OBJECTS
  for(int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.draw();
  }
  
  
  
  player.draw();
  
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
