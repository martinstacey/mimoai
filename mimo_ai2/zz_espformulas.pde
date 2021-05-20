

ArrayList <Zone> clonezonelist(ArrayList <Zone> zlistin) {
  ArrayList <Zone> zlistout = new ArrayList <Zone> ();
  for (int i=0; i<zlistin.size(); i++) zlistout.add(zlistin.get(i).cloneit());
  return zlistout;
}
Nodegene [] clonengarrwithgenes(Nodegene [] ngin, float [] genes) {
  Nodegene []  nout = new Nodegene [ngin.length];
  for (int i=0; i<ngin.length; i++) nout[i] = ngin[i].cloneactgene(genes[i]);
  return nout;
}








//                                                                                                     BOOLEAN
//                                                                                                             ischilda
boolean ifischilda(String loc) {                                      
  boolean bout = false;
  if (loc.charAt(loc.length()-1)=='0'||int(loc.charAt(loc.length()-1))==int("0 ")) bout = true;
  return bout;
}
boolean ischildx(float g0) {                                                                                 // childx
  boolean bout; 
  if (g0<.5) bout=true;
  else bout = false;
  return bout;
}
boolean zonewithinline(Zone fzone, float pline0, float pline1, boolean child1, boolean childx) {            //zonewithinline
  if       (child1&&childx &&fzone.pt[0].x<pline0) return true;
  else if  (child1&&!childx&&fzone.pt[0].y<pline0) return true;
  else if  (!child1&&childx&&fzone.pt[1].x>pline1) return true;
  else if (!child1&&!childx&&fzone.pt[1].y>pline1) return true;
  else return false;
}
//                                                                                                       FLOATS
float pminmax(int min0max1, ArrayList <Zone> fzones, boolean childx) {                                      //min max from zones
  float fout;
  if (fzones.size()==0) {
    fout = 0;
  } else if (min0max1==0) {
    if (childx) {
      fout = fzones.get(0).pt[0].x;
      for (Zone f : fzones) if (f.pt[0].x<fout) fout = f.pt[0].x;
    } else {
      fout = fzones.get(0).pt[0].y;
      for (Zone f : fzones) if (f.pt[0].y<fout) fout = f.pt[0].y;
    }
  } else {
    if (childx) {
      fout = fzones.get(0).pt[1].x;
      for (Zone f : fzones) if (f.pt[1].x>fout) fout = f.pt[1].x;
    } else {
      fout = fzones.get(0).pt[1].y;
      for (Zone f : fzones) if (f.pt[1].y>fout) fout = f.pt[1].y;
    }
  }
  return fout;
}
//                                                                                                      PVECTOR
//                                                                                                             treepos
PVector locpos(String loc, PVector treepos, PVector treesize) {
  PVector pv;
  float pvx = treepos.x;
  for (int i=1; i<loc.length(); i++) {
    if (loc.charAt(i)=='0'||int(loc.charAt(i))==int("0 ")) {
      pvx = pvx - treesize.x/pow(2, i);
    }
  }
  for (int i=1; i<loc.length(); i++) {
    if (loc.charAt(i)=='1'||int(loc.charAt(i))==int("1 ")) {
      pvx = pvx + treesize.x/pow(2, i);
    }
  }
  float pvy = (((loc.length())-1) * treesize.y) + treepos.y; 
  pv = new PVector (pvx, pvy);
  return pv;
}
int getngnum(String txtoget, int nrooms) {
  //min0(nrooms-2)
  int  iout = 0;
  if (txequal(txtoget, "lmin"))iout = 0;
  else if (txequal(txtoget, "lmax")||txequal(txtoget, "pmin"))iout = min0(nrooms-2);
  else if (txequal(txtoget, "pmax")||txequal(txtoget, "smin"))iout = min0(nrooms-2)+1;
  else if (txequal(txtoget, "smax"))iout = min0(nrooms-2)+1+min0(nrooms-1); 
  return iout;
}
Zone breakfzones(Zone fzone, float pline0, float pline1, boolean child1, boolean childx) {                                                     //ZONE
  if       (child1&&childx ) return new Zone (fzone.pt[0].copy(), new PVector (min0max1fl(0, pline0, fzone.pt[1].x), fzone.pt[1].y));
  else if  (child1&&!childx) return new Zone (fzone.pt[0].copy(), new PVector (fzone.pt[1].x, min0max1fl(0, pline0, fzone.pt[1].y)));
  else if  (!child1&&childx) return new Zone (new PVector(min0max1fl(1, pline1, fzone.pt[0].x), fzone.pt[0].y), fzone.pt[1].copy());
  else if (!child1&&!childx) return new Zone (new PVector(fzone.pt[0].x, min0max1fl(1, pline1, fzone.pt[0].y)), fzone.pt[1].copy()); //fzone.type
  else return null;
}
ArrayList <Zone> sortzonesbyarea(ArrayList <Zone> inarr) {
  Zone tmp = inarr.get(0).cloneit();
  for (int i = 0; i < inarr.size(); i++) for (int j = i + 1; j < inarr.size(); j++) if (inarr.get(i).area() < inarr.get(j).area()) {
    tmp = inarr.get(i);
    inarr.set(i, inarr.get(j));
    inarr.set(j, tmp);
  }
  return inarr;
}





