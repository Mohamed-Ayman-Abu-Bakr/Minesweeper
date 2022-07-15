int tileSize = 30;
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

int errors = 0;

enum gameStates{playing,won,lost};

int numGames = 0;
int numWins = 0;
int winPercentage = 0;

gameStates gameState = gameStates.playing;


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
  text("Flags: "+flags, fieldx*tileSize/2, headerSize/2-15);                              //prototype for showing remaining flags
  
  if(gameOver){
    if(gameState == gameStates.won){
      text("You Win!",fieldx*tileSize/2, headerSize/2+15);
    }else{
      text("You Lose!",fieldx*tileSize/2, headerSize/2+15);
    }
    
  }
  
  text("Win Percentage: " + winPercentage + "%",fieldx*tileSize/2, headerSize/2+25);
  
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      tiles[i][j].show();
    }
  }
  if(!gameOver){
    //runai();
  }
}

void setBeginner(){           //rever this
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
    text("Time: "+lastTime,fieldx*tileSize/2, headerSize/2+0);
  }else{
    lastTime = (millis()-time)/1000;
    text("Time: "+lastTime,fieldx*tileSize/2, headerSize/2+0);
  }
  
}
void newGame(){
  time = millis();
  gameOver=false;
  gameState = gameStates.playing;
  tilesCleared = 0;
  flags = mines;
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      tiles[i][j]=new Tile(i*tileSize, j*tileSize);
      set_unrevealed(i,j);
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

void set_unrevealed(int x, int y){
  int unrevealed = 0;
  int type = 0;
  if(x==0||x==fieldx-1)type++;
  if(y==0||y==fieldy-1)type++;
  
  switch (type){
    case 0:
    unrevealed = 8;
    break;
    case 1:
    unrevealed = 5;
    break;
    case 2:
    unrevealed = 3;
    break;
  }
  tiles[x][y].unrevealedNear = unrevealed;
  tiles[x][y].unrevealedMax = unrevealed;
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
    decrement_unrevealed(x,y);
  }
    if(tiles[x][y].bomb){
      if(tilesCleared>8){
        numGames++;
      }
      updateWinPercentage();
      gameOver=true;
      tiles[x][y].triggerBomb = true;
      tiles[x][y].hidden=false;
      gameState = gameStates.lost;
      println("You lose!");
      println("errors: "+errors);
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
  
  if(tilesCleared==fieldy*fieldx-mines&&gameOver==false){
    gameOver=true;
    if(tilesCleared>8){
      numGames++;
      numWins++;
    }
    updateWinPercentage();
    flagRest();
    println("You win!");
    gameState = gameStates.won;
    println("errors: "+errors);
    //newGame();
  }
}

void updateWinPercentage(){
  float temp=(float)numWins/numGames * 100;
  winPercentage = (int)temp;
}

void decrement_unrevealed(int x,int y){
  for(int i = x-1;i<=x+1;i++){
    for(int j = y-1;j<=y+1;j++){
      if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)){
        tiles[i][j].unrevealedNear--;
      }
    }
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
    flagTile(x,y);
  }
}

void flagTile(int x, int y){
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
aiTile tile1,tile2;
void keyPressed(){
  if(key == 'r'){
    newGame();
  }else if(key=='1'){
    setBeginner();
  }else if(key=='2'){
    setIntermediate();
  }else if(key=='3'){
    setExpert();
  }else if(key=='a'){
    if(gameOver==false){
      runai();
    }
    
  }else if (key=='s'){
    PVector vec = gettile(mouseX,mouseY);
    int x = (int)vec.x;
    int y = (int)vec.y;
    print("x:");
    println(x);
    print("y:");
    println(y);
  }else if(key==','){
    PVector vec = gettile(mouseX,mouseY);
    int x = (int)vec.x;
    int y = (int)vec.y;
    Tile t = tiles[x][y];
    tile1 = new aiTile(x,y,t.hidden,t.bombsNear,t.flagged,t.flagsNear,t.unrevealedNear,t.unrevealedMax);
  }else if(key=='.'){
    PVector vec = gettile(mouseX,mouseY);
    int x = (int)vec.x;
    int y = (int)vec.y;
    Tile t = tiles[x][y];
    tile2 = new aiTile(x,y,t.hidden,t.bombsNear,t.flagged,t.flagsNear,t.unrevealedNear,t.unrevealedMax);
  }else if(key=='c'){
    println(isRelated(tile1,tile2));
  }else if(key=='p'){
    while(!gameOver){
      runai();
      delay(50);
    }
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

//add within field method
//change winPercentage to show only 2 decimal places
//update the procedure of starting the game(the setlevel methods don't get called when launching the game
