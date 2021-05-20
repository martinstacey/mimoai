import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Nodesubdivision8 extends PApplet {

//sirve candados
float scand = 1;
String [] rooms = {"Be", "Cl", "La"};  //0:code 1:name 2:area
int [] lockIN = {0, 0};
String [][] roomDATAIN={{"Be", "Bedr", "5", "0.5", "10"}, {"Ba", "Bathroom", "6.4", "0.5", "10"}, {"Cl", "Closet", "1.28", "0.5", "10"}, {"Di", "Dining", "19.2", "0.5", "10"}, {"Ki", "Kitchen", "2.56", "0.5", "10"}, {"La", "Laundry", "1.92", "0.5", "10"}, {"Li", "Living", "20.48", "0.5", "10"}, {"Ha", "Hall", "1.92", "0.5", "10"}};
String [][] roomDATA=getroomDATA(rooms, roomDATAIN);
int [] lockgenes = getroomLOCKS(rooms, lockIN);
public void setup() {
  
  setupgr();
  setupho();
  setuptr();
  setupid();
  setupsl(rooms, roomDATA);
}
public void draw() {
  background(255);
  drawgr();
  drawho();
  drawsl();
}
public void mousePressed() {
  presssl();
  lockpress();
  pressadddrooms();
  pressho();
}
public void mouseReleased() {
  releasesl();
}
public void keyPressed() {
  typeho();
  if (key == 'l') {
    ho.insertbgenes(lockgenes);
    ho.insertgenes(ranflarr(ho.ngenes, 0, 1));
    setuptr();
    setupid();
  }
  if (key == 'p') {
    rooms = addtostarr(rooms, "Ki");
    roomDATA=getroomDATA(rooms, roomDATAIN);
    lockgenes = getroomLOCKS(rooms, lockIN);
    setupsl(rooms, roomDATA);
    setupho();
    setuptr();
    setupid();
  }
}
//agregar silders en este falta maxWidth etc
House ho;

public void setupho() {
  ArrayList <Zone> homedges= new ArrayList <Zone> ();
  homedges.add(new Zone (new PVector(0, 0), new PVector(1, 1)));
  //homedges.add(new Zone (new PVector(0, 0), new PVector(.5, 1)));
  //homedges.add(new Zone (new PVector(.5, .2), new PVector(1, .8)));
  ho = new House(rooms, homedges);
}

public void setuptr() {
  ho.insertbgenes(lockgenes);
  ho.calctree();
  ho.calcrela();
}
public void setupid() {
  ho.calcideal();
  ho.calcsubparam();
  ho.calchouse();
  ho.strechzones();
  ho.calcreals();

  ho.calcsubparamminmax();
  ho.calchouse();
  ho.strechzones();
  ho.calcreals();
}
public void drawho() {
  ho.displaytree();
  ho.displayhouse();
}
public void pressho() {
  ho.press();
}
public void typeho() {
  ho.type();
}
class House {
  String [] rooms;
  
  
  float permgene, locgene[], subgene[];
  ArrayList <Node> no;
  int nrooms, ngenes;
  PVector treesize = new PVector(180*scand, 30*scand);
  PVector treepos = new PVector(600*scand, 30*scand);
  ArrayList <Zone> homedges;
  Nodegene [] ng;
  House(String [] _rooms, ArrayList <Zone> _homedges) {
    rooms = _rooms;
    nrooms = rooms.length;
    ngenes =min0(nrooms-2)+1+min0(nrooms-1);
    
    //ng = new Nodegene [1+min0(rooms.length-2)+min0(rooms.length-1)];
    locgene= new float [min0(rooms.length-2)];
    subgene= new float [min0(rooms.length-1)];
    homedges=_homedges;
    
    //insertgenes(ranflarr(1+(rooms.length-2)+(rooms.length-1), 0, 1));
    float ingenes [] = {0, 0, 0, 0};

    ng = new Nodegene [ngenes];
    for (int i=getngnum("lmin", nrooms); i<getngnum("lmax", nrooms); i++) ng[i] = new Nodegene ("l", 0, false, new PVector(treepos.x-treesize.x, treepos.y+i*15*scand));
    for (int i=getngnum("pmin", nrooms); i<getngnum("pmax", nrooms); i++) ng[i] = new Nodegene ("p", 0, false, new PVector(treepos.x-treesize.x, treepos.y+i*15*scand));
    for (int i=getngnum("smin", nrooms); i<getngnum("smax", nrooms); i++) ng[i] = new Nodegene ("s", 0, false, new PVector(treepos.x-treesize.x, treepos.y+i*15*scand));
    //ng = clonengarrwithgenes(ng,ranflarr(ngenes,0,1));
    insertgenes(ranflarr(ngenes, 0, 1));

    //ng = clonengarrwithgenes(ng, ingenes);
  }
  public void insertgenes(float geneins[]) {   
    if (geneins.length<ng.length)  for (int i=0; i<geneins.length; i++) if (!ng[i].inactive) ng[i].value = geneins[i];
    if (geneins.length>=ng.length) for (int i=0; i<ng.length; i++)      if (!ng[i].inactive) ng[i].value = geneins[i];
  }
  public void insertbgenes(int genebins[]) { 
    if (genebins.length<ng.length)  for (int i=0; i<genebins.length; i++) ng[i].inactive = PApplet.parseBoolean(genebins[i]);
    if (genebins.length>=ng.length) for (int i=0; i<ng.length; i++)       ng[i].inactive = PApplet.parseBoolean(genebins[i]);
  } 
  public void calctree() {
    no = nodecrea(rooms, ngvalues(ng, getngnum("lmin", nrooms), getngnum("lmax", nrooms)));
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) no.get(n).code = permutation01(rooms, ngvalue(ng, getngnum("pmin", nrooms)))[no.get(n).leafi];
    for (int n=0; n<no.size(); n++) if (!no.get(n).isleaf) no.get(n).subparam[0] = roundit(ngvalue(ng, no.get(n).inneri+getngnum("smin", nrooms)), 2)+"";
    for (int n=0; n<no.size(); n++) if (!no.get(n).isleaf) ng[no.get(n).inneri+getngnum("smin", nrooms)].loc = no.get(n).loc; //nombrar loc de ngs
    
    
    for (int n=0; n<no.size(); n++) no.get(n).ischilda = ifischilda(no.get(n).loc);
    for (int n=0; n<no.size(); n++) no.get(n).calcnodepos(treepos, treesize);
  }
  public void calcrela() {
    for (int n=0; n<no.size(); n++) no.get(n).father = calcrelative(no.get(n), no, "father");
    for (int n=0; n<no.size(); n++) no.get(n).childa = calcrelative(no.get(n), no, "childa");
    for (int n=0; n<no.size(); n++) no.get(n).childb = calcrelative(no.get(n), no, "childb");
    for (int n=0; n<no.size(); n++) no.get(n).brother =calcrelative(no.get(n), no, "brother");
  }
  public void calcideal() {
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int i=0; i<no.get(n).ideals.length; i++) no.get(n).ideals[i] = roomideals(no.get(n).code, i, roomDATA);
    for (int n=no.size()-1; n>=0; n--) if (!no.get(n).isleaf) no.get(n).ideals[2] = (PApplet.parseFloat(no.get(n).childa.ideals[2])+PApplet.parseFloat(no.get(n).childb.ideals[2]))+"";
  }
  public void calcsubparam() {
    for (int n=0; n<no.size(); n++) if (no.get(n).father!=null) no.get(n).subparam[1] = roundit(PApplet.parseFloat(no.get(n).ideals[2])/PApplet.parseFloat(no.get(n).father.ideals[2]), 2)+"";
  }
  public void calchouse() {
    no = calcallzones(no, homedges);
  }
  public void calcreals() { //0 :code 1:name 2: area 3:minW
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) no.get(n).reals[2] = no.get(n).zones.get(z).area+"";   //area
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) no.get(n).reals[3] = no.get(n).zones.get(0).zwidth+"";                //minwidth
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) no.get(n).reals[4] = no.get(n).zones.get(0).zwidth+"";                //minwidth
  }
  public void calcsubparamminmax() {
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0)   if (PApplet.parseFloat(no.get(n).ideals[4])<PApplet.parseFloat(no.get(n).reals[4])||(PApplet.parseFloat(no.get(n).ideals[3])>PApplet.parseFloat(no.get(n).reals[3]))) {
      if (PApplet.parseFloat(no.get(n).ideals[3])>PApplet.parseFloat(no.get(n).reals[3])) println(no.get(n).ideals[0]+ ": width too small");
      if (PApplet.parseFloat(no.get(n).ideals[4])<PApplet.parseFloat(no.get(n).reals[4])) println(no.get(n).ideals[0]+ ": width too big");
      
      boolean childx = ischildx(PApplet.parseFloat(no.get(n).father.subparam[0]));
      boolean lengthisx = lengthisx(no.get(n).zones.get(0).xdim, no.get(n).zones.get(0).ydim);  
      if ((childx&&!lengthisx)||(!childx&&lengthisx)) {
        float newper = roundit(PApplet.parseFloat(no.get(n).ideals[3])/no.get(n).father.zones.get(0).xdim, 2);
        no.get(n).subparam[1] = newper + "";
        no.get(n).brother.subparam[1] = (1-newper)+"";
      }
    }
  }
  public void displaytree() {
    for (int n=0; n<ng.length; n++) ng[n].display();
    for (int n=0; n<no.size(); n++) no.get(n).displaynodetree();
  }
  public void displayhouse() {
    for (int n=0; n<no.size(); n++) no.get(n).displayrooms();
  }
  public void strechzones() {
    float scfactor = 1;
    float totidealarea = 0;
    float tothousearea = 0;
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) totidealarea +=PApplet.parseFloat(no.get(n).ideals[2]);
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) tothousearea += no.get(n).zones.get(z).area;
    if (totidealarea != 0&&tothousearea != 0) scfactor = totidealarea / tothousearea;
    scaleno(no, scfactor);
    gridno(no);
  }
  public void press() {
    for (int i=0; i<ng.length; i++) ng[i].press();
  }

  public void type() {
    if (key=='q') for (Nodegene n : ng) n.scroll(true);
    if (key=='w') for (Nodegene n : ng)  n.scroll(false);
    if (key=='a') for (Nodegene n : ng)  n.activateit(true);
    if (key=='q'||key=='w') setuptr();
    if (key=='q'||key=='w') setupid();
    //float [] ranval = genranvals(ho.nofnodegenes, 0, 1);
    //if (key=='m') moverandom(ranval);
    //if (key=='q'||key=='w'||key=='a') calcrooms();
  }
}


