class Mueble {
  int tipo;
  int rot;
  PVector pos, pos2;
  Mueble(  int _tipo, int _rot, PVector _pos, PVector _pos2) {
    tipo = _tipo;
    rot = _rot;
    pos=_pos;
    pos2=_pos2;
  }
  Mueble cloneit() {
    Mueble cout = new Mueble(tipo, rot, pos, pos2);
    return cout;
  }
  void display() {
    pushStyle();
    if (pos!=null&&pos2!=null) drawmueble(tipo, rot, pos, pos2);
    popStyle();
  }
}
ArrayList <Mueble> calcmuebleslist(Node node) {
  ArrayList <Mueble> mout = new ArrayList <Mueble> ();
  if (txequal(roomnonumber(node.code), "Cl")) mout.add(new Mueble(7, 0, node.zones.get(0).pt[0], node.zones.get(0).pt[1]));
  if (txequal(roomnonumber(node.code), "Be")) for (Zone z : node.zones) for (Border b : z.borders) if (b.id[4]==8) if (z.zwidth()>2&&z.zlength()>2) {
    if (b.adj!=null) mout.add(new Mueble(10, -(b.id[2]+1), b.pmid().copy(), node.zones.get(0).pt[1]));
    else  mout.add(new Mueble(0, -(b.id[2]+1), b.pmid().copy(), node.zones.get(0).pt[1]));
  }

  if (txequal(roomnonumber(node.code), "Ba")) {
    boolean entsi = false;
    for (Zone z : node.zones) for (Border b : z.borders) if (b.id[4]==5)  if (b.id[2]==0||b.id[2]==1) entsi = true; 
    float [][]ap = {{.25, .75}, {.75, .25}};
    for (Zone z : node.zones) for (Border b : z.borders) if (b.id[4]==8) {
      PVector lavpos = new PVector(b.pt[0].x*ap[int(entsi)][0]+b.pt[1].x*ap[int(!entsi)][0], b.pt[0].y*ap[int(entsi)][0]+b.pt[1].y*ap[int(!entsi)][0]);
      PVector wcpos = new PVector(b.pt[0].x*.5+b.pt[1].x*.5, b.pt[0].y*.5+b.pt[1].y*.5);
      PVector duchpos = new PVector(b.pt[0].x*ap[int(entsi)][1]+b.pt[1].x*ap[int(!entsi)][1], b.pt[0].y*ap[int(entsi)][1]+b.pt[1].y*ap[int(!entsi)][1]);
      mout.add(new Mueble(1, -(b.id[2]+1), lavpos, node.zones.get(0).pt[1]));
      mout.add(new Mueble(3, -(b.id[2]+1), wcpos, node.zones.get(0).pt[1]));
      mout.add(new Mueble(5, -(b.id[2]+1), duchpos, node.zones.get(0).pt[1]));
    }
  }
  if (txequal(roomnonumber(node.code), "Li")) {
    PVector mesapos = new PVector (0, 0);
    PVector livinpos = new PVector (0, 0);
    PVector mesa2pos = new PVector (0, 0);
    Zone zodraw = node.zones.get(0);
    if (zodraw.lengthisx()) {
      mesapos = new PVector (wavgfloat(zodraw.pt[0].x, zodraw.pt[1].x, .25), zodraw.pmid().y);
      livinpos = new PVector (wavgfloat(zodraw.pt[0].x, zodraw.pt[1].x, .75), zodraw.pmid().y-zodraw.ydim()*.15);
      mesa2pos = new PVector (wavgfloat(zodraw.pt[0].x, zodraw.pt[1].x, .75), zodraw.pmid().y+zodraw.ydim()*.15);
    } else {
      mesapos = new PVector (zodraw.pmid().x, wavgfloat(zodraw.pt[0].y, zodraw.pt[1].y, .25));
      livinpos = new PVector (zodraw.pmid().x-zodraw.xdim()*.15, wavgfloat(zodraw.pt[0].y, zodraw.pt[1].y, .75));
      mesa2pos = new PVector (zodraw.pmid().x+zodraw.xdim()*.15, wavgfloat(zodraw.pt[0].y, zodraw.pt[1].y, .75));
    }                
    mout.add(new Mueble(6, 0, mesapos, node.zones.get(0).pt[1]));
    mout.add(new Mueble(2, int(!zodraw.lengthisx())*3, livinpos, node.zones.get(0).pt[1]));
    mout.add(new Mueble(4, int(!zodraw.lengthisx()), mesa2pos, node.zones.get(0).pt[1]));
  }
  if (txequal(roomnonumber(node.code), "Ki")) {
    PVector livinpos = new PVector (0, 0);
    PVector mesa2pos = new PVector (0, 0);
    Zone zodraw = node.zones.get(0);
    if (zodraw.lengthisx()) {
      livinpos = new PVector (wavgfloat(zodraw.pt[0].x, zodraw.pt[1].x, .25), zodraw.pmid().y);
      mesa2pos = new PVector (wavgfloat(zodraw.pt[0].x, zodraw.pt[1].x, .75), zodraw.pmid().y);
    } else {
      livinpos = new PVector (zodraw.pmid().x, wavgfloat(zodraw.pt[0].y, zodraw.pt[1].y, .25));
       mesa2pos = new PVector (zodraw.pmid().x, wavgfloat(zodraw.pt[0].y, zodraw.pt[1].y, .75));
    }                
    mout.add(new Mueble(9, int(!zodraw.lengthisx()), livinpos, node.zones.get(0).pt[1]));
    mout.add(new Mueble(91, int(!zodraw.lengthisx()), mesa2pos, node.zones.get(0).pt[1]));
  }





  return mout;
}