//                                                                                                                                                                      NODE
//                                                                                                                                                  relationships
Node calcrelative(Node n, ArrayList <Node> other, String relat) {//si es forloop normal? probar pareceque no no se necesita
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

//ArrayList <Node> calcnodeadj(int noi, Node no, ArrayList <Node> ono) {                                                                                           //calcadj
//  ArrayList <Node> nout = new ArrayList <Node> ();
//  for (int i=0; i<no.zones.size(); i++) for (int j=0; j<ono.size(); j++) if (j!=noi) if (ono.get(j).isleaf) for (int l=0; l<ono.get(j).zones.size(); l++) {
//    if (isadj(no.zones.get(i), ono.get(j).zones.get(l))) {
//      boolean isalreadyinlist = false;
//      for (int m=0; m<nout.size(); m++) if (txequal(nout.get(m).loc, ono.get(j).loc)) isalreadyinlist = true;
//      if (!isalreadyinlist) nout.add(ono.get(j));
//    }
//  }
//  return nout;
//}
int calcbordertype(ArrayList <Node> allnodes, Node no, Border bo) {      //0:normal, 1:entry 2:facade 3:introom        4:openning 5:door 6:window 7:wall  8: paramueble                                                         //calcbordertype
  int iout = 0; 
  if (bo.adj!=null) if (txequal(no.ideals[9], allnodes.get(bo.adj.id[0]).code)) iout = 1;
  if (bo.adj==null) iout = 2;
  if (bo.adj!=null) if (bo.id[0]==bo.adj.id[0]) iout = 3;
  return iout;
}

void calcbordertyperoom(ArrayList <Node> allnodes, Node no) {      //0: mueblecentro 1:muebleapegado 2:noventananopuerta                                                          //calcbordertype
  if (int(no.ideals[10])==0) { //calcular fachada mas grande hacer ventana, calcular ultima zona entrada si esque no hay entrada poner puerta a otro cuarto, no olvidarse otras puertas
    boolean hasdoor = false;
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==1)if (!hasdoor) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 5;
      hasdoor=true;
    }
    boolean haswindow = false;
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==2) if (bigborder(b, z)) if (!haswindow) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 6;
      //haswindow=true;
    }
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==2) if (!haswindow) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 6;
      //haswindow=true;
    }
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]!=5&&b.id[4]!=6&&b.id[4]!=8&&b.id[4]!=3) no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 7; 
  }             
  if (int(no.ideals[10])==1) {
    boolean hasdoor = false;
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==1)if (!hasdoor) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 5;
      hasdoor=true;
    }
    boolean hasfurniture = false;
    for (Zone z : no.zones) for (Border b : z.borders)if (b.id[4]!=5) if (bigborder(b, z)) if (!hasfurniture) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 8;
      hasfurniture=true;
    }
    boolean haswindow = false;
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==2) if (bigborder(b, z)) if (!haswindow) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 6;
      haswindow=true;
    }
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==2) if (!haswindow) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 6;
      haswindow=true;
    }
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]!=5&&b.id[4]!=6&&b.id[4]!=8&&b.id[4]!=3) no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 7; 
  }
  if (int(no.ideals[10])==2) {           
    boolean hasentry = false;
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==1) if (bigborder(b, z)) if (!hasentry) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 4;
      hasentry=true;
    }
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==0) if (bigborder(b, z)) if (!hasentry) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 4;
      hasentry=true;
    }
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]==0) if (!hasentry) {
      no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 4;
      hasentry=true;
    }
    for (Zone z : no.zones) for (Border b : z.borders) if (b.id[4]!=4&&b.id[4]!=3) no.zones.get(z.id[1]).borders.get(b.id[3]).id[4] = 7;
  }
}

