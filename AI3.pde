aiTile aiTiles[][] = new aiTile[fieldx][fieldy]; //<>// //<>//
float numBombs[][]=new float[fieldx][fieldy];
boolean changed = false;
int configs = 0;
int remainingFlags=0;
ArrayList<aiTile> toScan = new ArrayList<aiTile>();
ArrayList<aiTile> toScanValid = new ArrayList<aiTile>();
ArrayList<aiTile> toScanMini = new ArrayList<aiTile>();
ArrayList<ArrayList<aiTile>> segments = new ArrayList<ArrayList<aiTile>>();
boolean lateGame = false;
class aiTile {
  int posX=0;
  int posY = 0;
  boolean hidden = true;
  int bombsNear = 0;
  boolean flagged = false;
  int flagsNear=0;
  int unrevealedNear = 9;    //tweak this
  int triedNear = 0;
  int unrevealedMax = 8;
  boolean tried = false;
  aiTile(int posX, int posY, boolean hidden, int bombsNear, boolean flagged, int flagsNear, int unrevealedNear, int unrevealedMax) {
    this.posX = posX;
    this.posY = posY;
    this.hidden = hidden;
    this.bombsNear=bombsNear;
    this.flagged = flagged;
    this.flagsNear = flagsNear;
    this.unrevealedNear = unrevealedNear;
    this.unrevealedMax = unrevealedMax;
    this.tried=false;
  }

  boolean equals(aiTile t) {
    if (t.posX==this.posX&&t.posY==this.posY)return true;
    return false;
  }
}

void init() {
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      Tile t = tiles[i][j];
      aiTiles[i][j]=new aiTile(i, j, t.hidden, t.bombsNear, t.flagged, t.flagsNear, t.unrevealedNear, t.unrevealedMax);
      if (t.flagged||!t.hidden||t.unrevealedNear==t.unrevealedMax&&lateGame==false) {
        numBombs[i][j]=-1;
      } else {
        //toScan.add(aiTiles[i][j]);
        numBombs[i][j]=0;
      }
    }
  }
}

void init_Segments() {

  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      Tile t = tiles[i][j];
      aiTiles[i][j]=new aiTile(i, j, t.hidden, t.bombsNear, t.flagged, t.flagsNear, t.unrevealedNear, t.unrevealedMax);
      if (t.flagged||!t.hidden||t.unrevealedNear==t.unrevealedMax) {
      } else {
        toScan.add(aiTiles[i][j]);
      }
    }
  }

  segments.clear();
  isLateGame();
  if (lateGame) {
    toScanMini = new ArrayList<aiTile>();
    for (int i = 0; i<fieldx; i++) {
      for (int j = 0; j<fieldy; j++) {
        aiTile t = aiTiles[i][j];
        if (t.hidden ==true) {
          if (t.flagged==false&& t.hidden==true) {
            toScanMini.add(t);
            numBombs[i][j]=0;
          }
        }
      }
    }
    segments.add(toScanMini);
    println("late Game");
    //println(cntRemaining());
    return;
  }

  while (toScan.size()!=0) {
    toScanMini = new ArrayList<aiTile>();
    toScanMini.add(toScan.get(0));
    toScan.remove(toScan.get(0));
    for (int i=0; i<toScanMini.size(); i++) {
      if (toScan.size()==0)break;
      aiTile t = toScanMini.get(i);    //check this
      addRelated(t);
    }
    segments.add(toScanMini);
  }
}

void addSourrounding(int x, int y) {
  for (int i = x-1; i<=x+1; i++) {
    for (int j = y-1; j<=y+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(x==i&&i==j)) {
        if (aiTiles[i][j].hidden==true&&aiTiles[i][j].flagged==false) {
          toScan.add(aiTiles[i][j]);
        }
      }
    }
  }
}

void isLateGame() {
  int cnt = 0;
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      if (tiles[i][j].flagged==false&& tiles[i][j].hidden==true) {
        cnt++;
      }
    }
  }
  if (cnt<=26)lateGame = true;
}

void addRelated(aiTile t) {
  int j=0;
  //toScanMini.add(ti);
  while (j<toScan.size()) {
    aiTile tj = toScan.get(j);
    if (isRelated(t, tj)) {
      toScanMini.add(tj);
      toScan.remove(tj);
      j--;
    }
    j++;
  }
}