public String [] roomcodedeDATAIN(String[][] roomDATA){
  String stout [] = new String [roomDATA.length];
  for (int i=0; i<stout.length;i++) stout[i] = roomDATA[i][0];
  return stout;
}


public String roomideals (String rcode, int idealnum, String[][] roomDATA) {
  String stout = "0";
  boolean rfound = false; 
  for (int i=0; i<roomDATA.length; i++) if (txequal(rcode, roomDATA[i][0])) {
    stout = roomDATA[i][idealnum]; 
    rfound = true;
  }
  if (!rfound) println("room not found");
  return stout;
}
public String [] roomidealsall (String rcode, String[][] roomDATA) {
  String stout [] = new String [roomDATA[0].length];
  boolean rfound = false; 
  for (int i=0; i<roomDATA.length; i++) if (txequal(rcode, roomDATA[i][0])) {
    stout = roomDATA[i]; 
    rfound = true;
  }
  if (!rfound) println("room not found");
  return stout;
}
public String [][] getroomDATA(String [] rooms, String [][] roomDATAin) { 
  String [][] roomDATAout = new String [rooms.length][];
  for (int i=0; i<rooms.length; i++) roomDATAout [i] = roomidealsall(rooms[i], roomDATAin); 
  return roomDATAout;
}

public int [] getroomLOCKS(String [] rooms, int [] bin) { 
  int [] iout = new int [1+min0(rooms.length-2)+min0(rooms.length-1)];  
  for (int i=0; i<bin.length; i++) if (i<rooms.length) iout [i] = bin [i];
  return iout;
}
class Node {
  String code, loc;
  int nodei, leafi, inneri;
  PVector pos, size;
  boolean isleaf, ischilda;
  String ideals[], reals [], subparam [];
  ArrayList <Zone>  zones;
  Node father, childa, childb, brother;
  Node(int _nodei, String _loc, boolean _isleaf) {
    nodei=_nodei;
    loc = _loc;
    isleaf = _isleaf;
    size = new PVector (15*scand, 15*scand);
    ideals = new String [roomDATA[0].length];
    reals = new String [roomDATA[0].length];
    subparam = new String [2]; // 0:X or Y 1: Percentage subdivition
  }
  public void calcnodepos( PVector _treepos, PVector _treesize) {
    pos = locpos(loc, _treepos, _treesize);
  }
  public void displaynodetree() {
    pushStyle();
    //textSize(8);
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    stroke(200);
    noFill();
    rect(pos.x, pos.y, size.x, size.y, size.y/4.0f);
    fill(0);
    text(loc, pos.x, pos.y-10);
    if (code!=null) text(code, pos.x, pos.y);
    if (father!=null) line(pos.x, pos.y-size.y/2, father.pos.x, father.pos.y+size.y/2);
    if (ideals!=null) for (int i=0; i<ideals.length; i++) if (ideals[i]!=null)  text(ideals[i], pos.x+30*i-40, pos.y+10);
    if (reals!=null) for (int i=0; i<reals.length; i++) if (reals[i]!=null)  text(reals[i], pos.x+30*i-40, pos.y+20);
    if (subparam!=null) for (int i=0; i<subparam.length; i++) if (subparam[i]!=null)  text(subparam[i], pos.x+30*i, pos.y+30);
    popStyle();
  }
  public void displayrooms() {
    //if (isleaf) for (int z=0; z<zones.size(); z++)  zones.get(z).displaycolor();
    if (isleaf) if (zones!=null) if (zones.size()>0) zones.get(0).displaylines(zones);
  }
}
public ArrayList <Node> nodecrea(String []rooms, float [] locgene) {
  ArrayList <Node> nout = new ArrayList <Node> ();
  int nodei=0;
  if (rooms.length==1) nout.add(new Node(nodei, "0", true));
  else {
    for (int i=0; i<locgene.length+3; i++) {
      if (i==0) nout.add(new Node(nodei, "0", false));
      else if (i==1) nout.add(new Node(nodei, "00", true));
      else if (i==2) nout.add(new Node(nodei, "01", true));
      if (i==0||i==1||i==2) nodei++;
      else {
        ArrayList <Node> leafs = new ArrayList <Node> ();
        for (int j=0; j<nout.size(); j++) if (nout.get(j).isleaf) leafs.add(nout.get(j));
        int leafsel = leafs.get(leafs.size()-1).nodei;
        if (locgene[i-3]<1) leafsel = leafs.get(PApplet.parseInt(map(locgene[i-3], 0, 1, 0, leafs.size()))).nodei;
        nout.get(leafsel).isleaf = false;
        nout.add(new Node(nodei, nout.get(leafsel).loc+"0", true));
        nout.add(new Node(nodei+1, nout.get(leafsel).loc+"1", true));
        nodei+=2;
      }
    }
    int leafcount=0;
    for (int i=0; i<nout.size(); i++) if (nout.get(i).isleaf) {
      nout.get(i).leafi=leafcount;
      leafcount++;
    }
    int innercount=0;
    for (int i=0; i<nout.size(); i++) if (!nout.get(i).isleaf) {
      nout.get(i).inneri=innercount;
      innercount++;
    }
    for (int i=0; i<nout.size(); i++) if (!nout.get(i).isleaf) nout.get(i).leafi=-1;
    for (int i=0; i<nout.size(); i++) if (nout.get(i).isleaf) nout.get(i).inneri=-1;
  }
  return nout;
}


class Nodegene {
  String type,loc;
  float value, step, min, max;
  PVector  pos;
  boolean select, inactive;   
  PVector size = new PVector (15*scand, 15*scand);
  Nodegene(String _type, float _value, boolean _inactive, PVector _pos) {
    type = _type;
    value=roundit(_value, 2);
    inactive=_inactive;
    step=.01f;
    //if (txequal(type,"p")) step=.001;
    min=0;
    max=1;
    pos=_pos;
  }
  public Nodegene cloneit() {
    Nodegene nout = new Nodegene (type, value, inactive, clonevector(pos));
    return nout;
  }
  public Nodegene cloneactgene(float genevalue) {
    Nodegene nout;
    if (inactive) nout = new Nodegene (type, value, inactive, clonevector(pos));
    else nout = new Nodegene (type, genevalue, inactive, clonevector(pos));
    return nout;
  }
  public void display() {
    pushStyle();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    fill(255);
    stroke(200);
    if (select)   fill(200);
    if (inactive&&select) fill (255, 0, 0, 100);
    if (inactive&&!select) fill (255, 0, 0, 50);
    if (!inactive&&select) fill (0, 255, 0, 100);
    if (!inactive&&!select) fill (0, 255, 0, 50);
    rect(pos.x, pos.y, size.x, size.y, size.y*.25f);
    fill(100);
    //if (txequal(type,"p")) text(nf(value, 0,3), pos.x, pos.y);
    //else text(nf(value, 0,2), pos.x, pos.y);
    text(nf(value, 0, 2), pos.x, pos.y);
    text(type, pos.x-15, pos.y);
     if (loc!=null) text(loc, pos.x+30, pos.y);
    popStyle();
  }
  public boolean isover() {
    if (mouseX>pos.x-(size.x/2.0f)&&mouseX<pos.x+(size.x/2.0f)&&mouseY>pos.y-(size.y/2.0f)&&mouseY<pos.y+(size.y/2.0f)) return true;
    else return false;
  }
  public void press() {
    if (isover()) select =!select;
  }
  public void scroll(boolean updown) {
    if (select&&!updown&&value<max) value = roundit(value + step, 4);
    if (select&&updown&&value>min)  value = roundit(value - step, 4);
    if (value<min) value=roundit(min, 2);
    if (value>max) value=roundit(max, 2);
  }
  public void changeval(float newval) {
    if (!inactive) value = newval;
  }
  public void activateit(boolean act) {
    if (act&&select) inactive = !inactive;
  }
}
public float [] ngvalues (Nodegene [] ng, int iniv, int endv) {
  float fout [] = new float [endv-iniv];
  for (int i=0; i<endv-iniv; i++) fout [i] = ng [i+iniv].value; 
  return fout;
}
public float  ngvalue (Nodegene [] ng, int iniv) {
  float fout  = ng [iniv].value;
  return fout;
}
class Zone {
  int zonei;
  PVector p00, p11, pmid;
  float area, prop, xdim, ydim, zwidth, zlength;
  String loc, code;
  Zone (PVector _p00, PVector _p11) {
    p00 = _p00;
    p11 = _p11;
    pmid = new PVector ((p00.x+p11.x)*.5f, (p00.y+p11.y)*.5f);
    area = abs(p11.x-p00.x)*abs(p11.y-p00.y);
    prop = propDEp00p11(p00, p11);
    xdim = abs(p11.x-p00.x);
    ydim = abs(p11.y-p00.y);
    zwidth=wlDEp00p11(xdim, ydim, "width");
    zlength=wlDEp00p11(xdim, ydim, "length");
  }
  public Zone cloneit() {
    Zone zout = new Zone (p00.copy(), p11.copy());
    zout.loc = loc;
    zout.code = code;
    return zout;
  }
  public void displaycolor() {
    pushStyle();
    rectMode(CORNERS);
    textAlign(CENTER, CENTER);
    colorDEcode(code, 50, roomDATA);
    rect(scgr(p00).x, scgr(p00).y, scgr(p11).x, scgr(p11).y);
    fill(255);
    stroke(150);
    if (zonei==0) ellipse( scgr(pmid).x, scgr(pmid).y, 18*scand, 18*scand);
    fill(0);
    text(zonei, scgr(pmid).x, scgr(pmid).y+10);
    if (zonei==0) if (code!=null) if (code.length()>2)  text(code.substring(0, 2), scgr(pmid).x, scgr(pmid).y);
    if (zonei==0) if (code!=null) if (code.length()<=2) text(code, scgr(pmid).x, scgr(pmid).y);
    popStyle();
  }
  public void displaylines(ArrayList <Zone> zones) {
    pushStyle();
    rectMode(CORNERS);
    textAlign(CENTER, CENTER);
    stroke(150);
    drawperimeterlines(zones);
    fill(255);
    stroke(150);
    if (zonei==0) ellipse( scgr(pmid).x, scgr(pmid).y, 18*scand, 18*scand);
    fill(0);
    if (zonei==0) if (code!=null) if (code.length()>2)  text(code.substring(0, 2), scgr(pmid).x, scgr(pmid).y);
    if (zonei==0) if (code!=null) if (code.length()<=2) text(code, scgr(pmid).x, scgr(pmid).y);
    popStyle();
  }
}
public ArrayList <Zone> calczones(Node n, ArrayList <Zone> homedge) {
  ArrayList <Zone> zo = new ArrayList <Zone> ();
  if (n.father==null) zo=homedge; //este deberia ser la zona 
  else {
    Node father = n.father;
    ArrayList <Zone> fzones = father.zones;
    boolean child1 = n.ischilda;
    boolean childx = ischildx(PApplet.parseFloat(n.father.subparam[0]));
    float subper = PApplet.parseFloat(n.subparam[1]);
    float brosubper = PApplet.parseFloat(n.brother.subparam[1]);
    float p00min = pminmax(0, fzones, childx);   //if child x get minX
    float p11max = pminmax(1, fzones, childx); 
    //float pline0 = rg(map (n.subper, 0, 1, p00min, p11max));      //rg
    //float pline1 = rg(map (n.subper, 0, 1, p00min, p11max));      //rg
    float pline0, pline1;
    if (child1) pline0 = map (subper, 0, 1, p00min, p11max);      //rg
    else pline0 = map (brosubper, 0, 1, p00min, p11max);
    if (child1)  pline1 = map (subper, 0, 1, p00min, p11max);      //rg
    else pline1 = map (brosubper, 0, 1, p00min, p11max);
    for (Zone f : fzones) if (zonewithinline(f, pline0, pline1, child1, childx)) zo.add(breakfzones(f, pline0, pline1, child1, childx));
  }
  if (zo.size()>0) zo = sortzonesbyarea(zo);
  for (int i=0; i<zo.size(); i++) zo.get(i).zonei = i;

  for (int i=0; i<zo.size(); i++) zo.get(i).loc = n.loc;
  for (int i=0; i<zo.size(); i++) zo.get(i).code = n.code;
  return zo;
}
public ArrayList <Node> calcallzones(ArrayList <Node> no, ArrayList <Zone> homedges) {
  for (int n=0; n<no.size(); n++) no.get(n).zones=calczones(no.get(n), homedges);
  return no;
}

