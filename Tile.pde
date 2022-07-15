class Tile {
  boolean bomb = false;
  boolean hidden = true;
  boolean triggerBomb = false;
  int bombsNear = 0;
  boolean flagged = false;
  int flagsNear=0;
  int unrevealedNear = 8;
  int unrevealedMax = 8;
  PVector pos;
  Tile(int x, int y) {
    pos = new PVector (x, y);
  }

  void show() {    
    stroke(107);
    if(triggerBomb){
      fill(#ff0000);
    }else{
      fill(#B9B9B9);
    }
    rect(pos.x, pos.y+headerSize, tileSize, tileSize);
    if (!hidden) {
      if (bomb) {
        image(mine,pos.x,pos.y+headerSize,tileSize,tileSize);
      } else {
        switch (bombsNear) {
        case 0:
          //fill(#244AFC); 
          image(t0,pos.x,pos.y+headerSize,tileSize,tileSize);
          return;
        case 1:
          //fill(#244AFC);    
          image(t1,pos.x,pos.y+headerSize,tileSize,tileSize);
          break;
        case 2:
          image(t2,pos.x,pos.y+headerSize,tileSize,tileSize);
          //fill(#407F07);   
          break;
        case 3:
          image(t3,pos.x,pos.y+headerSize,tileSize,tileSize);
          //fill(#E93F33);        
          break;
        case 4:
          image(t4,pos.x,pos.y+headerSize,tileSize,tileSize);
          //fill(#0D2180);        
          break;
        case 5:
          image(t5,pos.x,pos.y+headerSize,tileSize,tileSize);
          //fill(#831F18);        
          break;
        case 6:
          image(t6,pos.x,pos.y+headerSize,tileSize,tileSize);
          //fill(#3A8181);        
          break;
        case 7:
          image(t7,pos.x,pos.y+headerSize,tileSize,tileSize);
          //fill(#000000);        
          break;
        case 8:
          image(t8,pos.x,pos.y+headerSize,tileSize,tileSize);
          //fill(#808080);        
          break;
        }
        /*textSize(15);
        textAlign(CENTER, CENTER);
        text(bombsNear, pos.x+tileSize/2, pos.y+tileSize/2);*/
      }
    } else {
      if (flagged) {
        //text("f", pos.x+tileSize/2, pos.y+tileSize/2);
        image(flag,pos.x,pos.y+headerSize,tileSize,tileSize);
      }else{
        image(unclickedTile,pos.x,pos.y+headerSize,tileSize,tileSize);
      }
    }
  }
}