boolean isRelated(aiTile t1, aiTile t2) {
  for (int i = t1.posX-1; i<=t1.posX+1; i++) {
    for (int j = t1.posY-1; j<=t1.posY+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy) {
        if (tiles[i][j].hidden==false) {
          for (int k = t2.posX-1; k<=t2.posX+1; k++) {
            for (int l = t2.posY-1; l<=t2.posY+1; l++) {
              if (k>=0&&k<fieldx&&l>=0&&l<fieldy) {
                if (tiles[k][l].hidden==false) {
                  if (i==k&&j==l)return true;
                }
              }
            }
          }
        }
      }
    }
  }
  return false;  //implement this
}

void printNum() {
  for (int j = 0; j<fieldy; j++) {
    for (int i = 0; i<fieldx; i++) {
      print(numBombs[i][j]+"\t");
    }
    println();
  }
  println();
}
void runai() {
  lateGame = false;
  changed = false;
  toScan.clear();
  if (tilesCleared<8) {
    pickRandom();
  }
  init_Segments();
  //println("running ai!");
  flag();
  fullFlags();
  //if the simple rules didn't yield any benefit
  if (!changed) {
    init();

    println("segments"+segments.size());
    while (segments.size()>0&&changed==false) {
      configs = 0;
      remainingFlags = flags;
      toScan = getSmallest();
      toScanValid = getScanValid();
      println("trying: "+toScan.size()+" elements");
      if (toScan.size()<=35||lateGame==true) {    //adjust this
        tryTile(0);
      } else {
        println("can't Compute");
        markInvalid();
      }

      print("configs:");
      println(configs);
      calcPercentages();
      printNum();
      for (int i = 0; i<fieldx; i++) {
        for (int j = 0; j<fieldy; j++) {
          if (tiles[i][j].hidden ==true&&checkSameRun(aiTiles[i][j])) {    //consider changing tiles to aiTiles
            if (numBombs[i][j]==1&&configs!=0) {
              flagTile(i, j);
              changed=true;
            }
            if (numBombs[i][j]==0&&configs!=0) {
              reveal(i, j);
              changed=true;
            }
          }
        }
      }
      println("can't do anything");
      //calcPercentages();
    }
    if (!changed) {
      println("picking lowest percentage");
      int x=-1, y=-1;
      float smallest=1;
      for (int i = 0; i<fieldx; i++) {
        for (int j = 0; j<fieldy; j++) {
          if (numBombs[i][j]!=-1&&numBombs[i][j]<smallest) {
            smallest=numBombs[i][j];
            x=i;
            y=j;
          }
        }
      }
      if (x!=-1) {
        reveal(x, y);
        changed=true;
      }
    }
    if (!changed) {
      println("picking random");
      pickRandom();
    }
  }
}

void markInvalid() {
  for (aiTile t : toScan) {
    int x = t.posX;
    int y = t.posY;
    numBombs[x][y]=-1;
  }
}


void pickRandom() {
  if (cntCorners()>0) {
    pickCorner();
  }
  while (!changed) {
    int x = (int)random(fieldx);
    int y = (int)random(fieldy);
    if (tiles[x][y].hidden==true&&tiles[x][y].flagged==false) {
      reveal(x, y);
      changed=true;
    }
  }
}

void pickCorner() {
  while (!changed) {
    int corner = (int)random(4);
    int x, y;
    //println("Corner: "+corner);
    switch (corner) {
    case 0:
      x = 0;
      y = 0;
      if (tiles[x][y].hidden==true&&tiles[x][y].flagged==false) {
        reveal(x, y);
        changed=true;
      }
      break;
    case 1:
      x = fieldx-1;
      y = 0;
      if (tiles[x][y].hidden==true&&tiles[x][y].flagged==false) {
        reveal(x, y);
        changed=true;
      }
      break;
    case 2:
      x = 0;
      y = fieldy-1;
      if (tiles[x][y].hidden==true&&tiles[x][y].flagged==false) {
        reveal(x, y);
        changed=true;
      }
      break;
    case 3:
      x = fieldx-1;
      y = fieldy-1;
      if (tiles[x][y].hidden==true&&tiles[x][y].flagged==false) {
        reveal(x, y);
        changed=true;
      }
      break;
    }
  }
}