public ArrayList <Zone> prophomedges(ArrayList <Zone> homedge, float scaleprop) {
  ArrayList <Zone> newhomedge = new ArrayList <Zone> ();
  for (int i=0; i<homedge.size(); i++) newhomedge.add(new Zone(new PVector (homedge.get(i).p00.x*scaleprop, homedge.get(i).p00.y), new PVector (homedge.get(i).p11.x*scaleprop, homedge.get(i).p11.y)));
  return newhomedge;
}
PVector grpos, grsize, usmouse, grmouse;
float grscale, grunit;

public void setupgr() {
  grpos = new PVector((100)*scand,height*.5f);
  grsize= new PVector((width)-(120*scand), (height*.5f)-(20*scand));
  grscale =50*scand;
  grunit =.5f;
}
public void drawgr() {
  rectMode(CORNER);
  strokeWeight(1);
  stroke(230);
  noFill();
  rect(grpos.x, grpos.y, grsize.x, grsize.y);
  float us = grunit*grscale;
  for (int x=0; x<=PApplet.parseInt(grsize.x/us); x++) for (int y=0; y<=PApplet.parseInt(grsize.y/us); y++) {
    noFill();
    if (x<PApplet.parseInt(grsize.x/us)&&y<PApplet.parseInt(grsize.y/us)) rect((x*us)+grpos.x, (y*us)+grpos.y, us, us);
    if ((x==PApplet.parseInt(grsize.x/us))&&(y<PApplet.parseInt(grsize.y/us))) rect((x*us)+grpos.x, (y*us)+grpos.y, grsize.x-(x*us), us);
    if ((y==PApplet.parseInt(grsize.y/us))&&(x<PApplet.parseInt(grsize.x/us))) rect((x*us)+grpos.x, (y*us)+grpos.y, us, grsize.y-(y*us));
  }
}
public PVector scgr(PVector pos) {
  return  new PVector ((pos.x*grscale)+grpos.x, (pos.y*grscale)+grpos.y);
}
public float scgrfx(float pos) {
  return (pos*grscale)+grpos.x;
}
public float scgrfy(float pos) {
  return (pos*grscale)+grpos.y;
}
public float scsif(float pos) {
 return   pos*grscale;
}
public float rg(float fin) {
  float fout = fin + grunit*.5f;
  fout = roundit(fout-(fout%grunit), 2);
  return fout;
}
//                                                                              INT
//                                                                                     factorials
public int factorial(int num) {
  if (num>12) println("numero factorial muy grande");
  return fact(num);
}
public int fact(int num) {
  if (num <= 1) return 1;
  else return num*fact(num - 1);
}                                   
public int min0(int num) {
  if (num>=0) return num;
  else return 0;
}

//                                                                              FLOAT
public float roundit(float numin, int dec) {                                                    //round
  float dec10 = pow(10, dec);
  float roundout = round(numin * dec10)/dec10;
  return roundout;
}
public float roundspan(float fin, float spanu) {
  float fout = fin + spanu*.5f;
  fout = roundit(fout-(fout%spanu), 2);
  return fout;
}
public float divNaN0(float a, float b) {
  if (a==0&&b==0) return 0;
  else return a/b;
} 
public float [] ranflarr(int num, float min, float max) {                                     //   random array
  float rout[] = new float [num];
  for (int i=0; i<rout.length; i++) rout [i] = random(min, max);
  return rout;
}
public float min0max1fl(int min0max1, float a, float b) {
  float fout;
  if ((min0max1==0&&a<b)||(min0max1==1&&a>b))  fout=a;
  else fout =b;
  return fout;
}
//VECTOR
public PVector clonevector(PVector vectorin) {
  return new PVector (vectorin.x, vectorin.y);
}
//                                                                              STRING
//                                                                                      equal
public boolean txequal(String a, String b) {
  if (a==null||b==null) return false;
  else {
    int al= a.length();
    int bl= b.length();
    int minl;
    boolean bout = true;
    if (al!=bl) bout = false;
    if (al<bl) minl = al;
    else minl = bl;
    for (int i=0; i<minl; i++) if (a.charAt(i)!=b.charAt(i)) bout = false; 
    return bout;
  }
}
public String [] clonestarr(String [] stin) {
  String [] stout = new String [stin.length];
  for (int i=0; i<stin.length; i++) stout[i] = stin[i];
  return stout;
}
public ArrayList <String> removeemptyst(ArrayList <String> stin) {
  ArrayList <String> stout = new ArrayList <String> ();
  for (int i=0; i<stin.size(); i++) if (!txequal(stin.get(i), "")) stout.add(stin.get(i));
  return stout;
}
public String [] removeemptystarr(String [] stin) {
  ArrayList <String> stout = new ArrayList <String> ();
  for (int i=0; i<stin.length; i++) if (!txequal(stin[i], "")) stout.add(stin[i]);
  String starrout[] = new String [stout.size()];
  for (int i=0; i<starrout.length; i++) starrout[i] = stout.get(i);
  return starrout;
} 
public String [] subtostarr(String [] stin, String strremove) {
  ArrayList <String> stout = new ArrayList <String> ();
  for (int i=0; i<stin.length; i++) if (!txequal(stin[i], strremove)) stout.add(stin[i]);
  String starrout[] = new String [stout.size()];
  for (int i=0; i<starrout.length; i++) starrout[i] = stout.get(i);
  return starrout;
}
public String [] addtostarr(String [] inarr, String newstr) {//addtostarr
  String stout [] = new String [inarr.length+1];
  for (int i=0; i< inarr.length; i++) stout[i] = inarr[i];
  stout[inarr.length] = newstr;
  return stout;
}
//                                                                                        permutations
public String[] permutation01(String [] pre, float num) {
  int numin = factorial(pre.length)-1;
  if (num<1)  numin =PApplet.parseInt(map(num, 0, 1, 0, factorial(pre.length))); 
  String newA[] = perm(pre, 0, new ArrayList <String[]> (), numin);
  return newA;
}
public String[]  perm(String[] iA, int s, ArrayList <String[]> igm, int nume) {    
  for (int i = s; i < iA.length; i++) {
    String temp = iA[s];
    iA[s] = iA[i];
    iA[i] = temp;
    perm(iA, s + 1, igm, nume);
    iA[i] = iA[s];
    iA[s] = temp;
  }
  if (s == iA.length - 1) {
    String toadd= "";
    for (int i=0; i<iA.length-1; i++) toadd = toadd + iA[i] + ",";
    toadd = toadd + iA[iA.length-1];   
    igm.add(split(toadd, ","));
  }
  String [] ig1 = null;
  if (igm.size()>nume)  ig1 = igm.get(nume);
  return ig1;
}
//                                                                                                     BOOLEAN
//                                                                                                             ischilda
public boolean ifischilda(String loc) {                                      
  boolean bout = false;
  if (loc.charAt(loc.length()-1)=='0'||PApplet.parseInt(loc.charAt(loc.length()-1))==PApplet.parseInt("0 ")) bout = true;
  return bout;
}
public boolean ischild1(boolean a, float g0) {                                                                      //ischild1 
  boolean bout; 
  if ((a&&(g0<.25f||(g0>=.5f&&g0<.75f)))||(!a&&((g0>=.25f&&g0<.5f)||g0>=.75f))) bout = true;
  else bout = false;
  return bout;
}
public boolean ischildx(float g0) {                                                                                 // childx
  boolean bout; 
  if (g0<.5f) bout=true;
  else bout = false;
  return bout;
}
public boolean zonewithinline(Zone fzone, float pline0, float pline1, boolean child1, boolean childx) {            //zonewithinline
  if       (child1&&childx &&fzone.p00.x<pline0) return true;
  else if  (child1&&!childx&&fzone.p00.y<pline0) return true;
  else if  (!child1&&childx&&fzone.p11.x>pline1) return true;
  else if (!child1&&!childx&&fzone.p11.y>pline1) return true;
  else return false;
}
//                                                                                                       FLOATS
public float pminmax(int min0max1, ArrayList <Zone> fzones, boolean childx) {                                      //min max from zones
  float fout;
  if (fzones.size()==0) {
    fout = 0;
  } else if (min0max1==0) {
    if (childx) {
      fout = fzones.get(0).p00.x;
      for (Zone f : fzones) if (f.p00.x<fout) fout = f.p00.x;
    } else {
      fout = fzones.get(0).p00.y;
      for (Zone f : fzones) if (f.p00.y<fout) fout = f.p00.y;
    }
  } else {
    if (childx) {
      fout = fzones.get(0).p11.x;
      for (Zone f : fzones) if (f.p11.x>fout) fout = f.p11.x;
    } else {
      fout = fzones.get(0).p11.y;
      for (Zone f : fzones) if (f.p11.y>fout) fout = f.p11.y;
    }
  }
  return fout;
}
public float propDEp00p11(PVector p00, PVector p11) {
  float fout=0; 
  if ((p11.x-p00.x)<(p11.y-p00.y))fout = ((p11.x-p00.x)/(p11.y-p00.y));
  else fout = ((p11.y-p00.y)/(p11.x-p00.x));
  return fout;
}
public float wlDEp00p11(float xdim, float ydim, String widthlength) {          //si son iguales x es length y = width
  float fout=xdim; 
  if ((txequal(widthlength, "width")&&lengthisx(xdim,ydim))||((txequal(widthlength, "length"))&&!lengthisx(xdim,ydim)))  fout = ydim;
  return fout;
}
public boolean lengthisx(float xdim, float ydim) {
  boolean bout = xdim>=ydim;
  return bout;
}
//                                                                                                      PVECTOR
//                                                                                                             treepos
public PVector locpos(String loc, PVector treepos, PVector treesize) {
  PVector pv;
  float pvx = treepos.x;
  for (int i=1; i<loc.length(); i++) {
    if (loc.charAt(i)=='0'||PApplet.parseInt(loc.charAt(i))==PApplet.parseInt("0 ")) {
      pvx = pvx - treesize.x/pow(2, i);
    }
  }
  for (int i=1; i<loc.length(); i++) {
    if (loc.charAt(i)=='1'||PApplet.parseInt(loc.charAt(i))==PApplet.parseInt("1 ")) {
      pvx = pvx + treesize.x/pow(2, i);
    }
  }
  float pvy = (((loc.length())-1) * treesize.y) + treepos.y; 
  pv = new PVector (pvx, pvy);
  return pv;
}