void drawmueble(int tipo, int rot, PVector pos, PVector pos2) {
  PVector scpos  = scgr(pos);
  PVector scpos2  = scgr(pos2);
  float scgrid= scsif(grunit);
  rectMode(CORNER);
  pushMatrix();
  translate(scpos.x, scpos.y);
  rotate(HALF_PI*rot);
  translate(-scpos.x, -scpos.y);
  strokeWeight(1*scand);
  if (tipo%2==0) stroke(180);
  if (tipo%2==1) stroke(200);
  noFill();
  if (tipo==0) {    // BED WITH BARGUENOS
    PVector bed = new PVector(1.6*grscale, 2*grscale);
    PVector sheet = new PVector(1.6*grscale, .6*grscale);
    PVector sheet2 = new PVector(1.6*grscale, .9*grscale);
    PVector pillow = new PVector(.4*grscale, .2*grscale);
    PVector buro = new PVector(.4*grscale, .4*grscale);
    rect(scpos.x-bed.x*.5, scpos.y, bed.x, bed.y);
    rect(scpos.x-bed.x*.5, scpos.y, sheet.x, sheet.y);
    rect(scpos.x-bed.x*.5, scpos.y, sheet2.x, sheet2.y);
    rect(scpos.x+(.2*grscale)-bed.x*.5, scpos.y+(.2*grscale), pillow.x, pillow.y);
    rect(scpos.x+(1*grscale)-bed.x*.5, scpos.y+(.2*grscale), pillow.x, pillow.y);
    rect(scpos.x-(.6*grscale)-bed.x*.5, scpos.y+(.2*grscale), buro.x, buro.y);
    rect(scpos.x+bed.x+(.2*grscale)-bed.x*.5, scpos.y+(.2*grscale), buro.x, buro.y);
  }

  if (tipo==1) {  //LAVABO
    PVector lavabo = new PVector (.8*grscale, .4*grscale);
    PVector circ  = new PVector (.4*grscale, .3*grscale);
    rect(scpos.x-lavabo.x*.5, scpos.y, lavabo.x, lavabo.y);
    ellipse(scpos.x, scpos.y+lavabo.y*.5, circ.x, circ.y);
    line(scpos.x, scpos.y, scpos.x, scpos.y+lavabo.y*.5);
  }

  if (tipo==2) {  //SOFA 3  CAMBIAR A 2
    PVector mueble =  new PVector(2.2*grscale, .8*grscale);
    PVector cojin =  new PVector(.6*grscale, .6*grscale);
    rect(scpos.x-mueble.x*.5, scpos.y-mueble.y*.5, mueble.x, mueble.y, mueble.y*.2);
    rect(scpos.x+grscale*.2-mueble.x*.5, scpos.y+mueble.y-mueble.y*.5, cojin.x, -cojin.y, mueble.y*.2);
    rect(scpos.x+grscale*.8-mueble.x*.5, scpos.y+mueble.y-mueble.y*.5, cojin.x, -cojin.y, mueble.y*.2);
    rect(scpos.x+grscale*1.4-mueble.x*.5, scpos.y+mueble.y-mueble.y*.5, cojin.x, -cojin.y, mueble.y*.2);
    line(scpos.x+grscale*.2-mueble.x*.5, scpos.y+grscale*.2-mueble.y*.5, scpos.x+mueble.x*.5-grscale*.2, scpos.y+grscale*.2-mueble.y*.5);
  }
  if (tipo==3) {  //WC
    PVector tapa =  new PVector(.5*grscale, .25*grscale);
    PVector retrete =  new PVector(.3*grscale, .45*grscale);
    rect(scpos.x-tapa.x*.5, scpos.y, tapa.x, tapa.y, tapa.y*.2);
    rect(scpos.x+grscale*.1-tapa.x*.5, scpos.y+tapa.y+grscale*.05, retrete.x, retrete.y, tapa.y*.2);
  }
  if (tipo==4) { //mesa
    PVector mesa =  new PVector(1.2*grscale, .4*grscale);
    rect(scpos.x-mesa.x*.5, scpos.y-mesa.y*.5, mesa.x, mesa.y, mesa.y*.2);
  }
  if (tipo==5) { //DUCHA
    PVector ducha =  new PVector(.8*grscale, .8*grscale);
    rect(scpos.x-ducha.x*.5, scpos.y, ducha.x, ducha.y);
    ellipse(scpos.x, scpos.y+ducha.y*.3, .1*grscale, .1*grscale);
  }
  if (tipo==6) { //MESA COMedor 3personas
    PVector mesa =  new PVector(.7*grscale, .7*grscale);
    PVector asientos =  new PVector(1.1*grscale, 1.1*grscale);
    ellipse(scpos.x, scpos.y, mesa.x, mesa.y);
    arc(scpos.x, scpos.y, asientos.x, asientos.y, PI, PI+QUARTER_PI);
    arc(scpos.x, scpos.y, asientos.x, asientos.y, -.4*PI, -.4*PI+QUARTER_PI);
    arc(scpos.x, scpos.y, asientos.x, asientos.y, .3*PI, .3*PI+QUARTER_PI);
  }
  if (tipo==7) {  //CLOSET MODULOS //scgrid
    for (float x=scpos.x; x<scpos2.x; x+=scgrid) for (float y=scpos.y; y<scpos2.y; y+=scgrid) {
      if (x+scgrid<=scpos2.x&&y+scgrid<=scpos2.y) {
        rect(x, y, scgrid, scgrid);
        line(x, y, x+scgrid, y+scgrid);
        line(x+scgrid, y, x, y+scgrid);
      } else if (x+scgrid>scpos2.x&&y+scgrid<=scpos2.y) {
        rect(x, y, scpos2.x-x, scgrid);
        line(x, y, scpos2.x, y+scgrid);
        line(scpos2.x, y, x, y+scgrid);
      } else {
        rect(x, y, scgrid, scpos2.y-y);
        line(x, y, x+scgrid, scpos2.y);
        line(x+scgrid, y, x, scpos2.y);
      }
    }
  }

  if (tipo==8) {   //BEDROOM 1 CAMA
    PVector bed = new PVector(1.2*grscale, 2*grscale);
    PVector sheet = new PVector(1.2*grscale, .6*grscale);
    PVector sheet2 = new PVector(1.2*grscale, .9*grscale);
    PVector pillow = new PVector(.8*grscale, .2*grscale);
    PVector buro = new PVector(.4*grscale, .4*grscale);
    rect(scpos.x-bed.x*.5, scpos.y, bed.x, bed.y);
    rect(scpos.x-bed.x*.5, scpos.y, sheet.x, sheet.y);
    rect(scpos.x-bed.x*.5, scpos.y, sheet2.x, sheet2.y);
    rect(scpos.x+(.2*grscale)-bed.x*.5, scpos.y+(.2*grscale), pillow.x, pillow.y);
    rect(scpos.x-(.6*grscale)-bed.x*.5, scpos.y+(.2*grscale), buro.x, buro.y);
  }

  if (tipo==9) {   //COCINA MUEBLE
    PVector tarja = new PVector(.6*grscale, .4*grscale);
    rect(scpos.x-tarja.x*.5, scpos.y-tarja.y*.5, tarja.x, tarja.y);
    line(scpos.x, scpos.y-tarja.y*.5, scpos.x, scpos.y-tarja.y*.5+.2*grscale);
  }

  if (tipo==91) {   //COCINA TARJA
    PVector tarja = new PVector(.6*grscale, .4*grscale);
    rect(scpos.x-tarja.x*.5, scpos.y-tarja.y*.5, tarja.x, tarja.y);
    line(scpos.x, scpos.y-tarja.y*.5, scpos.x, scpos.y+tarja.y*.5);
    line(scpos.x-tarja.x*.5, scpos.y, scpos.x+tarja.x*.5, scpos.y);
  }


  if (tipo==10) {   //MASTER BEDROOM NO SIDETABLE
    PVector bed = new PVector(1.6*grscale, 2*grscale);
    PVector sheet = new PVector(1.6*grscale, .6*grscale);
    PVector sheet2 = new PVector(1.6*grscale, .9*grscale);
    PVector pillow = new PVector(.4*grscale, .2*grscale);

    rect(scpos.x-bed.x*.5, scpos.y, bed.x, bed.y);
    rect(scpos.x-bed.x*.5, scpos.y, sheet.x, sheet.y);
    rect(scpos.x-bed.x*.5, scpos.y, sheet2.x, sheet2.y);
    rect(scpos.x+(.2*grscale)-bed.x*.5, scpos.y+(.2*grscale), pillow.x, pillow.y);
    rect(scpos.x+(1*grscale)-bed.x*.5, scpos.y+(.2*grscale), pillow.x, pillow.y);
  }




  popMatrix();
}
