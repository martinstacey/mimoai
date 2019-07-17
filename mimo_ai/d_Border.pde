color grayMue = color(152, 152, 152);
color blackLet= color(75, 75, 75);
color blackWall = color(30, 30, 30);
color blueWindow = color(152, 180, 222);

class Border {
  int     id [] = new int    [5];  //0:nodei 1:zonei 2:sidei 3:borderi 4:tipo (0:normal, 1:entry 2:facade 3:introom        4:openning 5:door 6:window 7:wall  8: paramueble)
  PVector pt [] = new PVector[2];  //0:p0 1:p1 
  Border adj;
  Border(int [] _id, PVector [] _pt) {
    id = _id;
    pt=_pt;
  }
  Border cloneit() { //no clona adj
    Border bout = new Border (cloneintarr(id), clonevecarr(pt));
    return bout;
  }
  PVector pmid(){
    return new PVector ((pt[0].x+pt[1].x)*.5, (pt[0].y+pt[1].y)*.5);
  }
  float bsize(){
    return PVector.dist(pt[1], pt[0]);
  }
  void display() {
    pushStyle();
    drawwindow(id[4], pt[0], pt[1]);
    drawdoor(id[4], id[2], pt[0], pt[1]);
    drawwall(id[4], adj, pt[0], pt[1]);
    drawopening(id[4], adj, pt[0], pt[1]);
    drawsuportfurniture(id[4], adj, pt[0], pt[1]);
    popStyle();
  }
}
Border caldadjborder(Border bord, ArrayList <Node> nodes) {
  Border bout=null;
  for (int n=0; n<nodes.size(); n++) if (nodes.get(n).isleaf) for (int z=0; z<nodes.get(n).zones.size(); z++)     for (int b=0; b<nodes.get(n).zones.get(z).borders.size(); b++) {
    Border bord2 = nodes.get(n).zones.get(z).borders.get(b);
    if (!(bord.id[0]==bord2.id[0]&&bord.id[1]==bord2.id[1]&&bord.id[3]==bord2.id[3])) {
      if (vectorsequal(bord.pt[0], bord2.pt[0])&&vectorsequal(bord.pt[1], bord2.pt[1])) bout=nodes.get(n).zones.get(z).borders.get(b);
    }
  }
  return bout;
}
ArrayList<Border> borderDEzones(Zone zone, ArrayList <Node> nodes) {
  ArrayList <Border> bout = new ArrayList <Border> (); 
  PVector [][] ps = new PVector [4][2];
  ps[0][0] = zone.pt[0].copy();
  ps[0][1] = zone.pt[2].copy();
  ps[1][0] = zone.pt[2].copy();
  ps[1][1] = zone.pt[1].copy();
  ps[2][0] = zone.pt[3].copy();
  ps[2][1] = zone.pt[1].copy();
  ps[3][0] = zone.pt[0].copy();
  ps[3][1] = zone.pt[3].copy();
  boolean [] isonx = {true, false, true, false};
  for (int s=0; s<4; s++) {
    ArrayList <PVector> pointsinside = new ArrayList <PVector> (); 
    pointsinside.add(ps[s][0]);
    for (int n=0; n<nodes.size(); n++) if (nodes.get(n).isleaf) for (int z=0; z<nodes.get(n).zones.size(); z++) {
      PVector p00 = nodes.get(n).zones.get(z).pt[0].copy();
      PVector p01 = nodes.get(n).zones.get(z).pt[2].copy();
      PVector p10 = nodes.get(n).zones.get(z).pt[3].copy();
      PVector p11 = nodes.get(n).zones.get(z).pt[1].copy();
      if (sameXY(ps[s][0], p00, isonx[s])&&withinXY(ps[s][0], ps[s][1], p00, !isonx[s])) pointsinside.add(nodes.get(n).zones.get(z).pt[0]);    
      if (sameXY(ps[s][0], p01, isonx[s])&&withinXY(ps[s][0], ps[s][1], p01, !isonx[s])) pointsinside.add(nodes.get(n).zones.get(z).pt[2]);    
      if (sameXY(ps[s][0], p10, isonx[s])&&withinXY(ps[s][0], ps[s][1], p10, !isonx[s])) pointsinside.add(nodes.get(n).zones.get(z).pt[3]);    
      if (sameXY(ps[s][0], p11, isonx[s])&&withinXY(ps[s][0], ps[s][1], p11, !isonx[s])) pointsinside.add(nodes.get(n).zones.get(z).pt[1]);
    }
    pointsinside.add(ps[s][1]);
    for (int i=0; i<pointsinside.size()-1; i++) if (!vectorsequal(pointsinside.get(i), pointsinside.get(i+1))) {
      int ids [] = new int [5];
      ids[0] = zone.id[0];
      ids[1] = zone.id[1];
      ids[2] = s;
      PVector pts [] = new PVector [2];
      pts[0] = pointsinside.get(i);
      pts[1] = pointsinside.get(i+1);
      bout.add(new Border(ids, pts));
    }
  }
  for (int b=0; b<bout.size(); b++) bout.get(b).id[3] = b;
  return bout;
}
void drawopening(int tipo, Border adj, PVector p0, PVector p1) {
  if (tipo==4) {
    strokeWeight(2*scand);
    stroke(grayMue);
    line( scgr(p0).x, scgr(p0).y, scgr(p1).x, scgr(p1).y);
  }
}
void drawsuportfurniture(int tipo, Border adj, PVector p0, PVector p1) {
  boolean drawwall = false;
  if (adj!=null) if (tipo==8&&adj.id[4]!=4&&adj.id[4]!=5)drawwall = true;
  if (adj==null) if (tipo==8) drawwall = true;
  if (drawwall) {
    strokeWeight(4*scand);
    stroke(blackWall);
    line( scgr(p0).x, scgr(p0).y, scgr(p1).x, scgr(p1).y);
    //stroke(255, 0, 0);
    //ellipse( (scgr(p0).x+scgr(p1).x)/2, (scgr(p0).y+scgr(p1).y)/2, 5, 5);
  }
}
void drawwall(int tipo, Border adj, PVector p0, PVector p1) {  //0:normal, 1:entry 2:facade 3:introom        4:openning 5:door 6:window 7:wall  8: paramueble 
  boolean drawwall = false;
  if (adj!=null) if (tipo==7&&adj.id[4]!=4&&adj.id[4]!=5)drawwall = true;
  if (adj==null) if (tipo==7) drawwall = true;
  if (drawwall) {
    strokeWeight(4*scand);
    stroke(blackWall);
    line( scgr(p0).x, scgr(p0).y, scgr(p1).x, scgr(p1).y);
  }
}
void drawdoor(int tipo, int sidei, PVector p0, PVector p1) {
  if (tipo==5) {
    noFill();
    stroke(blackWall);
    strokeWeight(1*scand);
    if (sidei==0) arc(scgr(p0).x, scgr(p0).y, scsif(.90*2), scsif(.90*2), 0, PI*.5);
    if (sidei==1) arc(scgr(p0).x, scgr(p1).y, scsif(.90*2), scsif(.90*2), PI*1.5, PI*2);
    if (sidei==2) arc(scgr(p1).x, scgr(p1).y, scsif(.90*2), scsif(.90*2), PI, PI*1.5);
    if (sidei==3) arc(scgr(p1).x, scgr(p0).y, scsif(.90*2), scsif(.90*2), PI*.5, PI);
    if (sidei==0) line(scgr(p0).x, scgr(p0).y, scgr(p0).x+scsif(.90), scgr(p0).y);
    if (sidei==1) line(scgr(p0).x, scgr(p1).y, scgr(p0).x, scgr(p1).y-scsif(.90));
    if (sidei==2) line(scgr(p1).x, scgr(p1).y, scgr(p1).x-scsif(.90), scgr(p1).y);
    if (sidei==3) line(scgr(p1).x, scgr(p0).y, scgr(p1).x, scgr(p0).y+scsif(.90));
    strokeWeight(2*scand);
    if (sidei==0) line(scgr(p0).x-5*scand, scgr(p0).y, scgr(p0).x+5*scand, scgr(p0).y);                        //marcos
    if (sidei==0) line(scgr(p0).x-5*scand, scgr(p0).y+scsif(.90), scgr(p0).x+5*scand, scgr(p0).y+scsif(.90));
    if (sidei==1) line(scgr(p0).x, scgr(p1).y-5*scand, scgr(p0).x, scgr(p1).y+5*scand);
    if (sidei==1) line(scgr(p0).x+scsif(.90), scgr(p1).y-5*scand, scgr(p0).x+scsif(.90), scgr(p1).y+5*scand);
    if (sidei==2) line(scgr(p1).x-5*scand, scgr(p1).y, scgr(p1).x+5*scand, scgr(p1).y);
    if (sidei==2) line(scgr(p1).x-5*scand, scgr(p1).y-scsif(.90), scgr(p1).x+5*scand, scgr(p1).y-scsif(.90));
    if (sidei==3) line(scgr(p1).x, scgr(p0).y-5*scand, scgr(p1).x, scgr(p0).y+5*scand);
    if (sidei==3) line(scgr(p1).x-scsif(.90), scgr(p0).y-5*scand, scgr(p1).x-scsif(.90), scgr(p0).y+5*scand);
    strokeWeight(4*scand);
    if (sidei==0) line(scgr(p0).x, scgr(p0).y+scsif(.9), scgr(p1).x, scgr(p1).y);                              //pared
    if (sidei==1) line(scgr(p0).x+scsif(.9), scgr(p1).y, scgr(p1).x, scgr(p1).y);
    if (sidei==2) line(scgr(p1).x, scgr(p1).y-scsif(.9), scgr(p1).x, scgr(p0).y);
    if (sidei==3) line(scgr(p1).x-scsif(.9), scgr(p0).y, scgr(p0).x, scgr(p0).y);
  }
}
void drawwindow(int tipo, PVector p0, PVector p1) {
  if (tipo==6) {
    pushStyle();
    strokeWeight(2*scand);
    stroke(blueWindow);
    line( scgr(p0).x, scgr(p0).y, scgr(p1).x, scgr(p1).y);
    stroke(blackWall);
    if (p0.x==p1.x) {
      line(scgr(p0).x-5*scand, scgr(p0).y, scgr(p0).x+5*scand, scgr(p0).y);
      line(scgr(p1).x-5*scand, scgr(p1).y, scgr(p1).x+5*scand, scgr(p1).y);
    } else {
      line(scgr(p0).x, scgr(p0).y-5*scand, scgr(p0).x, scgr(p0).y+5*scand);
      line(scgr(p1).x, scgr(p1).y-5*scand, scgr(p1).x, scgr(p1).y+5*scand);
    }
    popStyle();
  }
}