public void gridno(ArrayList <Node> no) {
  for (int n=0; n<no.size(); n++) for (int j=0; j<no.get(n).zones.size(); j++) no.get(n).zones.set(j, gridzone(no.get(n).zones.get(j)));
}
public Zone gridzone(Zone zo) {                                                                                      //gridzone
  Zone newzo = new Zone(new PVector(rg(zo.p00.x), rg(zo.p00.y)), new PVector(rg(zo.p11.x), rg(zo.p11.y)));
  newzo.zonei = zo.zonei;
  newzo.loc = zo.loc;
  newzo.code = zo.code;
  return newzo;
}
public int getngnum(String txtoget,int nrooms){
  //min0(nrooms-2)
  int  iout = 0;
  if (txequal(txtoget,"lmin"))iout = 0;
  else if (txequal(txtoget,"lmax")||txequal(txtoget,"pmin"))iout = min0(nrooms-2);
  else if (txequal(txtoget,"pmax")||txequal(txtoget,"smin"))iout = min0(nrooms-2)+1;
  else if (txequal(txtoget,"smax"))iout = min0(nrooms-2)+1+min0(nrooms-1); 
  return iout;
}

public Zone breakfzones(Zone fzone, float pline0, float pline1, boolean child1, boolean childx) {                                                     //ZONE
  if       (child1&&childx ) return new Zone (clonevector(fzone.p00), new PVector (min0max1fl(0, pline0, fzone.p11.x), fzone.p11.y));
  else if  (child1&&!childx) return new Zone (clonevector(fzone.p00), new PVector (fzone.p11.x, min0max1fl(0, pline0, fzone.p11.y)));
  else if  (!child1&&childx) return new Zone (new PVector(min0max1fl(1, pline1, fzone.p00.x), fzone.p00.y), clonevector(fzone.p11));
  else if (!child1&&!childx) return new Zone (new PVector(fzone.p00.x, min0max1fl(1, pline1, fzone.p00.y)), clonevector(fzone.p11)); //fzone.type
  else return null;
}
public ArrayList <Zone> sortzonesbyarea(ArrayList <Zone> inarr) {
  Zone tmp = inarr.get(0).cloneit();
  for (int i = 0; i < inarr.size(); i++) for (int j = i + 1; j < inarr.size(); j++) if (inarr.get(i).area < inarr.get(j).area) {
    tmp = inarr.get(i);
    inarr.set(i, inarr.get(j));
    inarr.set(j, tmp);
  }
  return inarr;
}
public ArrayList <Zone> clonezonelist(ArrayList <Zone> zlistin) {
  ArrayList <Zone> zlistout = new ArrayList <Zone> ();
  for (int i=0; i<zlistin.size(); i++) zlistout.add(zlistin.get(i).cloneit());
  return zlistout;
}
//                                                                                                                                                                      NODE
//                                                                                                                                                  relationships
public Node calcrelative(Node n, ArrayList <Node> other, String relat) {//si es forloop normal? probar pareceque no no se necesita
  Node relative = null;
  if (txequal(relat, "father")) for (Node o : other) {
    if (txequal(n.loc.substring(0, n.loc.length()-1), o.loc)) relative = o;
  } else if (txequal(relat, "childa")) for (Node o : other) {
    if (txequal(n.loc + "0", o.loc)) relative = o;
  } else if (txequal(relat, "childb")) for (Node o : other) {
    if (txequal(n.loc + "1", o.loc)) relative = o;
  } else if (txequal(relat, "brother"))for (Node o : other) if (o.nodei!=n.nodei) {
    if (txequal(n.loc.substring(0, n.loc.length()-1), o.loc.substring(0, o.loc.length()-1)))  relative = o;
  }
  return relative;
}

public ArrayList <Node> calctheadj(int noi, Node no, ArrayList <Node> ono) {                                                                                           //calcadj
  ArrayList <Node> nout = new ArrayList <Node> ();
  for (int i=0; i<no.zones.size(); i++) for (int j=0; j<ono.size(); j++) if (j!=noi) if (ono.get(j).isleaf) for (int l=0; l<ono.get(j).zones.size(); l++) {
    if (isadj(no.zones.get(i), ono.get(j).zones.get(l))) {
      boolean isalreadyinlist = false;
      for (int m=0; m<nout.size(); m++) if (txequal(nout.get(m).loc, ono.get(j).loc)) isalreadyinlist = true;
      if (!isalreadyinlist) nout.add(ono.get(j));
    }
  }
  return nout;
}
public ArrayList <Node> addfacadeadj(Node no, ArrayList <Node> alladj, ArrayList <Node> faca) {                                                                         //facadeadj
  //for (int i=0; i<faca.size(); i++) alladj.add(faca.get(i)); 
  for (int i=0; i<no.zones.size(); i++)  for (int j=0; j<faca.size(); j++)  for (int l=0; l<faca.get(j).zones.size(); l++) {
    if (isadj(no.zones.get(i), faca.get(j).zones.get(l))) {
      boolean isalreadyinlist = false;
      for (int m=0; m<alladj.size(); m++) if (txequal(alladj.get(m).loc, faca.get(j).loc)) isalreadyinlist = true;
      if (!isalreadyinlist) alladj.add(faca.get(j));
    }
  }
  return alladj;
}
public boolean isadj(Zone a, Zone b) {                                                                                                                              //adjs
  boolean bout = false;
  if (a.p00.x==b.p11.x&&within(a.p00, a.p11, b.p00, b.p11, 1)) bout = true;
  if (a.p11.x==b.p00.x&&within(a.p00, a.p11, b.p00, b.p11, 1)) bout = true;
  if (a.p00.y==b.p11.y&&within(a.p00, a.p11, b.p00, b.p11, 0)) bout = true;
  if (a.p11.y==b.p00.y&&within(a.p00, a.p11, b.p00, b.p11, 0)) bout = true;
  return bout;
}
public boolean within(PVector a00, PVector a11, PVector b00, PVector b11, int x0y1) {                                                                             //within
  boolean bout = false;
  float a0, a1, b0, b1;
  if (x0y1==0) {
    a0=a00.x;
    a1=a11.x;
    b0=b00.x;
    b1=b11.x;
  } else {
    a0=a00.y;
    a1=a11.y;
    b0=b00.y;
    b1=b11.y;
  }
  if (a0<b0&&a1>b0)bout = true;
  if (a0<b1&&a1>b1)bout = true;
  if (b0<a0&&b1>a0)bout = true;
  if (b0<a1&&b1>a1)bout = true;
  if (a0==b0) bout = true;
  if (a1==b1) bout = true;
  return bout;
}



//float calcbestprop(ArrayList <Node> no, ArrayList <Zone> homedges, float min, float max, float span) {
//  float bestn=0;
//  float bestotpropfit=99999;
//  for (float i=min; i<max; i+=span) {
//    ArrayList <Zone> prhomedges = prophomedges(homedges, i);
//    ArrayList <Node> tempno = calcallzones(no, prhomedges);
//    float newpropfit = calctotpropfit(tempno, prpsl); 
//    if (newpropfit<bestotpropfit) {
//      bestotpropfit = newpropfit; 
//      bestn = i;
//    }
//  }
//  ArrayList <Zone> prhomedges = prophomedges(homedges, roundit(bestn, 2));
//  ArrayList <Node> tempno = calcallzones(no, prhomedges);
//  return roundit(bestn, 2);
//}

public Nodegene [] clonengarrwithgenes(Nodegene [] ngin, float [] genes){
  Nodegene []  nout = new Nodegene [ngin.length];
  for (int i=0; i<ngin.length; i++) nout[i] = ngin[i].cloneactgene(genes[i]);
  return nout;
}

