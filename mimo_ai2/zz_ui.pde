class Click {
  PVector pos, size, mid, end;
  String name;
  boolean state, displaystate;
  int type = 0;
  int icon = 0;
  float textsize = 12;
  float scand = 1;
  color con = 200;
  color coff = 100;
  Click(PVector _pos, PVector _size, String _name, int _type) {
    pos=_pos;
    size=_size;
    calcpos();
    name = _name;
    type = _type;
  }
  void calcpos() {
    mid = new PVector(pos.x+size.x/2, pos.y+size.y/2);
    end = new PVector(pos.x+size.x, pos.y+size.y);
  }
  void scaletoandroid(float _scand) {
    scand = _scand;
    pos  = new PVector (scand*pos.x, scand*pos.y);
    size  = new PVector (scand*size.x, scand*size.y);
    mid  = new PVector (scand*mid.x, scand*mid.y);
    end  = new PVector (scand*end.x, scand*end.y);
    textsize = textsize * scand;
  }
  void display() {
    pushStyle();
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    textSize(textsize);
    stroke(coff);
    strokeWeight(1*scand);
    noFill();
    if (frameCount%30==0) displaystate = false;
    if (isover()) strokeWeight(2*scand);
    if (type==10||type==11) {                              //boton vacio texto afuera derecha = 0 abajo =1
      if (displaystate)  noStroke();
      if (displaystate)  fill(con);
      ellipse(mid.x, mid.y, size.x, size.y);
      fill(coff);
      if (type==10) textAlign(LEFT, CENTER);
      if (type==10) text(name, end.x+(size.x*.3), mid.y);
      if (type==11) textAlign(CENTER, CENTER);
      if (type==11) text(name, mid.x, end.y+(textsize*.8));
    }

    if (type==20||type==21) {                            // //boton redondeado =20 redondeado cuadrado =21 vacio texto adentro
      stroke(coff);
      if (displaystate)  noStroke();
      if (displaystate)  fill(con);
      if (type==20) rect(pos.x, pos.y, size.x, size.y, size.y/2);
      if (type==21) rect(pos.x, pos.y, size.x, size.y, size.y/4);
      textAlign(CENTER, CENTER);
      if (displaystate)  fill(255);
      else fill(coff);
      text(name, mid.x, mid.y);
    }
    if (type==30||type==31) {                            //boton icono texto abajo
      if (displaystate)  noStroke();
      if (displaystate)  fill(con);
      ellipse(mid.x, mid.y, size.x, size.y);
      if (displaystate) fill(255);
      if (!displaystate) fill(coff);
      drawicon(icon, mid, size);
      fill(coff);
      if (displaystate) fill(con);
      if (type==30) textAlign(CENTER, CENTER);
      if (type==30)text(name, mid.x, end.y+size.y*.15);
      if (type==31) textAlign(LEFT, CENTER);
      if (type==31) if (isover())text(name, end.x+size.x*.2, mid.y);
    }
    if (type==32) {                              //boton solo icono
      if (displaystate)  noStroke();
      if (displaystate)  fill(con);
      if (!displaystate) fill(coff);
      drawicon(icon, mid, size);
    }
    if (type==40) {                             //solo texto aparece boton
      stroke(coff);
      if (displaystate)  noStroke();
      if (displaystate)  fill(con);
      if (displaystate) rect(pos.x, pos.y, size.x, size.y, size.y/4);
      textAlign(CENTER, CENTER);
      if (displaystate)  fill(255);
      else fill(coff);
      text(name, mid.x, mid.y);
    }
    if (type==41) {                                  //texto sobre linea
      textAlign(CENTER, CENTER);
      if (displaystate)  fill(con);
      else fill(coff);
      if (isover()) strokeWeight(2*scand);
      else strokeWeight(1*scand);
      text(name, mid.x, mid.y); 
      line(pos.x, end.y, end.x, end.y);
    }
    strokeWeight(1*scand);
    popStyle();
  }

  boolean isover() {
    return  (mouseX > pos.x && mouseX < end.x  &&mouseY >pos.y && mouseY < end.y);
  }
  boolean isoverandpressed() {
    return  (isover()&&mousePressed == true);
  }
  void presson() {
    if (isover()) state = true;
    if (isover()) displaystate = true;
  }
  void pressoff() {
    if (isover()) state = false;
  }
}
class Toggle {
  PVector pos, size, mid, end, poshide, posshow;
  String name;
  boolean state;
  int type = 0;
  int icon = 0;
  float textsize = 12;
  float scand = 1;
  color con = 200;
  color coff = 100;
  Toggle(PVector _pos, PVector _size, String _name, int _type) {
    pos=_pos;
    size=_size;
    calcpos();
    name = _name;
    type = _type;
    poshide = pos;
    posshow = pos;
  }
  void calcpos() {
    mid = new PVector(pos.x+size.x/2, pos.y+size.y/2);
    end = new PVector(pos.x+size.x, pos.y+size.y);
  }
  void calcposhide(PVector _posshow) {
    poshide = pos;
    posshow = _posshow;
  }
  void scaletoandroid(float _scand) {
    scand = _scand;
    pos  = new PVector (scand*pos.x, scand*pos.y);
    size  = new PVector (scand*size.x, scand*size.y);
    mid  = new PVector (scand*mid.x, scand*mid.y);
    end  = new PVector (scand*end.x, scand*end.y);
    poshide  = new PVector (scand*poshide.x, scand*poshide.y);
    posshow  = new PVector (scand*posshow.x, scand*posshow.y);
    textsize = textsize * scand;
  }
  void display() {
    pushStyle();
    textSize(textsize);
    rectMode(CORNER);


    if (type==10||type==11||type==12) {
      stroke(coff);
      fill(255);
      rect(pos.x, pos.y, size.x, size.y, size.y);
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      if (!state) {
        stroke(coff);
        fill(255);
        ellipse(pos.x+(size.y*.5), mid.y, size.y*1.05, size.y*1.05);
      } else {
        noStroke();
        fill(con);
        rect(pos.x, pos.y, size.x, size.y, size.y); 
        fill(255);
        stroke(coff);
        ellipse(end.x-(size.y*.5), pos.y+(size.y*.5), size.y*1.05, size.y*1.05);
      }      
      fill(coff);
      if (type==11)  textAlign(CENTER, CENTER);
      if (type==11)  text(name, mid.x, end.y+textsize*.8);
      if (type==12)  textAlign (LEFT, CENTER);
      if (type==12)  text(name, end.x+textsize*.8, mid.y );
    }
    if (type==20||type==21) {            //boton icono con texto
      stroke(coff);
      noFill();
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      if (state) fill(con);
      if (state) noStroke();
      ellipse(mid.x, mid.y, size.x, size.y);
      fill(coff);
      if (state) fill(coff);
      if (state) noStroke();
      drawicon(icon, mid, size);
      textAlign(CENTER, CENTER);
      fill(coff);
      if (type==20) textAlign(CENTER, CENTER);
      if (type==20) text(name, mid.x, end.y+textsize*.8);
      if (type==21) textAlign(LEFT, CENTER);
      if (type==21) text(name, end.x+textsize*.8, mid.y);
    }
    if (type==22) {
      stroke(coff);
      noFill();
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      if (state) fill(con);
      if (state) noStroke();
      if (state) ellipse(pos.x+(size.y*.5), pos.y+(size.y*.5), size.x*1.05, size.y*1.05);
      fill(coff);
      if (state) fill(coff);
      if (state) noStroke();
      PVector a = new PVector (pos.x+(size.x*.5), pos.y+(size.y*.5));
      drawicon(icon, a, size);
      textAlign(CENTER, CENTER);
      if (state) fill(con);
      else fill(coff);
      text(name, pos.x+(size.x*.5), end.y+textsize*.8);
    }
    if (type==30||type==31) {                       //show hide bar horizontal
      stroke(coff);
      fill(255);
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      if (!state) {
        rect(poshide.x, poshide.y, size.x, size.y);
        if (type==30)line(pos.x+size.x*.5-7*scand, pos.y+size.y*.5, pos.x+size.x*.5, pos.y+size.y*.5+7*scand);
        if (type==30) line(pos.x+size.x*.5+7*scand, pos.y+size.y*.5, pos.x+size.x*.5, pos.y+size.y*.5+7*scand);
        if (type==31)       line(pos.x+(size.x*.4), pos.y+size.y*.5-(7*scand), pos.x+(size.x*.7), pos.y+size.y*.5);
        if (type==31) line(pos.x+(size.x*.4), pos.y+size.y*.5+(7*scand), pos.x+(size.x*.7), pos.y+size.y*.5);
      }
      if (state) {
        rect(poshide.x, poshide.y, posshow.x-poshide.x+size.x, posshow.y-poshide.y+size.y);
        if (type==30) line(pos.x+size.x*.5-7*scand, pos.y+size.y*.5+7*scand, pos.x+size.x*.5, pos.y+size.y*.5);
        if (type==30) line(pos.x+size.x*.5+7*scand, pos.y+size.y*.5+7*scand, pos.x+size.x*.5, pos.y+size.y*.5);
        if (type==31) line(pos.x+(size.x*.7), pos.y+size.y*.5-(7*scand), pos.x+(size.x*.4), pos.y+size.y*.5);
        if (type==31) line(pos.x+(size.x*.7), pos.y+size.y*.5+(7*scand), pos.x+(size.x*.4), pos.y+size.y*.5);
      }
    }

    if (type==40) {
      stroke(coff);
      fill(coff);
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      if (state) fill(con);
      if (state) stroke(con);
      line(pos.x, end.y, end.x, end.y);
      textAlign(CENTER, CENTER);
      text(name, pos.x+(size.x*.5), pos.y+(size.y*.5));
    }
    if (type==50) { //candado
      noStroke();      
      fill(con);
      if (state) fill(coff);
      PVector a = new PVector (pos.x+(size.x*.5), pos.y+(size.y*.5));
      if (state) drawicon(17, a, size);
      else drawicon(16, a, size);
    }
    popStyle();
  }
  void turnon() {
    state = true;
    if (type==30||type==31) {
      pos  = new PVector (posshow.x, posshow.y);
      calcpos();
    }
  }
  void turnoff() {
    state = false;
    if (type==30||type==31) {
      pos  = new PVector (poshide.x, poshide.y);
      calcpos();
    }
  }
  void press() {
    if (type!=30&&type!=31) if (isover()) state = !state;
    if (type==30||type==31) if (isover()) if (!state) turnon();
    if (type==30||type==31) if (isover()) if (state) turnoff();
  }
  boolean isover() {
    if (mouseX>pos.x&&mouseX<end.x&&mouseY>pos.y&&mouseY<end.y) return true;
    else return false;
  }
}
class Option {
  PVector pos, size, mid, end, ipos[], imid[], iend[],isize[];
  String[] names;
  boolean state, displaystate;
  int type = 0;
  int namei = 0;
  int icon = 0;
  float textsize = 12;
  float scand = 1;
  color con = 100;
  color coff = 200;
  Option(PVector _pos, PVector _size, String _names[], int _type) {
    pos = _pos;
    size=_size;
    names = _names;
    type = _type;
    calcpos();
    if (type==11||type==13) namei=-1;
  }
  void calcpos() {
    mid = new PVector (pos.x + size.x/2, pos.y + size.y/2);
    end = new PVector (pos.x + size.x, pos.y + size.y   );
    calcipos(type);
  }
  void scaletoandroid(float _scand) {
    scand = _scand;
    pos = new PVector (pos.x*scand, pos.y*scand);
    size = new PVector (size.x*scand, size.y*scand);
    textsize = textsize * scand;
    calcpos();
  }

