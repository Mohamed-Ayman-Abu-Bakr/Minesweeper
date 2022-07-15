//aiTile aiTiles[][] = new aiTile[fieldx][fieldy];
//int numBombs[][]=new int[fieldx][fieldy];
//boolean changed = false;
//int configs = 0;
//int remainingFlags=0;
//ArrayList<aiTile> toScan = new ArrayList<aiTile>();
//class aiTile {
//  int posX=0;
//  int posY = 0;
//  boolean hidden = true;
//  int bombsNear = 0;
//  boolean flagged = false;
//  int flagsNear=0;
//  int unrevealedNear = 8;
//  int triedNear = 0;
//  int unrevealedMax = 8;
//  aiTile(int posX, int posY, boolean hidden,int bombsNear, boolean flagged, int flagsNear, int unrevealedNear, int unrevealedMax) {
//    this.posX = posX;
//    this.posY = posY;
//    this.hidden = hidden;
//    this.bombsNear=bombsNear;
//    this.flagged = flagged;
//    this.flagsNear = flagsNear;
//    this.unrevealedNear = unrevealedNear;
//    this.unrevealedMax = unrevealedMax;
//  }
//}

//void init_Tiles(){
//  for (int i = 0; i<fieldx; i++) {
//    for (int j = 0; j<fieldy; j++) {
//      Tile t = tiles[i][j];
//      aiTiles[i][j]=new aiTile(i,j,t.hidden,t.bombsNear,t.flagged,t.flagsNear,t.unrevealedNear,t.unrevealedMax);
//      if(t.flagged||!t.hidden||t.unrevealedNear==t.unrevealedMax){
//        numBombs[i][j]=-1;
//      }else{
//        toScan.add(aiTiles[i][j]);
//        numBombs[i][j]=0;
//      }
      
//    }
//  }
//  printNum();
//}


//void printNum(){
//  for (int j = 0; j<fieldy; j++) {
//    for (int i = 0; i<fieldx; i++) {
//      print(numBombs[i][j]+"\t");
//    }
//    println();
//  }
//  println();
//}
//void runai(){
//  changed = false;
//  configs = 0;
//  remainingFlags = flags;
//  toScan.clear();
//  init_Tiles();
//  //println("running ai!");
//  //flag();
//  //fullFlags();
//  //if the simple rules didn't yield any benefit
//  if (!changed){
//    tryTile(0);
//    print("configs:");
//    println(configs);
//    printNum();
//    for(int i = 0;i<fieldx;i++){
//      for(int j = 0;j<fieldy;j++){
//        if (tiles[i][j].hidden ==true){
//          if(numBombs[i][j]==configs&&configs!=0)flagTile(i,j);
//          if(numBombs[i][j]==0&&configs!=0)reveal(i,j);
//        }
//      }
//    }
//    println("can't do anything");
//  }
//}

//void fullFlags(){              //reveal the tiles around a tile that has the same number of flags around it as the number of bombs supposed to be near it
//  for(int i = 0;i<fieldx;i++){
//    for(int j = 0;j<fieldy;j++){
//      if (tiles[i][j].hidden ==false){
//        if(tiles[i][j].flagsNear == tiles[i][j].bombsNear){
//          fullFlags_reveal(i,j);
//          //changed = true;
//        }
//      }
//    }
//  }
//}

//void fullFlags_reveal(int x, int y){
//  for (int i = x-1; i<=x+1; i++) {
//            for (int j = y-1; j<=y+1; j++) {
//              if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&tiles[i][j].hidden==true&&tiles[i][j].flagged==false){
//                reveal(i,j);
//                changed = true;
//              }
//            }
//        }
//}

//void flag(){    // if a tile has the same number of uncleared tiles around it as the number of bombs supposed to be near it then they all should be flagged
//  for(int i = 0;i<fieldx;i++){
//    for(int j = 0;j<fieldy;j++){
//      if (tiles[i][j].hidden ==false){
//        if(tiles[i][j].unrevealedNear == tiles[i][j].bombsNear){
//          flagTilesAround(i,j);
//          //changed = true;
//        }
//      }
//    }
//  }
//}

//void flagTilesAround(int x,int y){
//  for (int i = x-1; i<=x+1; i++) {
//      for (int j = y-1; j<=y+1; j++) {
//        if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&tiles[i][j].hidden==true&&tiles[i][j].flagged == false){
//          flagTile(i,j);
//          changed = true;
//        }
//      }
//  }
//}