public ArrayList <Node> scaleno(ArrayList <Node> no, float scalefact) {
  //ArrayList <Node> sdc = new ArrayList <Node> (); 
  for (int n=0; n<no.size(); n++) for (int j=0; j<no.get(n).zones.size(); j++) no.get(n).zones.set(j, scalezone(no.get(n).zones.get(j), scalefact));
  return no;
}

public Zone scalezone(Zone zo, float scalef ) {
  Zone newzo = new Zone(zo.p00.copy().mult(sqrt(scalef)), zo.p11.copy().mult(sqrt(scalef)));
  newzo.zonei = zo.zonei;
  newzo.loc = zo.loc;
  newzo.code = zo.code;
  return newzo;
}
public void colorDEloc (String loc, float transp) {                                                                       //                          SHAPE
  float colprim = 255/2;
  if (loc!=null) {
    for (int i=1; i<loc.length(); i++) {
      if (txequal(loc.substring(i, i+1), "0")) colprim -= 255/(pow(2, i+1));
      if (txequal(loc.substring(i, i+1), "1")) colprim += 255/(pow(2, i+1));
    }
  }
  noStroke();
  colorMode(HSB);
  fill(colprim, 255, 255, transp);
  colorMode(RGB);
}

public void colorDEcode (String code, float transp, String [][] roomDATA) {                                                       
  float colprim = 255/2;
  if (code!=null) for (int i=0; i<roomDATA.length; i++) if (txequal(code, roomDATA[i][0])) colprim = map (i, 0, roomDATA.length, 0, 255);
  noStroke();
  colorMode(HSB);
  fill(colprim, 255, 255, transp);
  colorMode(RGB);
}

public void drawperimeterlines(ArrayList <Zone> zones) {
  for (Zone z1 : zones) {
    FloatList linevals = new FloatList (z1.p00.x, z1.p11.x, z1.p00.y, z1.p11.y);
    FloatList pointsvals [] = new FloatList [4];
    pointsvals [0] = new FloatList  (z1.p00.y, z1.p11.y);
    pointsvals [1] = new FloatList  (z1.p00.y, z1.p11.y);
    pointsvals [2] = new FloatList  (z1.p00.x, z1.p11.x);
    pointsvals [3] = new FloatList  (z1.p00.x, z1.p11.x);
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(0)==z2.p11.x))  pointsvals[0].append(z2.p00.y);  
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(0)==z2.p11.x))  pointsvals[0].append(z2.p11.y); 
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(1)==z2.p00.x))  pointsvals[1].append(z2.p00.y);  
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(1)==z2.p00.x))  pointsvals[1].append(z2.p11.y); 
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(2)==z2.p11.y))  pointsvals[2].append(z2.p00.x);  
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(2)==z2.p11.y))  pointsvals[2].append(z2.p11.x); 
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(3)==z2.p00.y))  pointsvals[3].append(z2.p00.x);  
    for (Zone z2 : zones) if (z1.zonei!=z2.zonei) if ((linevals.get(3)==z2.p00.y))  pointsvals[3].append(z2.p11.x); 
    for (int s=0; s<4; s++) pointsvals[s].sort();
    for (int s=0; s<2; s++) for (int i=0; i<pointsvals[s].size(); i++) if (i%2==0) line(scgrfx(linevals.get(s)), scgrfy(pointsvals[s].get(i)), scgrfx(linevals.get(s)), scgrfy(pointsvals[s].get(i+1)));
    for (int s=2; s<4; s++) for (int i=0; i<pointsvals[s].size(); i++) if (i%2==0)  line( scgrfx(pointsvals[s].get(i)), scgrfy(linevals.get(s)), scgrfx(pointsvals[s].get(i+1)), scgrfy(linevals.get(s)));
  }
}
class Click {
  PVector pos, size, mid, end;
  String name;
  boolean state, displaystate;
  int type = 0;
  int icon = 0;
  float textsize = 12;
  float scand = 1;
  int con = 200;
  int coff = 100;
  Click(PVector _pos, PVector _size, String _name, int _type) {
    pos=_pos;
    size=_size;
    calcpos();
    name = _name;
    type = _type;
  }
  public void calcpos() {
    mid = new PVector(pos.x+size.x/2, pos.y+size.y/2);
    end = new PVector(pos.x+size.x, pos.y+size.y);
  }
  public void scaletoandroid(float _scand) {
    scand = _scand;
    pos  = new PVector (scand*pos.x, scand*pos.y);
    size  = new PVector (scand*size.x, scand*size.y);
    mid  = new PVector (scand*mid.x, scand*mid.y);
    end  = new PVector (scand*end.x, scand*end.y);
    textsize = textsize * scand;
  }
  public void display() {
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
      if (type==10) text(name, end.x+(size.x*.3f), mid.y);
      if (type==11) textAlign(CENTER, CENTER);
      if (type==11) text(name, mid.x, end.y+(textsize*.8f));
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
      if (type==30)text(name, mid.x, end.y+size.y*.15f);
      if (type==31) textAlign(LEFT, CENTER);
      if (type==31) if (isover())text(name, end.x+size.x*.2f, mid.y);
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

  public boolean isover() {
    return  (mouseX > pos.x && mouseX < end.x  &&mouseY >pos.y && mouseY < end.y);
  }
  public boolean isoverandpressed() {
    return  (isover()&&mousePressed == true);
  }
  public void presson() {
    if (isover()) state = true;
    if (isover()) displaystate = true;
  }
  public void pressoff() {
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
  int con = 200;
  int coff = 100;
  Toggle(PVector _pos, PVector _size, String _name, int _type) {
    pos=_pos;
    size=_size;
    calcpos();
    name = _name;
    type = _type;
    poshide = pos;
    posshow = pos;
  }
  public void calcpos() {
    mid = new PVector(pos.x+size.x/2, pos.y+size.y/2);
    end = new PVector(pos.x+size.x, pos.y+size.y);
  }
  public void calcposhide(PVector _posshow) {
    poshide = pos;
    posshow = _posshow;
  }
  public void scaletoandroid(float _scand) {
    scand = _scand;
    pos  = new PVector (scand*pos.x, scand*pos.y);
    size  = new PVector (scand*size.x, scand*size.y);
    mid  = new PVector (scand*mid.x, scand*mid.y);
    end  = new PVector (scand*end.x, scand*end.y);
    poshide  = new PVector (scand*poshide.x, scand*poshide.y);
    posshow  = new PVector (scand*posshow.x, scand*posshow.y);
    textsize = textsize * scand;
  }
  public void display() {
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
        ellipse(pos.x+(size.y*.5f), mid.y, size.y*1.05f, size.y*1.05f);
      } else {
        noStroke();
        fill(con);
        rect(pos.x, pos.y, size.x, size.y, size.y); 
        fill(255);
        stroke(coff);
        ellipse(end.x-(size.y*.5f), pos.y+(size.y*.5f), size.y*1.05f, size.y*1.05f);
      }      
      fill(coff);
      if (type==11)  textAlign(CENTER, CENTER);
      if (type==11)  text(name, mid.x, end.y+textsize*.8f);
      if (type==12)  textAlign (LEFT, CENTER);
      if (type==12)  text(name, end.x+textsize*.8f, mid.y );
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
      if (type==20) text(name, mid.x, end.y+textsize*.8f);
      if (type==21) textAlign(LEFT, CENTER);
      if (type==21) text(name, end.x+textsize*.8f, mid.y);
    }
    if (type==22) {
      stroke(coff);
      noFill();
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      if (state) fill(con);
      if (state) noStroke();
      if (state) ellipse(pos.x+(size.y*.5f), pos.y+(size.y*.5f), size.x*1.05f, size.y*1.05f);
      fill(coff);
      if (state) fill(coff);
      if (state) noStroke();
      PVector a = new PVector (pos.x+(size.x*.5f), pos.y+(size.y*.5f));
      drawicon(icon, a, size);
      textAlign(CENTER, CENTER);
      if (state) fill(con);
      else fill(coff);
      text(name, pos.x+(size.x*.5f), end.y+textsize*.8f);
    }
    if (type==30||type==31) {                       //show hide bar horizontal
      stroke(coff);
      fill(255);
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      if (!state) {
        rect(poshide.x, poshide.y, size.x, size.y);
        if (type==30)line(pos.x+size.x*.5f-7*scand, pos.y+size.y*.5f, pos.x+size.x*.5f, pos.y+size.y*.5f+7*scand);
        if (type==30) line(pos.x+size.x*.5f+7*scand, pos.y+size.y*.5f, pos.x+size.x*.5f, pos.y+size.y*.5f+7*scand);
        if (type==31)       line(pos.x+(size.x*.4f), pos.y+size.y*.5f-(7*scand), pos.x+(size.x*.7f), pos.y+size.y*.5f);
        if (type==31) line(pos.x+(size.x*.4f), pos.y+size.y*.5f+(7*scand), pos.x+(size.x*.7f), pos.y+size.y*.5f);
      }
      if (state) {
        rect(poshide.x, poshide.y, posshow.x-poshide.x+size.x, posshow.y-poshide.y+size.y);
        if (type==30) line(pos.x+size.x*.5f-7*scand, pos.y+size.y*.5f+7*scand, pos.x+size.x*.5f, pos.y+size.y*.5f);
        if (type==30) line(pos.x+size.x*.5f+7*scand, pos.y+size.y*.5f+7*scand, pos.x+size.x*.5f, pos.y+size.y*.5f);
        if (type==31) line(pos.x+(size.x*.7f), pos.y+size.y*.5f-(7*scand), pos.x+(size.x*.4f), pos.y+size.y*.5f);
        if (type==31) line(pos.x+(size.x*.7f), pos.y+size.y*.5f+(7*scand), pos.x+(size.x*.4f), pos.y+size.y*.5f);
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
      text(name, pos.x+(size.x*.5f), pos.y+(size.y*.5f));
    }
    if (type==50) { //candado
      noStroke();      
      fill(con);
      if (state) fill(coff);
      PVector a = new PVector (pos.x+(size.x*.5f), pos.y+(size.y*.5f));
      if (state) drawicon(17, a, size);
      else drawicon(16, a, size);   
    }
    popStyle();
  }
  public void turnon() {
    state = true;
    if (type==30||type==31) {
      pos  = new PVector (posshow.x, posshow.y);
      calcpos();
    }
  }
  public void turnoff() {
    state = false;
    if (type==30||type==31) {
      pos  = new PVector (poshide.x, poshide.y);
      calcpos();
    }
  }
  public void press() {
    if (type!=30&&type!=31) if (isover()) state = !state;
    if (type==30||type==31) if (isover()) if (!state) turnon();
    if (type==30||type==31) if (isover()) if (state) turnoff();
  }
  public boolean isover() {
    if (mouseX>pos.x&&mouseX<end.x&&mouseY>pos.y&&mouseY<end.y) return true;
    else return false;
  }
}
class Option {
  PVector pos, size, mid, end, ipos[], imid[], iend[];
  String[] names;
  boolean state, displaystate;
  int type = 0;
  int namei = 0;
  int icon = 0;
  float textsize = 12;
  float scand = 1;
  int con = 100;
  int coff = 200;
  Option(PVector _pos, PVector _size, String _names[], int _type) {
    pos = _pos;
    size=_size;
    names = _names;
    type = _type;
    calcpos();
    if (type==11) namei=-1;
  }
  public void calcpos() {
    mid = new PVector (pos.x + size.x/2, pos.y + size.y/2);
    end = new PVector (pos.x + size.x, pos.y + size.y   );
    calcipos(type);
  }
  public void scaletoandroid(float _scand) {
    scand = _scand;
    pos = new PVector (pos.x*scand, pos.y*scand);
    size = new PVector (size.x*scand, size.y*scand);
    textsize = textsize * scand;
    calcpos();
  }