  void calcipos(int type) {
    if (type==10||type==12) {
      ipos = new PVector [names.length];
      imid = new PVector [names.length];
      iend = new PVector [names.length];
      for (int i=0; i<ipos.length; i++) if (i==namei) ipos[i] = new PVector (pos.x, pos.y);
      for (int i=0; i<ipos.length; i++) if (i<namei) ipos[i] = new PVector (pos.x, pos.y+(i*size.y)+size.y);
      for (int i=0; i<ipos.length; i++) if (i>namei) ipos[i] = new PVector (pos.x, pos.y+(i*size.y));
      for (int i=0; i<imid.length; i++) if (i==namei) imid[i] = new PVector (pos.x+size.x*.5, pos.y+size.y*.5);
      for (int i=0; i<imid.length; i++) if (i<namei) imid[i] = new PVector (pos.x+size.x*.5, pos.y+(i*size.y)+size.y*1.5);
      for (int i=0; i<imid.length; i++) if (i>namei) imid[i] = new PVector (pos.x+size.x*.5, pos.y+(i*size.y)+size.y*0.5);
      for (int i=0; i<iend.length; i++) if (i==namei) iend[i] = new PVector (pos.x+size.x, pos.y+size.y);
      for (int i=0; i<iend.length; i++) if (i<namei) iend[i] = new PVector (pos.x+size.x, pos.y+(i*size.y)+size.y*2);
      for (int i=0; i<iend.length; i++) if (i>namei) iend[i] = new PVector (pos.x+size.x, pos.y+(i*size.y)+size.y*1);
    }
    if (type==11) {
      ipos = new PVector [names.length];
      imid = new PVector [names.length];
      iend = new PVector [names.length];
      for (int i=0; i<ipos.length; i++) ipos[i] = new PVector (pos.x, pos.y+size.y+(size.y*i));
      for (int i=0; i<imid.length; i++) imid[i] = new PVector (pos.x+(size.x*.5), pos.y+size.y+(size.y*i)+(size.y*.5));
      for (int i=0; i<iend.length; i++) iend[i] = new PVector (pos.x+(size.x), pos.y+size.y+(size.y*i)+(size.y));
    }
    if (type==13) {
      ipos = new PVector [names.length];
      imid = new PVector [names.length];
      iend = new PVector [names.length];
      isize = new PVector [names.length];
      for (int i=0; i<ipos.length; i++) {
        PVector locPos = new PVector(pos.x,pos.y-(size.y*2*(i/3))-size.y);
        if (i%3==0) locPos = new PVector(pos.x-size.x,locPos.y);//-size.y*i-size.y);
        if (i%3==1) locPos = new PVector(pos.x,locPos.y);
        if (i%3==2) locPos = new PVector(pos.x+size.x,locPos.y);
        ipos[i] = new PVector (locPos.x, locPos.y);
        imid[i] = new PVector (ipos[i].x+size.x*.5,ipos[i].y+size.y*.5);
        iend[i] = new PVector (ipos[i].x+size.x,ipos[i].y+size.y);
        isize[i] = new PVector(size.x,size.y*1.2);
      }
      //for (int i=0; i<imid.length; i++) imid[i] = new PVector (pos.x+size.x+size.x*i+size.x*.5, pos.y+size.y*.5);
      //for (int i=0; i<iend.length; i++) iend[i] = new PVector (pos.x+size.x+size.x*i+size.x, pos.y+size.y);
    }
    if (type==20||type==30) {
      ipos = new PVector [names.length];
      imid = new PVector [names.length];
      iend = new PVector [names.length];
      for (int i=0; i<ipos.length; i++) ipos[i] = new PVector (pos.x+(size.x*i), pos.y);
      for (int i=0; i<imid.length; i++) imid[i] = new PVector (pos.x+(size.x*i)+(size.x*.5), pos.y+(size.y*.5));
      for (int i=0; i<iend.length; i++) iend[i] = new PVector (pos.x+(size.x*i)+(size.x), pos.y+(size.y));
    }
  }
  void display() {
    pushStyle();
    textSize(textsize);
    if (type==10) {
      stroke(con);
      if (isover()) strokeWeight (2*scand);
      else strokeWeight(1*scand);
      fill(255);
      textAlign(RIGHT, CENTER);
      noFill();
      strokeWeight(1);
      if (state) {
        for (int i=0; i<ipos.length; i++) {
          if (isoveri()[i])  strokeWeight (2);
          else strokeWeight(1);
          fill(255);
          rect(ipos[i].x, ipos[i].y, size.x, size.y, size.y/4);
          fill(con);

          if (i!=namei) text(names[i], iend[i].x-25, imid[i].y);
        }
      }   
      line(end.x-15*scand, mid.y, end.x-10*scand, mid.y+5*scand);
      line(end.x-5*scand, mid.y, end.x-10*scand, mid.y+5*scand);
      fill(con);
      text(names[namei], end.x-20*scand, mid.y);
    }
    if (type==11||type==13) {
      stroke(con);
      if (isover()) strokeWeight (2*scand);
      else strokeWeight(1*scand);
      fill(con);
      //text(namei,pos.x,pos.y-15);
      //rect(pos.x, pos.y, size.x, size.y);
      PVector a = new PVector (pos.x+(size.x*.5), pos.y+(size.y*.5));
      PVector isizex = new PVector (size.y, size.y);
      fill(con);
      drawicon(icon, a, isizex);
      if (state) for (int i=0; i<ipos.length; i++) {
        textAlign(CENTER, CENTER);
        fill(255);
        if (isoveri()[i])  strokeWeight (2);
        else strokeWeight(1);
        PVector isized = new PVector (isize[i].x, isize[i].y);
        rect(ipos[i].x, ipos[i].y, isized.x, isized.y);
        fill(con);
        text(names[i], imid[i].x, imid[i].y);
      }
    }
    if (type==12) {
      stroke(con);
      if (isover()) strokeWeight (2*scand);
      else strokeWeight(1*scand);
      fill(255);
      textAlign(CENTER, CENTER);
      noFill();
      strokeWeight(1);
      if (state) {
        for (int i=0; i<ipos.length; i++) {
          if (isoveri()[i])  strokeWeight (2);
          else strokeWeight(1);
          fill(255);
          rect(ipos[i].x, ipos[i].y, size.x, size.y, size.y/4);
          fill(con);
          if (i!=namei) text(names[i], imid[i].x, imid[i].y-5*scand);
        }
      }   
      noStroke();
      fill(255);
      rect(pos.x, pos.y, size.x, size.y, size.y/4);
      stroke(con);
      line(mid.x-5*scand, end.y-9*scand, mid.x-0*scand, end.y-4*scand);
      line(mid.x+5*scand, end.y-9*scand, mid.x-0*scand, end.y-4*scand);
      fill(con);
      text(names[namei], mid.x, mid.y-5*scand);
    }

    if (type==20) {
      rectMode(CORNER);
      textAlign(CENTER, CENTER);
      for (int i=0; i<names.length; i++) if (i!=namei) {     
        noFill();
        stroke(coff);
        strokeWeight(1*scand);

        if (isoveri()[i]) strokeWeight(1.5*scand);
        rect(ipos[i].x, ipos[i].y, size.x, size.y);
        fill(coff);
        text(names[i], imid[i].x, imid[i].y);
      }
      for (int i=0; i<names.length; i++) if (i==namei) {
        stroke(con);
        strokeWeight(1.5*scand);
        line(ipos[i].x, ipos[i].y, ipos[i].x, iend[i].y);
        line(ipos[i].x, ipos[i].y, iend[i].x, ipos[i].y);
        line(iend[i].x, ipos[i].y, iend[i].x, iend[i].y);
        fill(con);
        text(names[i], imid[i].x, imid[i].y);
      }
    }
    if (type==30) {

      for (int i=0; i<names.length; i++) if (i!=namei) {     
        fill(coff);
        stroke(coff);
        strokeWeight(1*scand);
        if (isoveri()[i]) strokeWeight(1.5*scand);
        ellipse( imid[i].x, imid[i].y, 7*scand, 7*scand);
      }
      for (int i=0; i<names.length; i++) if (i==namei) {
        fill(con);
        stroke(con);
        strokeWeight(1*scand);
        if (isoveri()[i]) strokeWeight(1.5*scand);
        ellipse( imid[i].x, imid[i].y, 7*scand, 7*scand);
      }
    }
    popStyle();
  }
  boolean otherselectarr(Option [] allsl) {
    boolean bout=false;
    for (Option o : allsl) if (o.state) bout = true;
    if (state) bout = false;
    return bout;
  }
  boolean isover() {
    if (mouseX>pos.x&&mouseX<end.x&&mouseY>pos.y&&mouseY<end.y) return true;
    else return false;
  }
  boolean [] isoveri() {
    boolean [] bout = new boolean [names.length];
    for (int i=0; i<bout.length; i++) {
      if (mouseX>ipos[i].x&&mouseX<iend[i].x&&mouseY>ipos[i].y&&mouseY<iend[i].y) bout[i] = true;
      else bout[i] = false;
    }
    return bout;
  }
  void press() {
    if (type==10||type==11||type==12||type==13) {
      if (isover()) state = !state;
      if (state) for (int i=0; i<names.length; i++) if (i!=namei||type==11||type==13) {
        if (isoveri()[i]) {
          namei = i;
          state = !state;
        }
      }
      calcipos(type);
    }
    if (type==20||type==30) {
      for (int i=0; i<names.length; i++)  if (isoveri()[i]) {
        namei = i;
      }
    }
  }
  void pressoff() {
    if (type==11||type==13) namei=-1;
  }
}
void drawicon(int icon, PVector pos, PVector size) {
  if (icon==0) { 
    pushMatrix();
    rect(pos.x-size.x*.35, pos.y, size.x*.7, size.y*.1, size.y*.1);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    popMatrix();
  }
  if (icon==1) {  //INFORMATION
    rectMode(CENTER);
    ellipse(pos.x, pos.y-size.y*.3, size.y*.1, size.y*.1);
    rect(pos.x, pos.y+size.y*.1, size.x*.1, size.y*.5, size.y*.1);
    rect(pos.x-size.x*.1, pos.y-size.y*.1, size.x*.2, size.y*.1, size.y*.1);
    rectMode(CORNER);
  }
  if (icon==2) { //PLUS
    rect(pos.x-size.x*.4, pos.y-size.y*.05, size.x*.8, size.y*.1, size.y*.1);
    rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
  }
  if (icon==3) {  // SAVED MOUSE
    pushMatrix();
    rect(pos.x-size.x*.05, pos.y-size.y*.3, size.y*.1, size.y*.4, size.y*.1);
    rect(pos.x-size.x*.35, pos.y+size.y*.2, size.x*.7, size.y*.1, size.y*.1);
    translate(size.x*.3, -size.y*.4);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(HALF_PI);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.35, pos.y, size.x*.4, size.y*.1, size.y*.1);
    popMatrix();
  }
  if (icon==4) {       //HOME
    pushMatrix();
    rect(pos.x-size.x*.3, pos.y-size.y*+.15, size.y*.1, size.y*.3, size.y*.1);
    rect(pos.x+size.x*.18, pos.y-size.y*+.15, size.y*.1, size.y*.3, size.y*.1);
    rect(pos.x-size.x*.35, pos.y+size.y*.2, size.x*.7, size.y*.1, size.y*.1);
    translate(size.x*.3, -size.y*.4);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(HALF_PI);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.03);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    popMatrix();
  }

  if (icon==5) {  // SAVE
    pushMatrix();
    rect(pos.x-size.x*.05, pos.y-size.y*.4, size.y*.1, size.y*.5, size.y*.1);
    rect(pos.x-size.x*.35, pos.y+size.y*.2, size.x*.7, size.y*.1, size.y*.1);
    translate(size.x*.3, -size.y*.4);
    translate(pos.x-size.x*.3, pos.y+size.y*.50);
    rotate(PI*1.5);
    rotate( QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate( -2*QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    popMatrix();
  }

  if (icon==6) {  // PENCIL
    pushMatrix();
    translate(pos.x, pos.y);
    rotate( -QUARTER_PI);
    translate(-pos.x, -pos.y);
    rect(pos.x-size.y*.15, pos.y-size.y*.1, size.x*.5, size.y*.15, size.y*.1);
    rotate( QUARTER_PI);
    popMatrix();
    triangle(pos.x-size.x*.2, pos.y+size.x*.15, pos.x-size.x*.2, pos.y+size.x*.2, pos.x-size.x*.15, pos.y+size.x*.2);
  }
  if (icon==7) {  // DELETE HOMES
    pushMatrix();
    translate(pos.x, pos.y);
    rotate( -QUARTER_PI);
    translate(-pos.x, -pos.y);
    rect(pos.x-size.x*.4, pos.y-size.y*.05, size.x*.8, size.y*.1, size.y*.1);
    rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
    popMatrix();
  }
  if (icon==8) {  // BUY HOME
    pushMatrix();
    translate(pos.x, pos.y);
    rotate( -QUARTER_PI);
    translate(-pos.x, -pos.y);
    translate(-size.x*.1, size.y*.1);
    rect(pos.x-size.y*.15, pos.y-size.y*.05, size.x*.6, size.y*.15, size.y*.1);
    rect(pos.x-size.y*.15, pos.y-size.y*.3, size.x*.15, size.y*.4, size.y*.1);
    popMatrix();
  }

  if (icon==9) { //MINUS
    rect(pos.x-size.x*.4, pos.y-size.y*.05, size.x*.8, size.y*.1, size.y*.1);
    //rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
  }
  if (icon==10) {  //MORE 3 PUNTOS
    ellipse(pos.x-size.x*.3, pos.y, size.y*.2, size.y*.2);
    ellipse(pos.x, pos.y, size.y*.2, size.y*.2);
    ellipse(pos.x+size.x*.3, pos.y, size.y*.2, size.y*.2);
  }
  if (icon==11) { //ACCOUNT
    rect(pos.x-size.x*.35, pos.y+size.y*.2, size.x*.7, size.y*.1, size.y*.1);
  }
  if (icon==12) {  // GENERATE
    pushMatrix();
    rect(pos.x-size.x*.3, pos.y-size.y*+.15, size.y*.1, size.y*.3, size.y*.1);
    rect(pos.x+size.x*.18, pos.y-size.y*+.15, size.y*.1, size.y*.3, size.y*.1);

    rect(pos.x-size.x*.1, pos.y+size.y*.2, size.x*.3, size.y*.1, size.y*.1);
    rect(pos.x+size.x*.1-size.x*.1, pos.y+size.y*.1, size.x*.1, size.y*.3, size.y*.1);

    translate(size.x*.3, -size.y*.4);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(HALF_PI);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.05);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    translate(pos.x-size.x*.3, pos.y+size.y*.05);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3, -pos.y-size.y*.03);
    rect(pos.x-size.x*.3, pos.y, size.x*.4, size.y*.1, size.y*.1);
    popMatrix();
  }
  if (icon==13) { //MINUS
    rect(pos.x-size.x*.2, pos.y-size.y*.025, size.x*.4, size.y*.05, size.y*.05);
    //rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
  }

  if (icon==14) { //PLUS
    rect(pos.x-size.x*.2, pos.y-size.y*.025, size.x*.4, size.y*.05, size.y*.05);
    rect(pos.x-size.x*.025, pos.y-size.y*.2, size.x*.05, size.y*.4, size.y*.05);
  }
  if (icon==15) { //MINUS
    rect(pos.x-size.x*.3, pos.y-size.y*.2, size.x*.6, size.y*.06, size.y*.03);
    rect(pos.x-size.x*.3, pos.y-size.y*.0, size.x*.6, size.y*.06, size.y*.03);
    rect(pos.x-size.x*.3, pos.y+size.y*.2, size.x*.6, size.y*.06, size.y*.03);
    //rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
  }
  if (icon==16) { //LOCK OPEN
    rect(pos.x-size.x*.25, pos.y-size.y*.1, size.x*.5, size.y*.1, size.y*.05);
    rect(pos.x-size.x*.25, pos.y+size.y*.2, size.x*.5, size.y*.1, size.y*.05);
    rect(pos.x-size.x*.25, pos.y-size.y*.3, size.x*.5, size.y*.1, size.y*.05);
    rect(pos.x-size.x*.25, pos.y-size.y*.3, size.y*.1, size.x*.55, size.y*.05);
    rect(pos.x+size.x*.25-size.x*.1, pos.y-size.y*.1, size.x*.1, size.x*.35, size.y*.05);
    rect(pos.x- size.x*.05, pos.y+size.y*.02, size.x*.1, size.y*.15, size.y*.05);
  }

  if (icon==17) { //LOCK CLOSE
    rect(pos.x-size.x*.25, pos.y-size.y*.1, size.x*.5, size.y*.1, size.y*.05);
    rect(pos.x-size.x*.25, pos.y+size.y*.2, size.x*.5, size.y*.1, size.y*.05);
    rect(pos.x-size.x*.25, pos.y-size.y*.3, size.x*.5, size.y*.1, size.y*.05);
    rect(pos.x-size.x*.25, pos.y-size.y*.3, size.y*.1, size.x*.55, size.y*.05);
    rect(pos.x+size.x*.25-size.x*.1, pos.y-size.y*.3, size.y*.1, size.x*.55, size.y*.05);
    rect(pos.x- size.x*.05, pos.y+size.y*.02, size.x*.1, size.y*.15, size.y*.05);
  }
}