//void tryTile(int i){
//  if(i==toScan.size()){
//    if(isValid()){
//      recordConfig();
//      configs++;
//    }
//    return;
//  }
//  aiTile t = toScan.get(i);
//  //PVector next = getNext(i,j);
//  if(t.hidden==false||t.flagged==true||hasNoClearedNear(t)){
//    tryTile(i+1);
//    return;
//  }                                      
//  println("here");
//  if(remainingFlags>0){
//    aiFlagTile(t.posX,t.posY);
//    if(checkSurrounding(t.posX,t.posY,i))tryTile(i+1);
//    aiFlagTile(t.posX,t.posY);
//    if(checkSurrounding(t.posX,t.posY,i))tryTile(i+1);
//  }else{
//     tryTile(i+1);
//  }
  
  
//  //add a condition to check if the number of currently flagged exceeds the number of flags in the game
//}

//boolean checkSurrounding(int x, int y, int index){
//  for (int i = x-1; i<=x+1; i++) {
//      for (int j = y-1; j<=y+1; j++) {
//        if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)){
//          aiTile t = aiTiles[i][j];
//          if(t.hidden == false){
//            if(t.flagsNear > t.bombsNear)return false;
//            if(triedAllNear(i,j,index)&&t.flagsNear <= t.bombsNear)return false;
//          }
//        }
//      }
//  }
//  return true;
//}

//boolean triedAllNear(int x,int y,int index){
//  println("size"+toScan.size());
//  int cnt = 0;
//  for (int i = x-1; i<=x+1; i++) {
//      for (int j = y-1; j<=y+1; j++) {
//        if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&i!=x&&j!=y){
//          aiTile t = aiTiles[i][j];
//          if(t.hidden == true){
//            println("index: "+toScan.indexOf(t)+"current: "+index);
//            if(toScan.indexOf(t)<index)cnt++;                                  //check this condition      also this sometimes finds a tile that isn't in the toScan list
//          }
//        }
//      }
//  }
//  println(cnt+" "+tiles[x][y].unrevealedNear);
//  if(cnt<tiles[x][y].unrevealedNear)return false;
//  return true;
//}

///*boolean checkSurroundingValid(int x, int y){
//  for (int i = x-1; i<=x+1; i++) {
//      for (int j = y-1; j<=y+1; j++) {
//        if(i>=0&&i<fieldx&&j>=0&&j<fieldy){  //consider adding x!=i, y!=j to the condition
//          aiTile t = aiTiles[i][j];
//          if(t.hidden == false){
//            if(t.flagsNear != t.bombsNear)return false;      //check this condition
//          }
//        }
//      }
//  }
//  return true;
//}*/

//boolean hasNoClearedNear(aiTile t){
//  /*print("unrevealedNear: ");
//  println(t.unrevealedNear);
//  print("unrevealedMax: ");
//  println(t.unrevealedMax);*/
//  if(t.unrevealedNear==t.unrevealedMax)return true;
//  return false;
//}

//boolean isValid(){
//  //printValidMatrix();
//  for(int i = 0;i<fieldx;i++){
//    for(int j = 0;j<fieldy;j++){
//      if (tiles[i][j].hidden ==false){
//        if(aiTiles[i][j].flagsNear!=aiTiles[i][j].bombsNear){
//          return false;
//        }
//      }
//    }
//  }
//  return true;
//}

//void printValidMatrix(){
//  println("valid matrix:");
//  for (int j = 0; j<fieldy; j++) {
//    for (int i = 0; i<fieldx; i++) {
//      print((/*aiTiles[i][j].bombsNear-*/aiTiles[i][j].flagsNear)+"\t");
//    }
//    println();
//  }
//  println();
//}

//void recordConfig(){
//  for(int i = 0;i<fieldx;i++){
//    for(int j = 0;j<fieldy;j++){
//      if (tiles[i][j].hidden ==true){
//        if(numBombs[i][j]!=-1&&aiTiles[i][j].flagged==true){
//          numBombs[i][j]++;
//        }
//      }
//    }
//  }
//}

//PVector getNext(int x,int y){
//  PVector vec = new PVector();
//  if(x<fieldx-1){
//    vec.x=x+1;
//    vec.y=y;
//  }else{
//    vec.y=y+1;
//    vec.x=0;
//  }
//  return vec;
//}

//void aiFlagTile(int x, int y){
//  if(aiTiles[x][y].flagged){
//      aiTiles[x][y].flagged=false;
//      remainingFlags++;
//      aiUpdateFlagCount(x,y,-1);
//    }else if(!aiTiles[x][y].flagged&&remainingFlags>0){       //check this condition
//      aiTiles[x][y].flagged=true;
//      remainingFlags--;
//      aiUpdateFlagCount(x,y,1);
//    }
//}
//boolean aiUpdateFlagCount(int x,int y,int increment){
//  for (int i = x-1; i<=x+1; i++) {
//          for (int j = y-1; j<=y+1; j++) {
//            if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)){
//              aiTiles[i][j].flagsNear+=increment;
//            }
//          }
//      }
//      return true;
//}
