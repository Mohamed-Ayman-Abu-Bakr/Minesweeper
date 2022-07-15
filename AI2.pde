//aiTile aiTiles[][] = new aiTile[fieldx][fieldy];
//int numBombs[][]=new int[fieldx][fieldy];
//int numScanned[][]=new int[fieldx][fieldy];
//float percentage[][]=new float[fieldx][fieldy];
//boolean changed = false;
//int remainingFlags=0;
//ArrayList<aiTile> toScan = new ArrayList<aiTile>();
//ArrayList<aiTile> toScanMini = new ArrayList<aiTile>();
//int scanBombs[] = new int[8];
//int scanNum[] = new int[8];
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
//  int numsScanned=0;
//  aiTile(int posX, int posY, boolean hidden,int bombsNear, boolean flagged, int flagsNear, int unrevealedNear, int unrevealedMax) {
//    this.posX = posX;
//    this.posY = posY;
//    this.hidden = hidden;
//    this.bombsNear=bombsNear;
//    this.flagged = flagged;
//    this.flagsNear = flagsNear;
//    this.unrevealedNear = unrevealedNear;
//    this.unrevealedMax = unrevealedMax;
//    this.numsScanned=0;
//  }
//}

//void init(){
//  for (int i = 0; i<fieldx; i++) {
//    for (int j = 0; j<fieldy; j++) {
//      Tile t = tiles[i][j];
//      aiTiles[i][j]=new aiTile(i,j,t.hidden,t.bombsNear,t.flagged,t.flagsNear,t.unrevealedNear,t.unrevealedMax);
//      if(t.hidden==false){
//        toScan.add(aiTiles[i][j]);
//      }
//      numBombs[i][j]=0;
//      numScanned[i][j]=0;
//    }
//  }
//}

//void printPer(){
//  for (int j = 0; j<fieldy; j++){
//    for (int i = 0; i<fieldx; i++) {
//      print(percentage[i][j]+"\t");
//    }
//    println();
//  }
//}

//void runai2(){
//  changed = false;
//  remainingFlags = flags;
//  toScan.clear();
//  init();
//  //println("running ai!");
//  flag();
//  fullFlags();
//  //if the simple rules didn't yield any benefit
//  if (!changed){
//    brute();
//    calcPercentages();
//    pick();
//    printPer();
//    println("can't do anything");
//  }
//}

//void pick(){
//  int x=0,y=0;
//  float min = 1;
//  for (int i = 0; i<fieldx; i++) {
//    for (int j = 0; j<fieldy; j++) {
//      //if(percentage[i][j]==0)reveal(i,j);
//      //if(percentage[i][j]==1)flagTile(i,j);
//      if(percentage[i][j]<min&&percentage[i][j]!=-1){
//        min = percentage[i][j];
//        x=i;
//        y=j;
//      }
//    }
//  }
//  println(x+" "+y+" "+min);
//  reveal(x,y);
//}

//void calcPercentages(){
//  for (int i = 0; i<fieldx; i++) {
//    for (int j = 0; j<fieldy; j++) {
//      if(numScanned[i][j]==0){
//        percentage[i][j]=-1;
//      }else{
//        percentage[i][j]=(float)numBombs[i][j]/(float)numScanned[i][j];
//      }
//    }
//  }
//}

//void brute(){
//  for(int i=0;i<toScan.size();i++){
//    aiTile t = toScan.get(i);
//    enumerate(t);
//    tryTiles(0,0,t.bombsNear-t.flagsNear);
//  }
//}

//void tryTiles(int idx,int numMines,int neededMines){
//  if(idx==toScanMini.size()){
//    if(numMines==neededMines){
//      updateNums();
//    }
//    return;
//  }
//  scanNum[idx]++;
//  scanBombs[idx]++;
//  tryTiles(idx+1,numMines+1,neededMines);
//  scanBombs[idx]--;
//  tryTiles(idx+1,numMines,neededMines);
//  scanNum[idx]--;
//}

//void updateNums(){
//  for(int i=0;i<toScanMini.size();i++){
//    aiTile t = toScanMini.get(i);
//    int x = t.posX;
//    int y = t.posY;
//    numScanned[x][y]+=scanNum[i];
//    numBombs[x][y]+=scanBombs[i];
//  }
//}

//void enumerate(aiTile t){
//  int x= t.posX;
//  int y=t.posY;
//  toScanMini.clear();
//  for(int i=0;i<8;i++){
//    scanBombs[i]=0;
//    scanNum[i]=0;
//  }
  
//  for (int i = x-1; i<=x+1; i++) {
//    for (int j = y-1; j<=y+1; j++) {
//      if(i>=0){
//        print();
//      }
//      if(i<fieldx){
//      print();
//      }
//      if(j>=0){
//      print();
//      }
//      if(j<fieldy){
//      print();
//      }
//      if(i!=x){
//      print();
//      }
//      if(j!=y){
//      print();
//      }
//      if(i>=0&&i<fieldx&&j>=0&&j<fieldy){
//        if(aiTiles[i][j].hidden==true){
//        print();
//        }
//        if(aiTiles[i][j].flagged==false){
//        print();
//        }
//      }
//      if(i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)&&aiTiles[i][j].hidden==true&&aiTiles[i][j].flagged==false){
//        toScanMini.add(aiTiles[i][j]);
//      }
//    }
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