  public void calcipos(int type) {
    if (type==10) {
      ipos = new PVector [names.length];
      imid = new PVector [names.length];
      iend = new PVector [names.length];
      for (int i=0; i<ipos.length; i++) if (i==namei) ipos[i] = new PVector (pos.x, pos.y);
      for (int i=0; i<ipos.length; i++) if (i<namei) ipos[i] = new PVector (pos.x, pos.y+(i*size.y)+size.y);
      for (int i=0; i<ipos.length; i++) if (i>namei) ipos[i] = new PVector (pos.x, pos.y+(i*size.y));
      for (int i=0; i<imid.length; i++) if (i==namei) imid[i] = new PVector (pos.x+size.x*.5f, pos.y+size.y*.5f);
      for (int i=0; i<imid.length; i++) if (i<namei) imid[i] = new PVector (pos.x+size.x*.5f, pos.y+(i*size.y)+size.y*1.5f);
      for (int i=0; i<imid.length; i++) if (i>namei) imid[i] = new PVector (pos.x+size.x*.5f, pos.y+(i*size.y)+size.y*0.5f);
      for (int i=0; i<iend.length; i++) if (i==namei) iend[i] = new PVector (pos.x+size.x, pos.y+size.y);
      for (int i=0; i<iend.length; i++) if (i<namei) iend[i] = new PVector (pos.x+size.x, pos.y+(i*size.y)+size.y*2);
      for (int i=0; i<iend.length; i++) if (i>namei) iend[i] = new PVector (pos.x+size.x, pos.y+(i*size.y)+size.y*1);
    }
    if (type==11) {
      ipos = new PVector [names.length];
      imid = new PVector [names.length];
      iend = new PVector [names.length];
      for (int i=0; i<ipos.length; i++) ipos[i] = new PVector (pos.x, pos.y+size.y+(size.y*i));
      for (int i=0; i<imid.length; i++) imid[i] = new PVector (pos.x+(size.x*.5f), pos.y+size.y+(size.y*i)+(size.y*.5f));
      for (int i=0; i<iend.length; i++) iend[i] = new PVector (pos.x+(size.x), pos.y+size.y+(size.y*i)+(size.y));
      
    }
    if (type==20||type==30) {
      ipos = new PVector [names.length];
      imid = new PVector [names.length];
      iend = new PVector [names.length];
      for (int i=0; i<ipos.length; i++) ipos[i] = new PVector (pos.x+(size.x*i), pos.y);
      for (int i=0; i<imid.length; i++) imid[i] = new PVector (pos.x+(size.x*i)+(size.x*.5f), pos.y+(size.y*.5f));
      for (int i=0; i<iend.length; i++) iend[i] = new PVector (pos.x+(size.x*i)+(size.x), pos.y+(size.y));
    }
  }
  public void display() {
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
    if (type==11) {
      stroke(con);
      if (isover()) strokeWeight (2*scand);
      else strokeWeight(1*scand);
      fill(con);
      //text(namei,pos.x,pos.y-15);
      //rect(pos.x, pos.y, size.x, size.y);
      PVector a = new PVector (pos.x+(size.x*.5f), pos.y+(size.y*.5f));
      PVector isize = new PVector (size.y, size.y);
      fill(con);
      drawicon(icon, a, isize);
      if (state) for (int i=0; i<ipos.length; i++) {
        textAlign(CENTER, CENTER);
        fill(255);
        if (isoveri()[i])  strokeWeight (2);
        else strokeWeight(1);
        rect(ipos[i].x, ipos[i].y, size.x, size.y, size.y/4);
        fill(con);
        text(names[i], imid[i].x, imid[i].y);
      }
    }
    if (type==20) {
      rectMode(CORNER);
      textAlign(CENTER, CENTER);
      for (int i=0; i<names.length; i++) if (i!=namei) {     
        noFill();
        stroke(coff);
        strokeWeight(1*scand);

        if (isoveri()[i]) strokeWeight(1.5f*scand);
        rect(ipos[i].x, ipos[i].y, size.x, size.y);
        fill(coff);
        text(names[i], imid[i].x, imid[i].y);
      }
      for (int i=0; i<names.length; i++) if (i==namei) {
        stroke(con);
        strokeWeight(1.5f*scand);
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
        if (isoveri()[i]) strokeWeight(1.5f*scand);
        ellipse( imid[i].x, imid[i].y, 7*scand, 7*scand);
      }
      for (int i=0; i<names.length; i++) if (i==namei) {
        fill(con);
        stroke(con);
        strokeWeight(1*scand);
        if (isoveri()[i]) strokeWeight(1.5f*scand);
        ellipse( imid[i].x, imid[i].y, 7*scand, 7*scand);
      }
    }
    popStyle();
  }
  public boolean isover() {
    if (mouseX>pos.x&&mouseX<end.x&&mouseY>pos.y&&mouseY<end.y) return true;
    else return false;
  }
  public boolean [] isoveri() {
    boolean [] bout = new boolean [names.length];
    for (int i=0; i<bout.length; i++) {
      if (mouseX>ipos[i].x&&mouseX<iend[i].x&&mouseY>ipos[i].y&&mouseY<iend[i].y) bout[i] = true;
      else bout[i] = false;
    }
    return bout;
  }
  public void press() {
    if (type==10||type==11) {
      if (isover()) state = !state;
      if (state) for (int i=0; i<names.length; i++) if (i!=namei||type==11) {
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
  public void pressoff(){
    if (type==11) namei=-1; 
  }
}
public void drawicon(int icon, PVector pos, PVector size) {
  if (icon==0) { 
    pushMatrix();
    rect(pos.x-size.x*.35f, pos.y, size.x*.7f, size.y*.1f, size.y*.1f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    popMatrix();
  }
  if (icon==1) {  //INFORMATION
    rectMode(CENTER);
    ellipse(pos.x, pos.y-size.y*.3f, size.y*.1f, size.y*.1f);
    rect(pos.x, pos.y+size.y*.1f, size.x*.1f, size.y*.5f, size.y*.1f);
    rect(pos.x-size.x*.1f, pos.y-size.y*.1f, size.x*.2f, size.y*.1f, size.y*.1f);
    rectMode(CORNER);
  }
  if (icon==2) { //PLUS
    rect(pos.x-size.x*.4f, pos.y-size.y*.05f, size.x*.8f, size.y*.1f, size.y*.1f);
    rect(pos.x-size.x*.05f, pos.y-size.y*.4f, size.x*.1f, size.y*.8f, size.y*.1f);
  }
  if (icon==3) {  // SAVED MOUSE
    pushMatrix();
    rect(pos.x-size.x*.05f, pos.y-size.y*.3f, size.y*.1f, size.y*.4f, size.y*.1f);
    rect(pos.x-size.x*.35f, pos.y+size.y*.2f, size.x*.7f, size.y*.1f, size.y*.1f);
    translate(size.x*.3f, -size.y*.4f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(HALF_PI);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.35f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    popMatrix();
  }
  if (icon==4) {       //HOME
    pushMatrix();
    rect(pos.x-size.x*.3f, pos.y-size.y*+.15f, size.y*.1f, size.y*.3f, size.y*.1f);
    rect(pos.x+size.x*.18f, pos.y-size.y*+.15f, size.y*.1f, size.y*.3f, size.y*.1f);
    rect(pos.x-size.x*.35f, pos.y+size.y*.2f, size.x*.7f, size.y*.1f, size.y*.1f);
    translate(size.x*.3f, -size.y*.4f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(HALF_PI);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.03f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    popMatrix();
  }

  if (icon==5) {  // SAVE
    pushMatrix();
    rect(pos.x-size.x*.05f, pos.y-size.y*.4f, size.y*.1f, size.y*.5f, size.y*.1f);
    rect(pos.x-size.x*.35f, pos.y+size.y*.2f, size.x*.7f, size.y*.1f, size.y*.1f);
    translate(size.x*.3f, -size.y*.4f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.50f);
    rotate(PI*1.5f);
    rotate( QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate( -2*QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    popMatrix();
  }

  if (icon==6) {  // PENCIL
    pushMatrix();
    translate(pos.x, pos.y);
    rotate( -QUARTER_PI);
    translate(-pos.x, -pos.y);
    rect(pos.x-size.y*.15f, pos.y-size.y*.1f, size.x*.5f, size.y*.15f, size.y*.1f);
    rotate( QUARTER_PI);
    popMatrix();
    triangle(pos.x-size.x*.2f, pos.y+size.x*.15f, pos.x-size.x*.2f, pos.y+size.x*.2f, pos.x-size.x*.15f, pos.y+size.x*.2f);
  }
  if (icon==7) {  // DELETE HOMES
    pushMatrix();
    translate(pos.x, pos.y);
    rotate( -QUARTER_PI);
    translate(-pos.x, -pos.y);
    rect(pos.x-size.x*.4f, pos.y-size.y*.05f, size.x*.8f, size.y*.1f, size.y*.1f);
    rect(pos.x-size.x*.05f, pos.y-size.y*.4f, size.x*.1f, size.y*.8f, size.y*.1f);
    popMatrix();
  }
  if (icon==8) {  // BUY HOME
    pushMatrix();
    translate(pos.x, pos.y);
    rotate( -QUARTER_PI);
    translate(-pos.x, -pos.y);
    translate(-size.x*.1f, size.y*.1f);
    rect(pos.x-size.y*.15f, pos.y-size.y*.05f, size.x*.6f, size.y*.15f, size.y*.1f);
    rect(pos.x-size.y*.15f, pos.y-size.y*.3f, size.x*.15f, size.y*.4f, size.y*.1f);
    popMatrix();
  }

  if (icon==9) { //MINUS
    rect(pos.x-size.x*.4f, pos.y-size.y*.05f, size.x*.8f, size.y*.1f, size.y*.1f);
    //rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
  }
  if (icon==10) {  //MORE 3 PUNTOS
    ellipse(pos.x-size.x*.3f, pos.y, size.y*.2f, size.y*.2f);
    ellipse(pos.x, pos.y, size.y*.2f, size.y*.2f);
    ellipse(pos.x+size.x*.3f, pos.y, size.y*.2f, size.y*.2f);
  }
  if (icon==11) { //ACCOUNT
    rect(pos.x-size.x*.35f, pos.y+size.y*.2f, size.x*.7f, size.y*.1f, size.y*.1f);
  }
  if (icon==12) {  // GENERATE
    pushMatrix();
    rect(pos.x-size.x*.3f, pos.y-size.y*+.15f, size.y*.1f, size.y*.3f, size.y*.1f);
    rect(pos.x+size.x*.18f, pos.y-size.y*+.15f, size.y*.1f, size.y*.3f, size.y*.1f);

    rect(pos.x-size.x*.1f, pos.y+size.y*.2f, size.x*.3f, size.y*.1f, size.y*.1f);
    rect(pos.x+size.x*.1f-size.x*.1f, pos.y+size.y*.1f, size.x*.1f, size.y*.3f, size.y*.1f);

    translate(size.x*.3f, -size.y*.4f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(HALF_PI);
    rotate(QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.05f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    translate(pos.x-size.x*.3f, pos.y+size.y*.05f);
    rotate(-2*QUARTER_PI);
    translate(-pos.x+size.x*.3f, -pos.y-size.y*.03f);
    rect(pos.x-size.x*.3f, pos.y, size.x*.4f, size.y*.1f, size.y*.1f);
    popMatrix();
  }
  if (icon==13) { //MINUS
    rect(pos.x-size.x*.2f, pos.y-size.y*.025f, size.x*.4f, size.y*.05f, size.y*.05f);
    //rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
  }

  if (icon==14) { //PLUS
    rect(pos.x-size.x*.2f, pos.y-size.y*.025f, size.x*.4f, size.y*.05f, size.y*.05f);
    rect(pos.x-size.x*.025f, pos.y-size.y*.2f, size.x*.05f, size.y*.4f, size.y*.05f);
  }
  if (icon==15) { //MINUS
    rect(pos.x-size.x*.3f, pos.y-size.y*.2f, size.x*.6f, size.y*.06f, size.y*.03f);
    rect(pos.x-size.x*.3f, pos.y-size.y*.0f, size.x*.6f, size.y*.06f, size.y*.03f);
    rect(pos.x-size.x*.3f, pos.y+size.y*.2f, size.x*.6f, size.y*.06f, size.y*.03f);
    //rect(pos.x-size.x*.05, pos.y-size.y*.4, size.x*.1, size.y*.8, size.y*.1);
  }
    if (icon==16) { //LOCK OPEN
    rect(pos.x-size.x*.25f, pos.y-size.y*.1f, size.x*.5f, size.y*.1f, size.y*.05f);
    rect(pos.x-size.x*.25f, pos.y+size.y*.2f, size.x*.5f, size.y*.1f, size.y*.05f);
    rect(pos.x-size.x*.25f, pos.y-size.y*.3f, size.x*.5f, size.y*.1f, size.y*.05f);
    rect(pos.x-size.x*.25f, pos.y-size.y*.3f, size.y*.1f, size.x*.55f, size.y*.05f);
    rect(pos.x+size.x*.25f-size.x*.1f, pos.y-size.y*.1f, size.x*.1f, size.x*.35f, size.y*.05f);
    rect(pos.x- size.x*.05f, pos.y+size.y*.02f, size.x*.1f, size.y*.15f, size.y*.05f);
  }

  if (icon==17) { //LOCK CLOSE
    rect(pos.x-size.x*.25f, pos.y-size.y*.1f, size.x*.5f, size.y*.1f, size.y*.05f);
    rect(pos.x-size.x*.25f, pos.y+size.y*.2f, size.x*.5f, size.y*.1f, size.y*.05f);
    rect(pos.x-size.x*.25f, pos.y-size.y*.3f, size.x*.5f, size.y*.1f, size.y*.05f);
    rect(pos.x-size.x*.25f, pos.y-size.y*.3f, size.y*.1f, size.x*.55f, size.y*.05f);
    rect(pos.x+size.x*.25f-size.x*.1f, pos.y-size.y*.3f, size.y*.1f, size.x*.55f, size.y*.05f);
    rect(pos.x- size.x*.05f, pos.y+size.y*.02f, size.x*.1f, size.y*.15f, size.y*.05f);
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
  int con = 100;
  int coff = 200;
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
  public void calcpos() {
    mid = new PVector(pos.x+size.x*.5f, pos.y+size.y*.5f);
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
      clpos = new PVector (pos.x-busize.y*.5f, pos.y-busize.y);
      clsize = new PVector (busize.x*2, busize.y);
    }
  }
  public void nostops() {
    slstopb = new PVector (pos.x, pos.y);
    slstope = new PVector (end.x, end.y);
  }
  public void scaletoandroid(float _scand) {
    scand = _scand;
    pos  = new PVector (scand*pos.x, scand*pos.y);
    size  = new PVector (scand*size.x, scand*size.y);
    calcpos();
    textsize = textsize * scand;
  }
  public void addstops(float _minstopV, float _maxstopV) {
    minstopv = _minstopV;
    maxstopv = _maxstopV;
    slstopb = new PVector (map(minstopv, minV, maxV, pos.x, end.x), map(minstopv, minV, maxV, pos.y, end.y));
    slstope = new PVector (map(maxstopv, minV, maxV, pos.x, end.x), map(maxstopv, minV, maxV, pos.y, end.y));
  }
  public void addsecond(float _value2) {
    value2 = _value2;
    calcpos();
  }
  public void display() {
    pushStyle();
    rectMode(CORNER);
    textSize(textsize);
    if (type==10) {                                   //Simple horizontal 
      value = rg(map(bupos.x, pos.x, end.x, minV, maxV), flt); 
      if (drag) bupos.x = constrain(mouseX, slstopb.x, slstope.x);
      println(pos.x);
      if (slstopb!=null)if (slstopb.x!=pos.x) line(slstopb.x, mid.y-(busize.y*.2f), slstopb.x, mid.y+(busize.y*.2f));
      if (slstope!=null)if (slstope.x!=end.x) line(slstope.x, mid.y-(busize.y*.2f), slstope.x, mid.y+(busize.y*.2f));
      noStroke();
      fill(coff);
      rect(pos.x, mid.y-slsize.y*.5f, slsize.x, slsize.y, slsize.y*.5f); 
      fill(con);
      rect(pos.x, mid.y-slsize.y*.5f, bupos.x-pos.x, slsize.y, slsize.y/2); 
      strokeWeight(1*scand);
      if (isover()) strokeWeight(2*scand);
      stroke(con);
      fill(255);
      ellipse(bupos.x, mid.y, busize.x, busize.y);
      fill(con);
      textAlign(CENTER, CENTER);
      if (flt>1) text( PApplet.parseInt(value), bupos.x, bupos.y-busize.y*.5f-textsize*.8f);
      else text( nfc(value, 2), bupos.x, bupos.y-busize.y*.5f-textsize*.8f); 
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
        if (slstopb!=null)if (slstopb.y!=pos.y) line(mid.x-busize.x*.2f, slstopb.y, mid.x+busize.x*.2f, slstopb.y);
        if (slstope!=null)if (slstope.y!=end.y) line(mid.x-busize.x*.2f, slstope.y, mid.x+busize.x*.2f, slstope.y);
        noStroke();
        fill(coff);
        rect( mid.x-slsize.x*.5f, pos.y, slsize.x, slsize.y, slsize.x*.5f); 
        fill(con);
        rect( mid.x-slsize.x*.5f, pos.y, slsize.x, bupos.y-pos.y, slsize.x/2); 
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
        stroke(coff);
        //ellipse(clpos.x+busize.x, clpos.y+busize.y-scand*5,2*scand,2*scand);
        line(clpos.x+busize.x, clpos.y+busize.y-scand*5, clpos.x+busize.x-scand*5, clpos.y+busize.y-scand*10);
        line(clpos.x+busize.x, clpos.y+busize.y-scand*5, clpos.x+busize.x+scand*5, clpos.y+busize.y-scand*10);
      }
      if (state) {
     line(clpos.x+busize.x, clpos.y+busize.y-scand*10, clpos.x+busize.x-scand*5, clpos.y+busize.y-scand*5);
        line(clpos.x+busize.x, clpos.y+busize.y-scand*10, clpos.x+busize.x+scand*5, clpos.y+busize.y-scand*5);
      }
      fill(con);
      textAlign(CENTER, CENTER);

      if (flt>=1) text( PApplet.parseInt(value), mid.x, pos.y-busize.y*.7f);
      else text( nfc(value, 2), mid.x, pos.y-busize.y*.7f); 
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
      if (slstopb!=null)if (slstopb.x!=pos.x) line(slstopb.x, slstopb.y-(busize.y*.2f), slstopb.x, slstopb.y+slsize.y+(busize.y*.2f));
      if (slstope!=null)if (slstope.x!=end.x) line(slstope.x, slstope.y-slsize.y-(busize.y*.2f), slstope.x, slstope.y+(busize.y*.2f));
      noStroke();
      fill(coff);
      rect(pos.x, mid.y-slsize.y*.5f, slsize.x, slsize.y, slsize.y*.5f); 
      fill(con);
      rect(bupos.x, mid.y-slsize.y*.5f, bupos2.x-bupos.x, slsize.y, slsize.y/2); 
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
      if (flt>1) text(PApplet.parseInt(value), bupos.x, pos.y-busize.y*.5f-textsize*.8f);
      else text( nfc(value, 2), bupos.x, pos.y-busize.y*.5f-textsize*.8f); 
      if (flt>1) text( PApplet.parseInt(value2), bupos2.x, pos.y-busize.y*.5f-textsize*.8f);
      else text( nfc(value2, 2), bupos2.x, pos.y-busize.y*.5f-textsize*.8f); 
      fill(con);
      textAlign(LEFT, CENTER);
      text(name, pos.x-textdist, mid.y);
      strokeWeight(1*scand);
    }









    popStyle();
  }
  public boolean isover() {
    return (mouseX>bupos.x-busize.x*.5f&&mouseX<bupos.x+busize.x*.5f&&mouseY>bupos.y-busize.y*.5f&&mouseY<bupos.y+busize.y*.5f);
  }
  public boolean isover2() {
    return (mouseX>bupos2.x-busize.x*.5f&&mouseX<bupos2.x+busize.x*.5f&&mouseY>bupos.y-busize.y*.5f&&mouseY<bupos.y+busize.y*.5f);
  }
  public boolean isovercl() {
    return (mouseX>clpos.x&&mouseX<clpos.x+clsize.x&&mouseY>clpos.y&&mouseY<clpos.y+clsize.y);
  }
  public boolean otherselectlist(ArrayList <Slider> allsl){
    boolean bout=false;
    for (Slider o:allsl) if (o.state) bout = true;
    if (state) bout = false;;
    return bout;
  }
  public boolean otherselectarr(Slider [] allsl){
    boolean bout=false;
    for (Slider o:allsl) if (o.state) bout = true;
    if (state) bout = false;;
    return bout;
  }  
  public void press() {
    if (isovercl()) state = !state;
    if (state) {
      if (isover()) drag = true;
      if (isover2()) drag2 = true;
    }
  }
  public void release() {
    drag = false;
    drag2 = false;
  }
  public float roundit(float numin, int dec) {                                              
    float dec10 = pow(10, dec);
    float roundout = round(numin * dec10)/dec10;
    return roundout;
  }
  public float rg(float fin, float grunit) {
    float fout = fin + grunit*.5f;
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
  int con = 200;
  int coff = 100;
  Text(PVector _pos, PVector _size, String _name, int _type) {
    pos=_pos;
    size=_size;
    calcpos();
    name = _name;
    type = _type;
  }
  public void scaletoandroid(float _scand) {
    scand = _scand;
    pos = new PVector (pos.x*scand, pos.y*scand);
    size = new PVector (size.x*scand, size.y*scand);
    calcpos();
    textsize  = textsize*scand;
  }
  public void calcpos() {
    mid = new PVector(pos.x+size.x*.5f, pos.y+size.y*.5f);
    end = new PVector(pos.x+size.x, pos.y+size.y);
  }
  public void display() {
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
    if (itext.length()==0&&!state) text(name, mid.x, mid.y-textsize*.3f);
    if (type==10&&itext.length()<50) {
      if (state) text(itext+dash, mid.x, mid.y-textsize*.3f);
      else text(itext, mid.x, mid.y-textsize*.3f);
    }
    if (type==20&&itext.length()<50) {
      String textp = "";
      for (int i=0; i<itext.length(); i++) textp = textp + "*";
      if (state) text(textp+dash, mid.x, mid.y-textsize*.3f);
      else text(textp, mid.x, mid.y-textsize*.3f);
    }
    
  }
    public boolean isover() {
    if (mouseX>pos.x&&mouseX<end.x&&mouseY>pos.y&&mouseY<end.y) return true;
    else return false;
  }
    public void select() {
    if (isover()) state = !state;
  }
  public void unselect() {
    if (state)if (!isover()) state = false;
  }
    public void type() {
    if (state) {
      if ((key >= 'A' && key <= 'z') ||(key >= '0' && key <= '9') || key == ' '|| key=='('|| key==')'|| key==','|| key=='.'|| key=='|'||key=='@'||key=='-'||key=='_')   itext = itext + str(key);
      if ((key == CODED&&keyCode == LEFT)||keyCode == BACKSPACE)  if (itext.length()>0) itext = itext.substring(0, itext.length()-1);
    }
  }
}

public boolean textis(ArrayList <Text> alltx) {
  boolean bout = false;
  for (Text a : alltx) if (a.state) bout = true;
  return bout;
}
class Textrect {
  PVector pos, size;
  String text;
  int i;
  Textrect(PVector _pos, PVector _size, String _text, int _i) {
    pos=_pos;
    size=_size;
    text=_text;
    i=_i;
  }
  public void display() {
    fill(255);
    textAlign(CENTER, CENTER);
    //rect(pos.x, pos.y, size.x, size.y);
    fill(100);
    if (text!=null) text(text, pos.x + size.x*.5f, pos.y + size.y*.5f);
  }
}
Slider sl [][];
Textrect tx [], tti [];
Toggle lk [];
Option addsubs[];
PVector uipos = new PVector (5, 20);
public void setupsl(String [] rooms, String [][] roomDATA) {

  tx = new Textrect [rooms.length];
  for (int i=0; i<tx.length; i++) tx[i] = new Textrect (new PVector (uipos.x, uipos.y+i*30), new PVector (60, 30), roomideals(rooms[i], 1, roomDATA), 10);
  String ttis [] = {"Area", "MinW", "MaxW"};
  tti = new Textrect [ttis.length];

  for (int i=0; i<tti.length; i++) tti[i] = new Textrect (new PVector (uipos.x+i*61+85, uipos.y-25), new PVector (60, 30), ttis[i], 10);
  sl = new Slider [3][rooms.length]; //0: area 1:width
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++)  sl[s][i] = new Slider(new PVector (uipos.x+100+s*61, uipos.y+30+i*30), new PVector (30, 200), roomideals(rooms[i], 0, roomDATA), 11, 0, PApplet.parseFloat(roomideals(rooms[i], 2+s, roomDATA)), 10);
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++)  sl[s][i].flt = .5f;
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) sl[s][i].scaletoandroid(scand);
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) sl[s][i].addstops(.5f, 9.5f);

  lk = new Toggle [rooms.length];  
  for (int l=0; l<lk.length; l++)   lk[l]= new Toggle(new PVector (uipos.x+60, uipos.y+l*30), new PVector (30, 30), "candado" + l, 50);
  addsubs = new Option [2];
  addsubs[0] = new Option(new PVector (uipos.x+280, uipos.y), new PVector (30, 30), roomcodedeDATAIN(roomDATAIN), 11);
  addsubs[1] = new Option(new PVector (uipos.x+330, uipos.y), new PVector (30, 30), rooms, 11);
  addsubs[0].icon = 2;
  addsubs[1].icon = 9;
  for (int l=0; l<addsubs.length; l++) addsubs[l].con = 150;
}
public void drawsl() {
  for (int i=0; i<tx.length; i++) tx[i].display();
  for (int i=0; i<tti.length; i++) tti[i].display();
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) sl[s][i].display();
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (!sl[s][i].otherselectarr(sl[s])) sl[s][i].display();
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (sl[s][i].drag) changeroom();
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (sl[s][i].drag)  setupid();
  //for (int s=0; s<roomDATA.length; s++) for (int i=0; i<roomDATA[s].length; i++) text(roomDATA[s][i],300+i*20,30+s*20);
  for (int l=0; l<lk.length; l++)  lk[l].display();
  for (int a=0; a<addsubs.length; a++) addsubs[a].display();
}
public void presssl() {
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (!sl[s][i].otherselectarr(sl[s])) sl[s][i].press();
}

public void lockpress() {
  for (int l=0; l<lk.length; l++) lk[l].press();
  boolean onelockselect = false;
  for (int l=0; l<lk.length; l++) if (lk[l].state) onelockselect = true;  

  if (!onelockselect)  for (int i=getngnum("pmin", rooms.length); i<getngnum("pmax", rooms.length); i++) lockgenes[i] = 0;
  if (!onelockselect)  for (int i=getngnum("lmin", rooms.length); i<getngnum("lmax", rooms.length); i++) lockgenes[i] = 0;
  if (onelockselect) for (int i=getngnum("pmin", rooms.length); i<getngnum("pmax", rooms.length); i++) lockgenes[i] = 1;
  if (onelockselect) for (int i=getngnum("lmin", rooms.length); i<getngnum("lmax", rooms.length); i++) lockgenes[i] = 1;

  for (int i=getngnum("smin", rooms.length); i<getngnum("smax", rooms.length); i++) lockgenes[i] = 0;  //todos los genes se hacen 0
  for (int l=0; l<lk.length; l++) if (lk[l].state) for (int n=0; n<ho.no.size(); n++) if (txequal(ho.no.get(n).code, rooms[l])) {
    for (int i=getngnum("smin", rooms.length); i<getngnum("smax", rooms.length); i++) if (ho.ng[i].loc.length()<ho.no.get(n).loc.length()) if (txequal(ho.ng[i].loc, ho.no.get(n).loc.substring(0, ho.ng[i].loc.length()))) lockgenes[i] = 1;
  }
  setuptr();
  setupid();
}
public void pressadddrooms() {
  for (int a=0; a<addsubs.length; a++) addsubs[a].press(); 

  for (int a=0; a<addsubs.length; a++) if (addsubs[a].namei!=-1) {
    if (addsubs[0].namei!=-1) rooms = addtostarr(rooms, roomDATAIN[addsubs[0].namei][0]);
    if (addsubs[1].namei!=-1) rooms = subtostarr(rooms, roomDATAIN[addsubs[1].namei][0]);
    
    roomDATA=getroomDATA(rooms, roomDATAIN);
    lockgenes = getroomLOCKS(rooms, lockIN);
    setupsl(rooms, roomDATA);
    setupho();
    setuptr();
    setupid();

  }
      for (int a=0; a<addsubs.length; a++) addsubs[a].pressoff();
}
  public void releasesl() {
    for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (!sl[s][i].otherselectarr(sl[s])) sl[s][i].release();
  }
  public void changeroom() {
    for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) roomDATA [i][2+s] = sl[s][i].value+"";
  }
  public void settings() {  size(800, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#050505", "--hide-stop", "Nodesubdivision8" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