int cntCorners() {
  int cnt=0;
  if (tiles[0][0].hidden==true&&tiles[0][0].flagged==false) cnt++;
  if (tiles[fieldx-1][0].hidden==true&&tiles[fieldx-1][0].flagged==false) cnt++;
  if (tiles[0][fieldy-1].hidden==true&&tiles[0][fieldy-1].flagged==false) cnt++;
  if (tiles[fieldx-1][fieldy-1].hidden==true&&tiles[fieldx-1][0].flagged==false) cnt++;
  return cnt;
}

boolean checkSameRun(aiTile t) {
  for (aiTile x : toScan) {
    if (x.posX==t.posX&&x.posY==t.posY)return true;
  }
  return false;
}

void calcPercentages() {
  for (aiTile t : toScan) {
    if (configs>0) {
      numBombs[t.posX][t.posY]/=(float)configs;
    }

    if (numBombs[t.posX][t.posY]<0&&numBombs[t.posX][t.posY]!=-1) {
      errors++;
    }
  }
}

ArrayList<aiTile> getScanValid() {
  ArrayList<aiTile> ans = new ArrayList<aiTile>();
  for (aiTile t : toScan) {
    for (int i = t.posX-1; i<=t.posX+1; i++) {
      for (int j = t.posY-1; j<=t.posY+1; j++) {
        if (i>=0&&i<fieldx&&j>=0&&j<fieldy&&tiles[i][j].hidden==false) {
          aiTile temp = aiTiles[i][j];
          if (ans.contains(temp)==false)ans.add(temp);
        }
      }
    }
  }
  return ans;
}


ArrayList<aiTile> getSmallest() {
  ArrayList<aiTile> smallest= segments.get(0); 
  for (int i=1; i<segments.size(); i++) {
    ArrayList<aiTile> temp = segments.get(i);
    if (temp.size()<smallest.size()) {
      smallest = temp;
    }
  }
  segments.remove(smallest);
  return smallest;
}

void fullFlags() {              //reveal the tiles around a tile that has the same number of flags around it as the number of bombs supposed to be near it
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      if (tiles[i][j].hidden ==false) {
        if (tiles[i][j].flagsNear == tiles[i][j].bombsNear) {
          fullFlags_reveal(i, j);
          //changed = true;
        }
      }
    }
  }
}

void fullFlags_reveal(int x, int y) {
  for (int i = x-1; i<=x+1; i++) {
    for (int j = y-1; j<=y+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy&&tiles[i][j].hidden==true&&tiles[i][j].flagged==false) {
        reveal(i, j);
        changed = true;
      }
    }
  }
}

void flag() {    // if a tile has the same number of uncleared tiles around it as the number of bombs supposed to be near it then they all should be flagged
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      if (tiles[i][j].hidden ==false) {
        if (tiles[i][j].unrevealedNear == tiles[i][j].bombsNear) {
          flagTilesAround(i, j);
          //changed = true;
        }
      }
    }
  }
}

void flagTilesAround(int x, int y) {
  for (int i = x-1; i<=x+1; i++) {
    for (int j = y-1; j<=y+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy&&tiles[i][j].hidden==true&&tiles[i][j].flagged == false) {
        flagTile(i, j);
        changed = true;
      }
    }
  }
}

void tryTile(int i) {
  if (i==toScan.size()) {
    if (isValid()) {      //remove the true
      recordConfig();
      configs++;
    }
    return;
  }
  aiTile t = toScan.get(i);
  aiTiles[t.posX][t.posY].tried=true;
  //PVector next = getNext(i,j);
  //if (t.hidden==false||t.flagged==true||hasNoClearedNear(t)) {    //check if you need this in the first place
  //  tryTile(i+1);
  //  return;
  //}                                      
  //println("here");
  if (lateGame) {
    if (remainingFlags>0) {
      aiFlagTile(t.posX, t.posY);
      tryTile(i+1);
      aiFlagTile(t.posX, t.posY);
      tryTile(i+1);
    } else {
      tryTile(i+1);
    }
  } else {
    if (remainingFlags>0) {
      aiFlagTile(t.posX, t.posY);
      if (checkSurrounding(t.posX, t.posY, i))tryTile(i+1);
      aiFlagTile(t.posX, t.posY);
      if (checkSurrounding(t.posX, t.posY, i))tryTile(i+1);
    } else {
      tryTile(i+1);
    }
  }
  aiTiles[t.posX][t.posY].tried=false;

  //add a condition to check if the number of currently flagged exceeds the number of flags in the game
}