void star5(PVector pos, PVector size) {
  PVector mid = new PVector(pos.x+size.x*.5, pos.y+size.y*.5);
  float angle = TWO_PI / 5;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = mid.x + cos(a) * size.x*.5;
    float sy = mid.y + sin(a) * size.x*.5;
    vertex(sx, sy);
    sx = mid.x + cos(a+halfAngle) * size.x*.25;
    sy = mid.y + sin(a+halfAngle) * size.x*.25;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void starsys(PVector pos, PVector size, int calif, color coff, color con) {
  for (int i=0; i<5; i++) {
    if (i<calif) fill(con);
    else fill(coff);
    star5(new PVector (pos.x+((size.x/5)*i), pos.y), new PVector (size.y, size.y));
  }
}
class Slider {
  PVector pos, size, mid, end, bupos, bupos2, busize, slsize, slstopb, slstope, clpos, clsize;
  String name;
  float value, value2, minstopv, maxstopv;
  boolean state, drag, drag2;
  float  minV=0;
  float maxV=1;
  float flt = 1;
  int type = 0;
  int icon = 0;
  float textsize = 12;
  float textdist = 90;
  float scand = 1;
  color con = 100;
  color coff = 200;
  Slider(PVector _pos, PVector _size, String _name, int _type, float _minV, float _value, float _maxV) {
    pos=_pos;
    size=_size;
    calcpos();
    nostops();
    name = _name;
    type = _type;
    minV=_minV;
    value = _value;
    value2=value;
    maxV=_maxV;
  }
  void calcpos() {
    mid = new PVector(pos.x+size.x*.5, pos.y+size.y*.5);
    end = new PVector(pos.x+size.x, pos.y+size.y);
    bupos  = new PVector (map(value, minV, maxV, pos.x, end.x), mid.y);
    bupos2 = new PVector (map(value2, minV, maxV, pos.x, end.x), mid.y);
    busize = new PVector (size.y, size.y);
    slsize = new PVector (size.x, 3*scand);
    clpos = new PVector (pos.x-busize.x, pos.y);
    clsize = new PVector (busize.x, busize.y*2);
    if (type==11) {
      bupos  = new PVector (mid.x, map(value, minV, maxV, pos.y, end.y));
      bupos2 = new PVector (mid.x, map(value2, minV, maxV, pos.y, end.y));
      busize = new PVector (size.x, size.x);
      slsize = new PVector (3*scand, size.y);
      clpos = new PVector (pos.x-busize.y*.5, pos.y-busize.y);
      clsize = new PVector (busize.x*2, busize.y);
    }
  }
  void nostops() {
    slstopb = new PVector (pos.x, pos.y);
    slstope = new PVector (end.x, end.y);
  }
  void scaletoandroid(float _scand) {
    scand = _scand;
    pos  = new PVector (scand*pos.x, scand*pos.y);
    size  = new PVector (scand*size.x, scand*size.y);
    calcpos();
    slstopb = new PVector (scand*slstopb.x, scand*slstopb.y);
    slstope = new PVector (scand*slstope.x, scand*slstope.y);
    textsize = textsize * scand;
  }
  void addstops(float _minstopV, float _maxstopV) {
    minstopv = _minstopV;
    maxstopv = _maxstopV;
    slstopb = new PVector (map(minstopv, minV, maxV, pos.x, end.x), map(minstopv, minV, maxV, pos.y, end.y));
    slstope = new PVector (map(maxstopv, minV, maxV, pos.x, end.x), map(maxstopv, minV, maxV, pos.y, end.y));
  }
  void addsecond(float _value2) {
    value2 = _value2;
    calcpos();
  }
  void display() {
    pushStyle();
    rectMode(CORNER);
    textSize(textsize);
    if (type==10) {                                   //Simple horizontal 
      value = rg(map(bupos.x, pos.x, end.x, minV, maxV), flt); 
      if (drag) bupos.x = constrain(mouseX, slstopb.x, slstope.x);
      println(pos.x);
      if (slstopb!=null)if (slstopb.x!=pos.x) line(slstopb.x, mid.y-(busize.y*.2), slstopb.x, mid.y+(busize.y*.2));
      if (slstope!=null)if (slstope.x!=end.x) line(slstope.x, mid.y-(busize.y*.2), slstope.x, mid.y+(busize.y*.2));
      noStroke();
      fill(coff);
      rect(pos.x, mid.y-slsize.y*.5, slsize.x, slsize.y, slsize.y*.5); 
      fill(con);
      rect(pos.x, mid.y-slsize.y*.5, bupos.x-pos.x, slsize.y, slsize.y/2); 
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      stroke(con);
      fill(255);
      ellipse(bupos.x, mid.y, busize.x, busize.y);
      fill(con);
      textAlign(CENTER, CENTER);
      if (flt>1) text( int(value), bupos.x, bupos.y-busize.y*.5-textsize*.8);
      else text( nfc(value, 2), bupos.x, bupos.y-busize.y*.5-textsize*.8); 
      fill(con);
      textAlign(LEFT, CENTER);
      text(name, pos.x-textdist, mid.y);
      strokeWeight(1*scand);
    }     
    if (type==11) {                                   //Simple vertical sin nombre
      value = rg(map(bupos.y, pos.y, end.y, minV, maxV), flt); 
      if (drag) bupos.y = constrain(mouseY, slstopb.y, slstope.y);
      fill(255);
      stroke(coff);

      if (state) {
        rect(clpos.x, clpos.y, clsize.x, size.y+clsize.y, busize.y/4);
        if (slstopb!=null)if (slstopb.y!=pos.y) line(mid.x-busize.x*.2, slstopb.y, mid.x+busize.x*.2, slstopb.y);
        if (slstope!=null)if (slstope.y!=end.y) line(mid.x-busize.x*.2, slstope.y, mid.x+busize.x*.2, slstope.y);
        noStroke();
        fill(coff);
        rect( mid.x-slsize.x*.5, pos.y, slsize.x, slsize.y, slsize.x*.5); 
        fill(con);
        rect( mid.x-slsize.x*.5, pos.y, slsize.x, bupos.y-pos.y, slsize.x/2); 
        strokeWeight(1*scand);
        if (isover()) strokeWeight(2*scand);
        stroke(con);
        fill(255);
        ellipse(bupos.x, bupos.y, busize.x, busize.y);
        stroke(coff);
      }
      strokeWeight(1*scand);
      if (isovercl()) strokeWeight(2*scand);
      if (!state) {
        noStroke();
        rect(clpos.x, clpos.y, busize.x*2, busize.y, busize.y/4);
        stroke(con);
        line(clpos.x+busize.x, clpos.y+busize.y-scand*5, clpos.x+busize.x-scand*5, clpos.y+busize.y-scand*10);
        line(clpos.x+busize.x, clpos.y+busize.y-scand*5, clpos.x+busize.x+scand*5, clpos.y+busize.y-scand*10);
      }
      if (state) {
        line(clpos.x+busize.x, clpos.y+busize.y-scand*10, clpos.x+busize.x-scand*5, clpos.y+busize.y-scand*5);
        line(clpos.x+busize.x, clpos.y+busize.y-scand*10, clpos.x+busize.x+scand*5, clpos.y+busize.y-scand*5);
      }
      fill(con);
      textAlign(CENTER, CENTER);

      if (flt>=1) text( int(value), mid.x, pos.y-busize.y*.7);
      else text( nfc(value, 2), mid.x, pos.y-busize.y*.7); 
      fill(con);
      textAlign(CENTER, CENTER);
      //text(name,  mid.x,pos.y-textsize*2);
      strokeWeight(1*scand);
    }     







    if (type==20) {                        //Doble horizontal
      value = rg(map(bupos.x, pos.x, end.x, minV, maxV), flt);
      value2 = rg(map(bupos2.x, pos.x, end.x, minV, maxV), flt);

      if (drag) bupos.x = constrain(mouseX, slstopb.x, bupos2.x-busize.y);
      if (drag2) bupos2.x = constrain(mouseX, bupos.x+busize.y, slstope.x);
      if (slstopb!=null)if (slstopb.x!=pos.x) line(slstopb.x, slstopb.y-(busize.y*.2), slstopb.x, slstopb.y+slsize.y+(busize.y*.2));
      if (slstope!=null)if (slstope.x!=end.x) line(slstope.x, slstope.y-slsize.y-(busize.y*.2), slstope.x, slstope.y+(busize.y*.2));
      noStroke();
      fill(coff);
      rect(pos.x, mid.y-slsize.y*.5, slsize.x, slsize.y, slsize.y*.5); 
      fill(con);
      rect(bupos.x, mid.y-slsize.y*.5, bupos2.x-bupos.x, slsize.y, slsize.y/2); 
      strokeWeight(1*scand);
      stroke(con);
      fill(255);
      if (isover()) strokeWeight(2*scand);
      else  strokeWeight(1*scand);
      ellipse(bupos.x, mid.y, busize.x, busize.y);
      if (isover2()) strokeWeight(2*scand);
      else  strokeWeight(1*scand);
      ellipse(bupos2.x, mid.y, busize.x, busize.y);
      fill(con);
      textAlign(CENTER, CENTER);
      if (flt>1) text(int(value), bupos.x, pos.y-busize.y*.5-textsize*.8);
      else text( nfc(value, 2), bupos.x, pos.y-busize.y*.5-textsize*.8); 
      if (flt>1) text( int(value2), bupos2.x, pos.y-busize.y*.5-textsize*.8);
      else text( nfc(value2, 2), bupos2.x, pos.y-busize.y*.5-textsize*.8); 
      fill(con);
      textAlign(LEFT, CENTER);
      text(name, pos.x-textdist, mid.y);
      strokeWeight(1*scand);
    }









    popStyle();
  }
  boolean isover() {
    return (mouseX>bupos.x-busize.x*.5&&mouseX<bupos.x+busize.x*.5&&mouseY>bupos.y-busize.y*.5&&mouseY<bupos.y+busize.y*.5);
  }
  boolean isover2() {
    return (mouseX>bupos2.x-busize.x*.5&&mouseX<bupos2.x+busize.x*.5&&mouseY>bupos.y-busize.y*.5&&mouseY<bupos.y+busize.y*.5);
  }
  boolean isovercl() {
    return (mouseX>clpos.x&&mouseX<clpos.x+clsize.x&&mouseY>clpos.y&&mouseY<clpos.y+clsize.y);
  }
  boolean otherselectlist(ArrayList <Slider> allsl) {
    boolean bout=false;
    for (Slider o : allsl) if (o.state) bout = true;
    if (state) bout = false;
    ;
    return bout;
  }
  boolean otherselectarr(Slider [] allsl) {
    boolean bout=false;
    for (Slider o : allsl) if (o.state) bout = true;
    if (state) bout = false;
    ;
    return bout;
  }  
  void press() {
    if (type==11) {
      if (isovercl()) state = !state;
      if (state) {
        if (isover()) drag = true;
        if (isover2()) drag2 = true;
      }
    }
    if (type!=11) {
      if (isover()) drag = true;
      if (isover2()) drag2 = true;
    }
  }
  void release() {
    drag = false;
    drag2 = false;
  }
  float roundit(float numin, int dec) {                                              
    float dec10 = pow(10, dec);
    float roundout = round(numin * dec10)/dec10;
    return roundout;
  }
  float rg(float fin, float grunit) {
    float fout = fin + grunit*.5;
    fout = roundit(fout-(fout%grunit), 2);
    return fout;
  }
}
class Text {
  PVector pos, size, mid, end;
  String name;
  boolean state;
  String itext = "";
  String dash = "|";
  int type = 0;
  int icon = 0;
  float textsize = 12;
  float scand = 1;
  color con = 200;
  color coff = 100;
  Text(PVector _pos, PVector _size, String _name, int _type) {
    pos=_pos;
    size=_size;
    calcpos();
    name = _name;
    type = _type;
  }
  void scaletoandroid(float _scand) {
    scand = _scand;
    pos = new PVector (pos.x*scand, pos.y*scand);
    size = new PVector (size.x*scand, size.y*scand);
    calcpos();
    textsize  = textsize*scand;
  }
  void calcpos() {
    mid = new PVector(pos.x+size.x*.5, pos.y+size.y*.5);
    end = new PVector(pos.x+size.x, pos.y+size.y);
  }
  void display() {
    textSize(textsize);
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    fill(coff);
    stroke(con);
    strokeWeight(1*scand);
    //rect(pos.x,pos.y,size.x,size.y);
    if (isover()||state) fill(con);
    if (isover()||state) stroke(con);
    if (isover()||state) strokeWeight(2*scand);
    line(pos.x, pos.y+size.y, pos.x+size.x, pos.y+size.y);
    if (itext.length()==0&&!state) text(name, mid.x, mid.y-textsize*.3);
    if (type==10&&itext.length()<50) {
      if (state) text(itext+dash, mid.x, mid.y-textsize*.3);
      else text(itext, mid.x, mid.y-textsize*.3);
    }
    if (type==20&&itext.length()<50) {
      String textp = "";
      for (int i=0; i<itext.length(); i++) textp = textp + "*";
      if (state) text(textp+dash, mid.x, mid.y-textsize*.3);
      else text(textp, mid.x, mid.y-textsize*.3);
    }
  }
  boolean isover() {
    if (mouseX>pos.x&&mouseX<end.x&&mouseY>pos.y&&mouseY<end.y) return true;
    else return false;
  }
  void presson() {
    if (isover()) state = !state;
  }
  void pressoff() {
    if (state)if (!isover()) state = false;
  }
  void type() {
    if (state) {
      if ((key >= 'A' && key <= 'z') ||(key >= '0' && key <= '9') || key == ' '|| key=='('|| key==')'|| key==','|| key=='.'|| key=='|'||key=='@'||key=='-'||key=='_')   itext = itext + str(key);
      if ((key == CODED&&keyCode == LEFT)||keyCode == BACKSPACE)  if (itext.length()>0) itext = itext.substring(0, itext.length()-1);
    }
  }
}

boolean textis(ArrayList <Text> alltx) {
  boolean bout = false;
  for (Text a : alltx) if (a.state) bout = true;
  return bout;
}
class Textrect {
  PVector pos, size;
  String text;
  float scand = 1;
  float textsize = 12;
  int i;
  Textrect(PVector _pos, PVector _size, String _text, int _i) {
    pos=_pos;
    size=_size;
    text=_text;
    i=_i;
  }
  void scaletoandroid(float _scand) {
    scand = _scand;
    pos = pos.copy().mult(scand);
    size = size.copy().mult(scand);
    textsize = textsize*scand;
  }
  void display() {
    pushStyle();
    textSize(textsize);
    fill(255);
    textAlign(CENTER, CENTER);
    //rect(pos.x, pos.y, size.x, size.y);
    fill(100);
    if (text!=null) text(text, pos.x + size.x*.5, pos.y + size.y*.5);
    popStyle();
  }
}
