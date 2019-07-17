class Zone {
  int     id [] = new int     [2]; //0:nodei,1:zonei
  PVector pt [] = new PVector [4]; //p00, p11,p01, p10;
  ArrayList <Border> borders;

  Zone (PVector _p00, PVector _p11) {
    pt[0] = _p00;
    pt[1] =_p11;
    pt[2] = new PVector (pt[0].x, pt[1].y);
    pt[3] = new PVector (pt[1].x, pt[0].y);
  }
  Zone cloneit() {
    Zone zout = new Zone (pt[0].copy(), pt[1].copy());
    zout.id = cloneintarr(id);
    zout.borders = cloneborderslist(borders);
    return zout;
  }
  Zone clonenewpts(PVector newp10, PVector newp11) {
    Zone zout = new Zone (newp10, newp11);
    zout.id = cloneintarr(id);
    zout.borders = cloneborderslist(borders);
    return zout;
  }
  PVector pmid() {
    return new PVector((pt[0].x+pt[1].x)*.5, (pt[0].y+pt[1].y)*.5);
  }
  float area () {
    return  abs(pt[1].x-pt[0].x)*abs(pt[1].y-pt[0].y);
  }
  float prop () {
    if ((pt[1].x-pt[0].x)<(pt[1].y-pt[0].y)) return ((pt[1].x-pt[0].x)/(pt[1].y-pt[0].y));
    else return ((pt[1].y-pt[0].y)/(pt[1].x-pt[0].x));
  }
  float xdim() {
    return abs(pt[1].x-pt[0].x);
  }
  float ydim() {
    return abs(pt[1].y-pt[0].y);
  }
  boolean lengthisx() {
    boolean bout = xdim()>=ydim();
    return bout;
  }
  float zwidth() {
    if (!lengthisx()) return xdim();
    else return ydim();
  }
  float zlength() {
    if (lengthisx()) return xdim();
    else return ydim();
  }
  void displaypoints() {
    noStroke();
    fill(255, 0, 0, 100);
    ellipse(scgr(pt[0]).x, scgr(pt[0]).y, 5, 5);
    ellipse(scgr(pt[3]).x, scgr(pt[3]).y, 5, 5);
    ellipse(scgr(pt[2]).x, scgr(pt[2]).y, 5, 5);
    ellipse(scgr(pt[1]).x, scgr(pt[1]).y, 5, 5);
  }
  void displaytittle(String code) {
    pushStyle();
    textAlign(CENTER, CENTER);
    stroke(150);
    fill(255);
    if (code.length()<=2)  textSize(12*scand);
    else textSize(10*scand);
    ellipse(scgr(pmid()).x, scgr(pmid()).y, 20*scand, 20*scand);

    fill(150);
    int adjcount = 0;
    for (Border b : borders) if (b.adj!=null) if (b.adj.id[0]!=b.id[0]) adjcount++;
    //text(adjcount, scgr(pmid).x, scgr(pmid).y-10);
    //text(nodei, scgr(pmid).x, scgr(pmid).y-10);
    if (code!=null)  text(code, scgr(pmid()).x, scgr(pmid()).y);
    //if (code!=null) if (code.length()>2)  text(code.substring(0, 2), scgr(pmid()).x, scgr(pmid()).y);
    //if (code!=null) if (code.length()<=2) text(code, scgr(pmid()).x, scgr(pmid()).y);
    popStyle();
  }
  void displaycolor(String code) {
    pushStyle();
    rectMode(CORNERS);
    colorDEcode(code, 50, roomDATA);
    rect(scgr(pt[0]).x, scgr(pt[0]).y, scgr(pt[1]).x, scgr(pt[1]).y);
    popStyle();
  }
  void displaycreate() {
    pushStyle();
    strokeWeight(2*scand);
    stroke(150);
    strokeWeight(1*scand);
    stroke(180);
    hashrectangle(pt[0].x, pt[0].y, pt[1].x, pt[1].y);
    popStyle();
  }
}
ArrayList <Zone> calczones(Node n, ArrayList <Zone> homedge) {
  ArrayList <Zone> zo = new ArrayList <Zone> ();
  if (n.father==null) zo=homedge; //este deberia ser la zona 
  else {
    Node father = n.father;
    ArrayList <Zone> fzones = father.zones;
    boolean child1 = n.ischilda;
    boolean childx = ischildx(float(n.father.subparam[0]));
    float subper = float(n.subparam[1]);
    float brosubper = float(n.brother.subparam[1]);
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
  for (int i=0; i<zo.size(); i++) zo.get(i).id[0] = n.nodei;
  for (int i=0; i<zo.size(); i++) zo.get(i).id[1] = i;
  return zo;
}
ArrayList <Node> calcallzones(ArrayList <Node> no, ArrayList <Zone> homedges) {
  for (int n=0; n<no.size(); n++) no.get(n).zones = calczones(no.get(n), homedges);
  return no;
}
ArrayList <Zone> prophomedges(ArrayList <Zone> homedge, float scaleprop) {
  ArrayList <Zone> newhomedge = new ArrayList <Zone> ();
  for (int i=0; i<homedge.size(); i++) newhomedge.add(new Zone(new PVector (homedge.get(i).pt[0].x*scaleprop, homedge.get(i).pt[0].y), new PVector (homedge.get(i).pt[1].x*scaleprop, homedge.get(i).pt[1].y)));
  return newhomedge;
}
float calctotpropfit(ArrayList <Node> no, float fitperprop) { 
  float   totpropfit = 0;
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) totpropfit+=abs(float(no.get(n).ideals[8])-float(no.get(n).reals[8]))*fitperprop;
  return totpropfit;
}
float calctotadjfit(ArrayList <Node> no, float fitpernonadj) {  
  float   adjfit = 0;
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) {
    String idealsep = no.get(n).ideals[9];
    boolean roominhome = false;
    boolean isalreadyadj = false;
    for (int m=0; m<no.size(); m++) if (txequal(idealsep, no.get(m).code)) roominhome = true;
    if (!roominhome) isalreadyadj = true; 
    String [] realsep = split(no.get(n).reals[9], ' ');
    for (int j=0; j<realsep.length; j++) if (txequal(realsep[j], idealsep)||txequal(idealsep, "")) isalreadyadj = true;
    if (!isalreadyadj) adjfit +=fitpernonadj;
  }
  return adjfit;
}
float calcmissingzonesfit(ArrayList <Node> no, float fitpermis) {
  float   missfit = 0;
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()==0) missfit +=fitpermis;
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) if (no.get(n).zones.get(0).area()==0) missfit +=fitpermis;
  return missfit;
}

float calcclosetinbetween(ArrayList <Node> no, float fitpermis) {
  float   missfit = 0;
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (txequal(no.get(n).ideals[10], "2")) if (!no.get(n).brother.isleaf) missfit +=fitpermis;
  return missfit;
}