boolean checkSurrounding(int x, int y, int index) {
  for (int i = x-1; i<=x+1; i++) {
    for (int j = y-1; j<=y+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)) {
        aiTile t = aiTiles[i][j];
        if (t.hidden == false) {
          if (t.flagsNear > t.bombsNear)return false;
          if(triedAllNear(i,j)&&t.flagsNear < t.bombsNear)return false;
        }
      }
    }
  }
  return true;
}

boolean triedAllNear(int x, int y) {
  //println("size"+toScan.size());
  int cnt = 0;
  for (int i = x-1; i<=x+1; i++) {
    for (int j = y-1; j<=y+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)) {
        aiTile t = aiTiles[i][j];
        if (t.hidden == true&&t.flagged==false) {
          //println("index: "+toScan.indexOf(t)+"current: "+index);
          if (t.tried==true)cnt++;                                  //check this condition      also this sometimes finds a tile that isn't in the toScan list
        }
      }
    }
  }
  if (cnt==aiTiles[x][y].unrevealedNear)return true;
  return false;
}

/*boolean checkSurroundingValid(int x, int y){
 for (int i = x-1; i<=x+1; i++) {
 for (int j = y-1; j<=y+1; j++) {
 if(i>=0&&i<fieldx&&j>=0&&j<fieldy){  //consider adding x!=i, y!=j to the condition
 aiTile t = aiTiles[i][j];
 if(t.hidden == false){
 if(t.flagsNear != t.bombsNear)return false;      //check this condition
 }
 }
 }
 }
 return true;
 }*/

boolean hasNoClearedNear(aiTile t) {
  /*print("unrevealedNear: ");
   println(t.unrevealedNear);
   print("unrevealedMax: ");
   println(t.unrevealedMax);*/
  if (t.unrevealedNear==t.unrevealedMax)return true;
  return false;
}

boolean isValid() {
  //printValidMatrix();
  if (lateGame) {
    for (int i = 0; i<fieldx; i++) {
      for (int j = 0; j<fieldy; j++) {
        if (tiles[i][j].hidden ==false&&aiTiles[i][j].bombsNear!=aiTiles[i][j].flagsNear) {
          return false;
        }
      }
    }
    return true;
  } else {
    for (aiTile t : toScanValid) {
      if (t.flagsNear!=t.bombsNear) {
        return false;
      }
    }
    return true;
  }
}

void printValidMatrix() {
  //println("valid matrix:");
  //for (int j = 0; j<fieldy; j++) {
  //  for (int i = 0; i<fieldx; i++) {
  //    print((/*aiTiles[i][j].bombsNear-*/aiTiles[i][j].flagsNear)+"\t");
  //  }
  //  println();
  //}
  //println();
}

void recordConfig() {
  for (int i = 0; i<fieldx; i++) {
    for (int j = 0; j<fieldy; j++) {
      if (tiles[i][j].hidden ==true) {
        if (numBombs[i][j]!=-1&&aiTiles[i][j].flagged==true) {
          numBombs[i][j]++;
        }
      }
    }
  }
}

PVector getNext(int x, int y) {
  PVector vec = new PVector();
  if (x<fieldx-1) {
    vec.x=x+1;
    vec.y=y;
  } else {
    vec.y=y+1;
    vec.x=0;
  }
  return vec;
}

void aiFlagTile(int x, int y) {
  if (aiTiles[x][y].flagged) {
    aiTiles[x][y].flagged=false;
    remainingFlags++;
    aiUpdateFlagCount(x, y, -1);
  } else if (!aiTiles[x][y].flagged&&remainingFlags>0) {       //check this condition
    aiTiles[x][y].flagged=true;
    remainingFlags--;
    aiUpdateFlagCount(x, y, 1);
  }
}
boolean aiUpdateFlagCount(int x, int y, int increment) {
  for (int i = x-1; i<=x+1; i++) {
    for (int j = y-1; j<=y+1; j++) {
      if (i>=0&&i<fieldx&&j>=0&&j<fieldy&&!(i==x&&j==y)) {
        aiTiles[i][j].flagsNear+=increment;
      }
    }
  }
  return true;
}


//add condition to scan all tiles if the remaining tiles are less than 26
//implement algorithm for linked tiles
//clean up the code
//consider making aiTile inherit from tile
// make a method to pass x,y and open if hidden and not flagged
