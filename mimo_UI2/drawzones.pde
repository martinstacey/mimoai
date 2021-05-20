Drawzones dz;
void setupdz() {
  dz = new Drawzones();
}
void drawdz() {
  if (dr.state)  dz.displaypoint();
  if (dr.state)  dz.display();
}
void pressdz() {

   if (!dr.isover())if (dr.state) dz.press();
  if (dz.zns.size()>0) {
    if (dr.isover())if (dr.state){
      setuphoinedges(dz.zns); 
      recalctree();
      recalchouse();
      dz.zns = new ArrayList <Zone>(); 
    }
  }
}

class Drawzones {
  ArrayList <Zone> zns;
  PVector p00, p11;

  Drawzones() {
    zns = new ArrayList <Zone>();
  }
  void displaypoint() {
    pushStyle();
    strokeWeight(2*scand);
    stroke(50);
    noFill();

    PVector gridedmouse =scgr(mouseshrink(new PVector (mouseX, mouseY))); 
    if (validarea(zns)) {
      ellipse(gridedmouse.x, gridedmouse.y, 7*scand, 7*scand);

      line(gridedmouse.x-10*scand, gridedmouse.y, gridedmouse.x+10*scand, gridedmouse.y);
      line(gridedmouse.x, gridedmouse.y-10*scand, gridedmouse.x, gridedmouse.y+10*scand);
    }
    strokeWeight(2*scand);
    stroke(150);
    if (p00!=null)  hiddenrec(scgr(p00).x, scgr(p00).y, gridedmouse.x, gridedmouse.y);




    popStyle();
  }
  void display() {
    if (zns!=null) for (int i=0; i<zns.size(); i++) zns.get(i).displaycreate();
  }
  void press() {
    if (validarea(zns))if (p00==null&&p11==null) p00  = mouseshrink(new PVector (mouseX, mouseY));
    else if (p00!=null&&p11==null) {
      if (validarea(zns)) {
        p11  = mouseshrink(new PVector (mouseX, mouseY));
        zns.add(new Zone(p00, p11));
        p00=null;
        p11=null;
      }
    }
  }
  void emptyzones() {
    zns = new ArrayList <Zone>();
    p00=null;
    p11=null;
  }
}
void hiddenrec(float p00x, float p00y, float p11x, float p11y) {
  daline(new PVector (p00x, p00y), new PVector (p00x, p11y), 10*scand); 
  daline(new PVector (p00x, p11y), new PVector (p11x, p11y), 10*scand); 
  daline(new PVector (p11x, p11y), new PVector (p11x, p00y), 10*scand); 
  daline(new PVector (p11x, p00y), new PVector (p00x, p00y), 10*scand);
}

void hashrectangle(float ax, float ay, float bx, float by) {
 rectMode(CORNERS);
 //fill(255,0,0);
  if (bx>ax) for (float x=ax; x<bx;x+=grunit) if (by>ay) for (float y=ay; y<by;y+=grunit){
  PVector beg = scgr(new PVector(x,y));
  PVector end = scgr(new PVector(x+grunit,y+grunit));
  PVector midmas =  scgr(new PVector(x+grunit*.5,y+grunit*.5)); 
    //rect(beg.x,beg.y,end.x,end.y); 
  daline(beg,end, 5*scand);
  daline(new PVector (midmas.x,beg.y), new PVector (end.x,midmas.y,5*scand),5*scand);
    daline(new PVector (beg.x,midmas.y), new PVector (midmas.x,end.y,5*scand),5*scand);
 }

  //hiddenrec(ax, ay, bx, by);
  //for (float i=0; i<1; i+=.1) daline(new PVector(ax, ay*i+by*(1-i)), new PVector(ax*i+bx*(1-i), ay), 5*scand);
  //for (float i=0; i<1; i+=.1) daline(new PVector(bx, ay*i+by*(1-i)), new PVector (ax*i+bx*(1-i), by), 5*scand);


  //for (float i=0;i<1;i+=.1) line(p00x*i+p11x*(1-i),p00y*(1-i)+p11y*i,p00x*(1-i)+p11x*i,p00y*i+p11y*(1-i));
}

boolean validarea(ArrayList <Zone> czones) {
  boolean bout = true;
  if (!(grpos.x<mouseX&&mouseX<grpos.x+grsize.x&&grpos.y<mouseY&&mouseY<grpos.y+grsize.y)) bout = false;
  for (int i=0; i<czones.size(); i++) {
    PVector p0 = scgr(czones.get(i).pt[0]);
    PVector p1 = scgr(czones.get(i).pt[1]);
    if (p0.x<mouseX&&p1.x>mouseX&&p0.y<mouseY&&p1.y>mouseY) bout = false;
  }
  return bout;
}
