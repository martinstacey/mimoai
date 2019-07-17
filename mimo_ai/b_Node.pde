class Node {
  String code, loc;
  int nodei, leafi, inneri;
  PVector pos, size;
  boolean isleaf, ischilda;
  String ideals[], reals [], subparam [];
  ArrayList <Zone>  zones;
  Node father, childa, childb, brother;
  ArrayList <Mueble> muebles;
  Node(int _nodei, String _loc, boolean _isleaf) {
    nodei=_nodei;
    loc = _loc;
    isleaf = _isleaf;
    size = new PVector (15*scand, 15*scand);
    ideals = new String [roomDATA[0].length];
    reals = new String [roomDATA[0].length];
    subparam = new String [2]; // 0:X or Y 1: Percentage subdivition
  }
  void calcnodepos( PVector _treepos, PVector _treesize) {
    pos = locpos(loc, _treepos, _treesize);
  }
  void displaynodetree() {
    pushStyle();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    stroke(200);
    noFill();
    rect(pos.x, pos.y, size.x, size.y, size.y/4.0);
    fill(0);
    textSize(8);
    if (code!=null) text(code, pos.x, pos.y);
    if (father!=null) line(pos.x, pos.y-size.y/2, father.pos.x, father.pos.y+size.y/2);
    if (isleaf) if (ideals!=null) for (int i=0; i<ideals.length; i++) if (ideals[i]!=null)  text(ideals[i], pos.x-10, pos.y+10+10*i);
    if (isleaf) if (reals!=null ) for (int i=0; i<reals.length; i++) if (reals[i]!=null)  text(reals[i], pos.x+10, pos.y+10+10*i);
    //if (subparam!=null) for (int i=0; i<subparam.length; i++) if (subparam[i]!=null)  text(subparam[i], pos.x+30*i, pos.y+30);
    popStyle();
  }
  void displayrooms() {
    //if (isleaf) for (int z=0; z<zones.size(); z++)  zones.get(z).displaycolor(code);
    // if (isleaf) for (int z=0; z<zones.size(); z++)  zones.get(z).displaypoints();
    //if (isleaf) if (zones!=null) if (zones.size()>0) if (entry!=null)  if (entry.zones!=null) if (entry.zones.size()>0) daline(scgr(zones.get(0).pmid), scgr(entry.zones.get(0).pmid), 10*scand);
    if (isleaf) if (zones!=null) for (int z=0; z<zones.size(); z++) if (zones.get(z).borders!=null) for (int b=0; b<zones.get(z).borders.size(); b++) zones.get(z).borders.get(b).display();
    if (isleaf) if (zones!=null) if (zones.size()>0) zones.get(0).displaytittle(code);
  }
  void displaymuebles() {
    if (isleaf) if (muebles!=null) for (Mueble m : muebles)   m.display();
  }
}
ArrayList <Node> nodecrea(String []rooms, float [] locgene) {
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
        if (locgene[i-3]<1) leafsel = leafs.get(int(map(locgene[i-3], 0, 1, 0, leafs.size()))).nodei;
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
  String type, loc;
  float value, step, min, max;
  PVector  pos;
  boolean select, inactive;
  PVector size = new PVector (15*scand, 15*scand);
  Nodegene(String _type, float _value, boolean _inactive, PVector _pos) {
    type = _type;
    value=roundit(_value, 2);
    inactive=_inactive;
    step=.01;
    min=0;
    max=1;
    pos=_pos;
  }
  Nodegene cloneit() {
    Nodegene nout = new Nodegene (type, value, inactive, pos.copy());
    return nout;
  }
  Nodegene cloneactgene(float genevalue) {
    Nodegene nout;
    if (inactive) nout = new Nodegene (type, value, inactive, pos.copy());
    else nout = new Nodegene (type, genevalue, inactive, pos.copy());
    return nout;
  }
  void display() {
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
    rect(pos.x, pos.y, size.x, size.y, size.y*.25);
    fill(100);
    text(nf(value, 0, 2), pos.x, pos.y);
    text(type, pos.x-15, pos.y);
    popStyle();
  }
  boolean isover() {
    if (mouseX>pos.x-(size.x/2.0)&&mouseX<pos.x+(size.x/2.0)&&mouseY>pos.y-(size.y/2.0)&&mouseY<pos.y+(size.y/2.0)) return true;
    else return false;
  }
  void press() {
    if (isover()) select =!select;
  }
  void scroll(boolean updown) {
    if (select&&!updown&&value<max) value = roundit(value + step, 4);
    if (select&&updown&&value>min)  value = roundit(value - step, 4);
    if (value<min) value=roundit(min, 2);
    if (value>max) value=roundit(max, 2);
  }
  void changeval(float newval) {
    if (!inactive) value = newval;
  }
  void activateit(boolean act) {
    if (act&&select) inactive = !inactive;
  }
}
float [] ngvalues (Nodegene [] ng, int iniv, int endv) {
  float fout [] = new float [endv-iniv];
  for (int i=0; i<endv-iniv; i++) fout [i] = ng [i+iniv].value;
  return fout;
}
float  ngvalue (Nodegene [] ng, int iniv) {
  float fout  = ng [iniv].value;
  return fout;
}
