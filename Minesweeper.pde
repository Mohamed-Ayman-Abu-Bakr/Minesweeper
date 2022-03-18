int tileSize = 30; //<>//
int headerSize=70;
int fieldx=30; // 8,16,30
int fieldy=16; // 8,16,16
int mines = 99; //10,40,99;
boolean winner = false;
boolean gameOver = false;
Tile tiles[][] = new Tile[fieldx][fieldy];
int time = millis();
int lastTime=0;

PImage unclickedTile;
PImage t0;
PImage t1;
PImage t2;
PImage t3;
PImage t4;
PImage t5;
PImage t6;
PImage t7;
PImage t8;
PImage mine;
PImage flag;

int tilesCleared=0;
int flags=mines;



void setup() {
  unclickedTile = loadImage("facingDown.png");
  t0=loadImage("0.png");
  t1=loadImage("1.png");
  t2=loadImage("2.png");
  t3=loadImage("3.png");
  t4=loadImage("4.png");
  t5=loadImage("5.png");
  t6=loadImage("6.png");
  t7=loadImage("7.png");
  t8=loadImage("8.png");
  mine=loadImage("bomb.png");
  flag=loadImage("flagged.png");
  /*for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      tiles[i][j]=new Tile(i*tileSize, j*tileSize);
    }
  }
  int createdMines = 0;
  while (createdMines<mines) {
   int x = (int)random(fieldx);
   int y = (int)random(fieldy);
   
   if (!tiles[x][y].bomb) {
   tiles[x][y].bomb = true;
   createdMines++;
   }
   }*/
   newGame();
  //calculate nearby mines
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      tiles[i][j].bombsNear=calculate(i, j);
    }
  }
  size(240, 240);  //change according to game size;
  surface.setResizable(true);
}

void draw() {
  background(#B9B9B9);
  surface.setSize(fieldx*tileSize,fieldy*tileSize+headerSize);
  fill(#000000);
  textAlign(CENTER);
  updateTime();
  text("Flags: "+flags, fieldx*tileSize/2, headerSize/2-10);                              //prototype for showing remaining flags
  
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      tiles[i][j].show();
    }
  }
}

void setBeginner(){
  fieldx=8;
  fieldy=8;
  mines=10;
  flags = mines;
  newGame();
}
void setIntermediate(){
  fieldx=16;
  fieldy=16;
  mines=40;
  flags = mines;
  newGame();
}
void setExpert(){
  fieldx=30;
  fieldy=16;
  mines=99;
  flags = mines;
  newGame();
}

void updateTime(){
  if(gameOver){
    text("Time: "+lastTime,fieldx*tileSize/2, headerSize/2+10);
  }else{
    lastTime = (millis()-time)/1000;
    text("Time: "+lastTime,fieldx*tileSize/2, headerSize/2+10);
  }
  
}
void newGame(){
  time = millis();
  gameOver=false;
  tilesCleared = 0;
  flags = mines;
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      tiles[i][j]=new Tile(i*tileSize, j*tileSize);
    }
  }
  int createdMines = 0;
  while (createdMines<mines) {
   int x = (int)random(fieldx);
   int y = (int)random(fieldy);
   
   if (!tiles[x][y].bomb) {
   tiles[x][y].bomb = true;
   createdMines++;
   }
   }
  //calculate nearby mines
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      tiles[i][j].bombsNear=calculate(i, j);
    }
  }
}

int  calculate(int x, int y) {
  int numMines=0;
  for (int i = x-1; i<=x+1; i++) {
    for (int j = y-1; j<=y+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy) {
        if (tiles[i][j].bomb) {
          numMines++;
        }
      }
    }
  }
  return numMines;
}

/*void reveal(int x, int y) {
  if (x>=0&&x<fieldx&&y>=0&&y<fieldy&&tiles[x][y].hidden==true) {
    tiles[x][y].hidden=false;
    if (tiles[x][y].bomb)loser=true;
    else {
      if (tiles[x][y].bombsNear>0) {
        tiles[x][y].hidden=false;
      } else {
        for (int i = x-1; i<=x+1; i++) {
          for (int j = y-1; j<=y+1; j++) {
            if(!(i==x&&j==y))
            reveal(i,j);
          }
        }
      }
    }
  }
}*/
void revealbombs(){
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      if(tiles[i][j].bomb&&!tiles[i][j].flagged){
        tiles[i][j].hidden=false;
      }
    }
  }
}
void reveal(int x,int y){
  if(tiles[x][y].hidden==true){
    tilesCleared++;                         ///start here,       fix the win bug;
    println(tilesCleared);
    tiles[x][y].hidden=false;
  }
    if(tiles[x][y].bomb){
      gameOver=true;
      tiles[x][y].triggerBomb = true;
      tiles[x][y].hidden=false;
      println("You lose!");
      revealbombs();
    }
    else{
      if(tiles[x][y].bombsNear==0){
        for (int i = x-1; i<=x+1; i++) {
            for (int j = y-1; j<=y+1; j++) {
              if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&tiles[i][j].hidden==true) reveal(i,j);
            }
        }
      }  
    }
  
  if(tilesCleared==fieldy*fieldx-mines){
    gameOver=true;
    flagRest();
    println("You win!");
    //newGame();
  }
}

void flagRest(){
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      if(tiles[i][j].hidden&&!tiles[i][j].flagged){
        tiles[i][j].flagged=true;
        flags--;
      }
    }
  }
}
  

void mousePressed() {
  PVector vec = gettile(mouseX,mouseY);
  int x = (int)vec.x;
  int y = (int)vec.y;
  if(gameOver){
    newGame();
    return;
  }
  if(mouseY<=headerSize)return;
  if(mouseButton == LEFT){
    if(!tiles[x][y].flagged){
      if(tiles[x][y].hidden)reveal(x,y);
      else{
        if(tiles[x][y].flagsNear==tiles[x][y].bombsNear){
           for (int i = x-1; i<=x+1; i++) {
              for (int j = y-1; j<=y+1; j++) {
                if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&tiles[i][j].flagged==false) reveal(i,j);
              }
          }
        }
      }
    }
  }else if (mouseButton == RIGHT){
    if(tiles[x][y].flagged&&tiles[x][y].hidden){
      tiles[x][y].flagged=false;
      flags++;
      updateFlagCount(x,y,-1);
    }else if(!tiles[x][y].flagged&&tiles[x][y].hidden&&flags>0){
      tiles[x][y].flagged=true;
      flags--;
      updateFlagCount(x,y,1);
    }
  }
}

void keyPressed(){
  if(key == 'r'){
    newGame();
  }else if(key=='1'){
    setBeginner();
  }else if(key=='2'){
    setIntermediate();
  }else if(key=='3'){
    setExpert();
  }
}

void updateFlagCount(int x,int y,int increment){
  for (int i = x-1; i<=x+1; i++) {
          for (int j = y-1; j<=y+1; j++) {
            if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)){
              tiles[i][j].flagsNear+=increment;
              if(tiles[i][j].flagsNear>tiles[i][j].bombsNear){
                println("something's wrong");                           ////// see why this is wrong
              }
            }
          }
      }
}
PVector gettile(int x,int y){
  PVector vec = new PVector();
  vec.x=x/tileSize;
  vec.y=(y-headerSize)/tileSize;
  return vec;
}
