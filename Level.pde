class Level {

  float floorWidth = 21, floorLength = 69, wallHeight = 15; //only use odd numbers for floor length/width
  int halfFloorW = (int) floorWidth/2, halfFloorL = (int) floorLength/2;
  Tile door;

  Level() {
    Tile floor = new Tile(offsetX*halfFloorW, 225, offsetZ*halfFloorL); //make floor
    floor.setSize(offsetX*(floorWidth-2), 150, offsetZ*(floorLength-2));
    tiles.add(floor);
    
    Tile ceil = new Tile(offsetX*halfFloorW, wallHeight*offsetY+75, offsetZ*halfFloorL); //make floor
    ceil.setSize(offsetX*(floorWidth-2), 150, offsetZ*(floorLength-2));
    tiles.add(ceil);
    
    Tile front = new Tile(offsetX*halfFloorW, (wallHeight-1)/2*offsetY+75, 0);
    front.setSize(offsetX*(floorWidth-2), -offsetY*wallHeight, 150);
    tiles.add(front);

    Tile backR = new Tile(offsetX*halfFloorW/2, (wallHeight-1)/2*offsetY+75, offsetZ*(floorLength-1));
    backR.setSize(offsetX*(floorWidth-2)/2, -offsetY*wallHeight, 150);
    tiles.add(backR);
    
    Tile backL = new Tile(offsetX*(floorWidth-halfFloorW/2), (wallHeight-1)/2*offsetY+75, offsetZ*(floorLength-1));
    backL.setSize(offsetX*(floorWidth-2)/2, -offsetY*wallHeight, 150);
    tiles.add(backL);
    
    door = new Tile(offsetX*halfFloorW+75, (wallHeight-1)/2*offsetY+75, offsetZ*(floorLength-1));
    door.setSize(offsetX*1.5, -offsetY*wallHeight, offsetZ);
    tiles.add(door);

    for (int i = 0; i < 2; i++) { //make walls
        Tile t = new Tile(offsetX*(floorWidth-1)*(i), (wallHeight-1)/2*offsetY+75, offsetZ*halfFloorL);
        t.setSize(150, -offsetY*wallHeight, offsetZ*(floorLength-2));
        tiles.add(t);
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

    for (int i = 0; i < 15; i++) { //generate enemies
      Tile currTile = spawnTiles.get((int)random(spawnTiles.size()-1));
      Enemy e = new Enemy(currTile.x, currTile.y, currTile.z);
      enemies.add(e);
      for (int j = (int)currTile.y; j < 0; j -= offsetY) {
        for (int k = 0; k < spawnTiles.size(); k++) {
          Tile z = spawnTiles.get(k);
          if (z.x == currTile.x && z.y == j - offsetY && z.z == currTile.z) {
            tiles.add(z);
            spawnTiles.remove(z);
          }
        }
      }
      spawnTiles.remove(currTile);
    }
  }
  void update() {
    if(enemies.size() == 0) {
      door.y = -5000;
    }
  }
}