boolean bigborder(Border bo, Zone zo) {
  boolean bout = true;
  for (int b=0; b<zo.borders.size(); b++) if (zo.borders.get(b).bsize()>bo.bsize()) bout = false; 
  return bout;
}
boolean bigbordertipe(Border bo, Zone zo, int type) {
  boolean bout = true;
  for (int b=0; b<zo.borders.size(); b++) if (zo.borders.get(b).id[4] == type)if (zo.borders.get(b).bsize()>bo.bsize()) bout = false; 
  return bout;
}
String adjlist (ArrayList <Node> onodes, Node no) {
  String stout = "";
  ArrayList <String> starr = new ArrayList <String> ();
  for (int z=0; z<no.zones.size(); z++) for (int b=0; b<no.zones.get(z).borders.size(); b++) if (no.zones.get(z).borders.get(b).adj!=null) if (!(no.zones.get(z).borders.get(b).adj.id[0]==no.nodei)) {
    boolean alreadyinlist = false;
    String posadj = onodes.get(no.zones.get(z).borders.get(b).adj.id[0]).code;
    for (int s=0; s<starr.size(); s++) if (txequal(posadj, starr.get(s))) alreadyinlist = true;
    if (!alreadyinlist) starr.add(posadj);
  }
  for (int s=0; s<starr.size(); s++) stout += starr.get(s) + " ";
  if (stout.length()>0) stout =  stout.substring(0, stout.length()-1);
  return stout;
}
ArrayList <Node> addfacadeadj(Node no, ArrayList <Node> alladj, ArrayList <Node> faca) {                                                                         //facadeadj
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
boolean isadj(Zone a, Zone b) {                                                                                                                              //adjs
  boolean bout = false;
  if (a.pt[0].x==b.pt[1].x&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 1)) bout = true;
  if (a.pt[1].x==b.pt[0].x&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 1)) bout = true;
  if (a.pt[0].y==b.pt[1].y&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 0)) bout = true;
  if (a.pt[1].y==b.pt[0].y&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 0)) bout = true;
  return bout;
}
//boolean isadjside(Zone a, Zone b, int side) {
//  boolean iout = false;
//  if (side==0) if (a.pt[0].x==b.pt[1].x&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 1)) iout = true;
//  if (side==1) if (a.pt[1].y==b.pt[0].y&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 0)) iout = true;
//  if (side==2) if (a.pt[1].x==b.pt[0].x&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 1)) iout = true;
//  if (side==3) if (a.pt[0].y==b.pt[1].y&&within(a.pt[0], a.pt[1], b.pt[0], b.pt[1], 0)) iout = true;
//  return iout;
//}
boolean within(PVector a00, PVector a11, PVector b00, PVector b11, int x0y1) {                                                                             //within
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
boolean sameXY(PVector a, PVector b, boolean isx) {
  boolean bout = false;
  if  (isx) bout =  a.x==b.x;
  if (!isx) bout =  a.y==b.y;
  return bout;
}
boolean withinXY(PVector a0, PVector a1, PVector b, boolean isx) {
  boolean bout = false;
  if (isx)  bout = b.x>a0.x && b.x<a1.x;
  if (!isx) bout = b.y>a0.y && b.y<a1.y;  
  return bout;
}

void scaleno(ArrayList <Node> no, float sca) {
  for (int n=0; n<no.size(); n++) for (int z=0; z<no.get(n).zones.size(); z++) {
    PVector newp00 = no.get(n).zones.get(z).pt[0].copy().mult(sqrt(sca));
    PVector newp11 = no.get(n).zones.get(z).pt[1].copy().mult(sqrt(sca)); 
    no.get(n).zones.set(z, no.get(n).zones.get(z).clonenewpts(newp00, newp11));
  }
}
void gridno(ArrayList <Node> no) {
  for (int n=0; n<no.size(); n++) for (int z=0; z<no.get(n).zones.size(); z++) {  
    PVector newp00 = new PVector (rg(no.get(n).zones.get(z).pt[0].x), rg(no.get(n).zones.get(z).pt[0].y));
    PVector newp11 = new PVector (rg(no.get(n).zones.get(z).pt[1].x), rg(no.get(n).zones.get(z).pt[1].y));
    no.get(n).zones.set(z, no.get(n).zones.get(z).clonenewpts(newp00, newp11));
  }
}
float calcstrechfactor(ArrayList <Node> no) {
  float scfactor = 1;
  float totidealarea = 0;
  float tothousearea = 0;
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) totidealarea +=float(no.get(n).ideals[2]);
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) tothousearea += no.get(n).zones.get(z).area();
  if (totidealarea != 0&&tothousearea != 0) scfactor = totidealarea / tothousearea;
  return scfactor;
}
void removeemptyzones(ArrayList <Node> no) {
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) {                               //delete 00 zones
    PVector p00 = no.get(n).zones.get(z).pt[0];
    PVector p11 = no.get(n).zones.get(z).pt[1];
    if (p00.x==p11.x||p00.y==p11.y) no.get(n).zones.remove(z);
  }
  for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) no.get(n).zones.get(z).id[1]=z;
}
void colorDEcode (String code, float transp, String [][] roomDATA) {                                                       
  float colprim = 255/2;
  if (code!=null) for (int i=0; i<roomDATA.length; i++) if (txequal(code, roomDATA[i][0])) colprim = map (i, 0, roomDATA.length, 0, 255);
  noStroke();
  colorMode(HSB);
  fill(colprim, 255, 255, transp);
  colorMode(RGB);
}

//void drawperimeterlines(ArrayList <Zone> zones) {
//  for (Zone z1 : zones) {
//    FloatList linevals = new FloatList (z1.pt[0].x, z1.pt[1].x, z1.pt[0].y, z1.pt[1].y);
//    FloatList pointsvals [] = new FloatList [4];
//    pointsvals [0] = new FloatList  (z1.pt[0].y, z1.pt[1].y);
//    pointsvals [1] = new FloatList  (z1.pt[0].y, z1.pt[1].y);
//    pointsvals [2] = new FloatList  (z1.pt[0].x, z1.pt[1].x);
//    pointsvals [3] = new FloatList  (z1.pt[0].x, z1.pt[1].x);
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(0)==z2.pt[1].x))  pointsvals[0].append(z2.pt[0].y);  
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(0)==z2.pt[1].x))  pointsvals[0].append(z2.pt[1].y); 
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(1)==z2.pt[0].x))  pointsvals[1].append(z2.pt[0].y);  
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(1)==z2.pt[0].x))  pointsvals[1].append(z2.pt[1].y); 
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(2)==z2.pt[1].y))  pointsvals[2].append(z2.pt[0].x);  
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(2)==z2.pt[1].y))  pointsvals[2].append(z2.pt[1].x); 
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(3)==z2.pt[0].y))  pointsvals[3].append(z2.pt[0].x);  
//    for (Zone z2 : zones) if (z1.id[1]!=z2.id[1]) if ((linevals.get(3)==z2.pt[0].y))  pointsvals[3].append(z2.pt[1].x); 
//    for (int s=0; s<4; s++) pointsvals[s].sort();
//    for (int s=0; s<2; s++) for (int i=0; i<pointsvals[s].size(); i++) if (i%2==0) line(scgrfx(linevals.get(s)), scgrfy(pointsvals[s].get(i)), scgrfx(linevals.get(s)), scgrfy(pointsvals[s].get(i+1)));
//    for (int s=2; s<4; s++) for (int i=0; i<pointsvals[s].size(); i++) if (i%2==0)  line( scgrfx(pointsvals[s].get(i)), scgrfy(linevals.get(s)), scgrfx(pointsvals[s].get(i+1)), scgrfy(linevals.get(s)));
//  }
//}
