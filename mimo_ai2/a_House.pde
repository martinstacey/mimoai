House ho;

void setupho() {
  ArrayList <Zone> homedges= new ArrayList <Zone> ();
  homedges.add(new Zone (new PVector(0, 0), new PVector(1, 1)));
  //homedges.add(new Zone (new PVector(0, 0), new PVector(.5, 1)));
  //homedges.add(new Zone (new PVector(.5, .1), new PVector(1, .9)));
  ho = new House(rooms, homedges);
}

void setuphoinedges(ArrayList <Zone> homedges){
    ho = new House(rooms, homedges);
}
void setuptr() {
  ho.setuptr(lockgenes);
}
void setupid() {
  ho.setupid();
}
void setupdraw() {
  ho.setupdraw();
}
void setupga() {
  ho.setuphoga();
}
void drawho() {
  //ho.displaytree();
  
  if (!dr.state) ho.displayhouse();
   if (!dr.state) scoreshow(new PVector(width*.75-(50*scand), 20*scand), new PVector (100*scand, 10*scand), int((10-ho.totfit)*10), 150, 255);
}
void pressho() {
  ho.press();
}
void typeho() {
  ho.type();
}
class House {
  String [] rooms;
  float permgene, locgene[], subgene[], totfit;
  ArrayList <Node> no;
  int nrooms, ngenes;
  PVector treesize = new PVector(180*scand, 30*scand);
  PVector treepos = new PVector(600*scand, 250*scand);
  ArrayList <Zone> homedges;
  Nodegene [] ng;
  Population p;
  Atribute [] at;
  House(String [] _rooms, ArrayList <Zone> _homedges) {
    rooms = _rooms;
    nrooms = rooms.length;
    ngenes =min0(nrooms-2)+1+min0(nrooms-1);
    locgene= new float [min0(rooms.length-2)];
    subgene= new float [min0(rooms.length-1)];
    homedges=_homedges;
    ng = new Nodegene [ngenes];
    for (int i=getngnum("lmin", nrooms); i<getngnum("lmax", nrooms); i++) ng[i] = new Nodegene ("l", 0, false, new PVector(treepos.x-treesize.x, treepos.y+i*15*scand));
    for (int i=getngnum("pmin", nrooms); i<getngnum("pmax", nrooms); i++) ng[i] = new Nodegene ("p", 0, false, new PVector(treepos.x-treesize.x, treepos.y+i*15*scand));
    for (int i=getngnum("smin", nrooms); i<getngnum("smax", nrooms); i++) ng[i] = new Nodegene ("s", 0, false, new PVector(treepos.x-treesize.x, treepos.y+i*15*scand));
    insertgenes(ranflarr(ngenes, 0, 1));
  }
  House clonenewgenes(float [] genes) {        
    House clone = new House(clonestarr(rooms), clonezonelist(homedges));
    clone.ng = clonengarrwithgenes(ng, genes);
    clone.setuptr(lockgenes);
    clone.setupid();
    clone.setupdraw();
    return clone;
  }
  void setuptr(int [] lockgenes) {
    insertbgenes(lockgenes);
    calctree();
    calcrela();
  }
  void setupid() {
    calcideal();
    calchouse();
    strechzones();
    calcborders();
    calcreals();
    calcsubparamminmax();
    calchouse();
    strechzones();
    calcborders();
    calcreals();
    calcfit();
  }
  void setupdraw() {
    calcbordertypes();
    calcmuebles();
  }
  void insertgenes(float geneins[]) {   
    if (geneins.length<ng.length)  for (int i=0; i<geneins.length; i++) if (!ng[i].inactive) ng[i].value = geneins[i];
    if (geneins.length>=ng.length) for (int i=0; i<ng.length; i++)      if (!ng[i].inactive) ng[i].value = geneins[i];
  }
  void insertbgenes(int genebins[]) { 
    if (genebins.length<ng.length)  for (int i=0; i<genebins.length; i++) ng[i].inactive = boolean(genebins[i]);
    if (genebins.length>=ng.length) for (int i=0; i<ng.length; i++)       ng[i].inactive = boolean(genebins[i]);
  } 
  void calctree() {
    no = nodecrea(rooms, ngvalues(ng, getngnum("lmin", nrooms), getngnum("lmax", nrooms)));
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) no.get(n).code = permutation01(rooms, ngvalue(ng, getngnum("pmin", nrooms)))[no.get(n).leafi];
    for (int n=0; n<no.size(); n++) if (!no.get(n).isleaf) no.get(n).subparam[0] = roundit(ngvalue(ng, no.get(n).inneri+getngnum("smin", nrooms)), 2)+"";
    for (int n=0; n<no.size(); n++) if (!no.get(n).isleaf) ng[no.get(n).inneri+getngnum("smin", nrooms)].loc = no.get(n).loc; //nombrar loc de ngs
    for (int n=0; n<no.size(); n++) no.get(n).ischilda = ifischilda(no.get(n).loc);
    for (int n=0; n<no.size(); n++) no.get(n).calcnodepos(treepos, treesize);
  }
  void calcrela() {
    for (int n=0; n<no.size(); n++) no.get(n).father = calcrelative(no.get(n), no, "father");
    for (int n=0; n<no.size(); n++) no.get(n).childa = calcrelative(no.get(n), no, "childa");
    for (int n=0; n<no.size(); n++) no.get(n).childb = calcrelative(no.get(n), no, "childb");
    for (int n=0; n<no.size(); n++) no.get(n).brother =calcrelative(no.get(n), no, "brother");
  }
  void calcideal() {
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int i=0; i<no.get(n).ideals.length; i++) no.get(n).ideals[i] = roomideals(no.get(n).code, i, roomDATA); //0:Code, 1:Name 2:area 3:minW 4:maxW 5:prop 6:conect
    for (int n=no.size()-1; n>=0; n--) if (!no.get(n).isleaf) no.get(n).ideals[2] = (float(no.get(n).childa.ideals[2])+float(no.get(n).childb.ideals[2]))+"";
    for (int n=0; n<no.size(); n++) if (no.get(n).father!=null) no.get(n).subparam[1] = roundit(float(no.get(n).ideals[2])/float(no.get(n).father.ideals[2]), 2)+"";
  }
  void calchouse() {
    no = calcallzones(no, homedges);
  }
  void calcborders() {
    for (int n=0; n<no.size(); n++) for (int z=0; z<no.get(n).zones.size(); z++) no.get(n).zones.get(z).borders = borderDEzones(no.get(n).zones.get(z), no);
  }
  void calcreals() { //0 :code 1:name 2: area 3:minW
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) no.get(n).reals[2] = nf(no.get(n).zones.get(z).area(), 1, 2)+"";   //area
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) no.get(n).reals[6] = nf(no.get(n).zones.get(0).zwidth(), 1, 2)+"";                //minwidth
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) no.get(n).reals[7] = nf(no.get(n).zones.get(0).zwidth(), 1, 2)+"";                //maxwidth
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) for (int b=0; b<no.get(n).zones.get(z).borders.size(); b++) no.get(n).zones.get(z).borders.get(b).adj = caldadjborder(no.get(n).zones.get(z).borders.get(b), no);
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) no.get(n).reals[9]=adjlist(no, no.get(n));                                                           //reals adjlist
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) no.get(n).reals[8] = nf(no.get(n).zones.get(0).prop(), 1, 2)+"";
  }
  void strechzones() {
    scaleno(no, calcstrechfactor(no));
    gridno(no);
    //removeemptyzones(no);
  }
  void calcbordertypes() {
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) for (int z=0; z<no.get(n).zones.size(); z++) for (int b=0; b<no.get(n).zones.get(z).borders.size(); b++) no.get(n).zones.get(z).borders.get(b).id[4] = calcbordertype(no, no.get(n), no.get(n).zones.get(z).borders.get(b));                                                         //entry
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) calcbordertyperoom(no, no.get(n));
  }
  void calcmuebles() {
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0) no.get(n).muebles = calcmuebleslist((no.get(n)));
  }
  void recalc0zones() {
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf)  if (no.get(n).zones.size()>0)  if (no.get(n).zones.get(0).xdim()==0) if (ischildx(float(no.get(n).father.subparam[0]))) {
      float newper = grunit/no.get(n).father.zones.get(0).xdim();
      no.get(n).subparam[1] = newper + "";
      no.get(n).brother.subparam[1] = (1-newper)+"";
    }
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf)  if (no.get(n).zones.size()>0)  if (no.get(n).zones.get(0).ydim()==0) if (!ischildx(float(no.get(n).father.subparam[0]))) {
      float newper = grunit/no.get(n).father.zones.get(0).ydim();
      no.get(n).subparam[1] = newper + "";
      no.get(n).brother.subparam[1] = (1-newper)+"";
    }
  }
  void calcsubparamminmax() {
    for (int n=0; n<no.size(); n++) if (no.get(n).isleaf) if (no.get(n).zones.size()>0)   if (float(no.get(n).ideals[7])<float(no.get(n).reals[7])||(float(no.get(n).ideals[6])>float(no.get(n).reals[6]))) {
      //if (float(no.get(n).ideals[6])>float(no.get(n).reals[6])) println(no.get(n).ideals[0]+ ": width too small");
      //if (float(no.get(n).ideals[7])<float(no.get(n).reals[7])) println(no.get(n).ideals[0]+ ": width too big");
      boolean childx = ischildx(float(no.get(n).father.subparam[0]));
      boolean lengthisx = no.get(n).zones.get(0).lengthisx();  
      if ((childx&&!lengthisx)||(!childx&&lengthisx)) {
        float newper = roundit(float(no.get(n).ideals[6])/no.get(n).father.zones.get(0).xdim(), 2);
        no.get(n).subparam[1] = newper + "";
        no.get(n).brother.subparam[1] = (1-newper)+"";
      }
    }
  }
  void calcfit() {
    totfit=0;
    totfit += calctotpropfit(no, 5);
    totfit += calctotadjfit(no, 50);
    totfit +=calcmissingzonesfit(no, 300);
    totfit+=calcclosetinbetween(no, 1000);
  }
  void displaytree() {
    for (int n=0; n<ng.length; n++) ng[n].display();
    for (int n=0; n<no.size(); n++) no.get(n).displaynodetree();
    fill(255, 0, 0);
    text(totfit, treepos.x, treepos.y-20);
  }
  void displayhouse() {
    //for (int h=0; h<homedges.size(); h++) homedges.get(h).displaycolor();
    for (int n=0; n<no.size(); n++) no.get(n).displaymuebles();
    for (int n=0; n<no.size(); n++) no.get(n).displayrooms();
  }

  void press() {
    for (int i=0; i<ng.length; i++) ng[i].press();
  }
  void type() {
    if (key=='q') for (Nodegene n : ng) n.scroll(true);
    if (key=='w') for (Nodegene n : ng)  n.scroll(false);
    if (key=='a') for (Nodegene n : ng)  n.activateit(true);
    if (key=='q'||key=='w') setuptr(lockgenes);
    if (key=='q'||key=='w') setupid();
    //float [] ranval = genranvals(ho.nofnodegenes, 0, 1);
    //if (key=='m') moverandom(ranval);
    //if (key=='q'||key=='w'||key=='a') calcrooms();
  }
  void setuphoga() {
    at = new Atribute [ngenes];           
    for (int i=0; i<at.length; i++) at[i] = new Atribute ("g"+i, 0, 1);
    int nPopX= 10;  //25
    int nPopY = 10;  //25
    int popSize = nPopX*nPopY;
    p = new Population(this, popSize, at);
  }
  void evolvehoga() {
    p.evolve(this);                                                                                 //Population Evolve (every 10 frameCounts)
  }
  void drawho1ga(int ind) {
    House temph  = this.clonenewgenes(p.pop[ind].phenos);
    temph.displayhouse();
  }
  Nodegene [] clonengs(int ind) {
    House temph = this.clonenewgenes(p.pop[ind].phenos);
    return temph.ng;
  }
}
String [] roomcodedeDATAIN(String[][] roomDATA) {
  String stout [] = new String [roomDATA.length];
  for (int i=0; i<stout.length; i++) stout[i] = roomDATA[i][0];
  return stout;
}

String [] roomsSINroom(String[] roomsIN, int roomi) {
  String stout [] = new String [roomDATA.length];
  ArrayList <String> sto = new ArrayList <String>();
  for (int i=0; i<roomsIN.length; i++) {
    if (i!=roomi) sto.add(roomsIN[i]);
    else sto.add("");
  }  
  for (int i=0; i<sto.size(); i++) stout[i] = sto.get(i);
  return stout;
}
int roomidealadj(String [] rooms, String rcode, String[][] roomDATA, int coladj) {
  int iout =0;
  for (int i=0; i<rooms.length; i++) if (txequal(rooms[i], roomideals(rcode, coladj, roomDATA))) iout = i;
  return iout;
}

String roomideals (String rcode, int idealnum, String[][] roomDATA) {
  String stout = "0";
  boolean rfound = false; 
  for (int i=0; i<roomDATA.length; i++) if (txequal(roomnonumber(rcode), roomDATA[i][0])) {
    stout = roomDATA[i][idealnum]; 
    rfound = true;
  }
  if (!rfound) println("room not found");
  return stout;
}
String [] roomidealsall (String rcode, String[][] roomDATA) {
  String stout [] = new String [roomDATA[0].length];
  boolean rfound = false; 
  for (int i=0; i<roomDATA.length; i++) if (txequal(roomnonumber(rcode), roomDATA[i][0])) {
    stout = roomDATA[i]; 
    rfound = true;
  }
  if (!rfound) println("room not found");
  return stout;
}
String roomnonumber(String rcode){
  String stout = "";
  for (int i=0; i<rcode.length();i++) if (!Character.isDigit(rcode.charAt(i))) stout+=rcode.charAt(i);
  return stout;
}

String [] getroomNAMES(String [] rooms) { 
  String [] roomDATAout = new String [rooms.length];
  for (int i=0; i<rooms.length; i++) {
  roomDATAout [i] = rooms[i];
  int count = 0;
  for (int j=0; j<i; j++) if (txequal(rooms[i],rooms[j])) count++;
  if (count>0) roomDATAout [i] = rooms[i]+(count+1);   
  }
  return roomDATAout;
}
String [][] getroomDATA(String [] rooms, String [][] roomDATAin) { 
  String [][] roomDATAout = new String [rooms.length][];
  for (int i=0; i<rooms.length; i++) roomDATAout [i] = roomidealsall(rooms[i], roomDATAin);
  return roomDATAout;
}
float min0max1roomDATA(int cols, String [][] roomDATAin, int min0max1) {
  float minmaxf = float (roomDATAin[0][cols]); 
  if (min0max1==0)for (int i=0; i<roomDATAin.length; i++) if (float(roomDATAin[i][cols])<minmaxf) minmaxf = float(roomDATAin[i][cols]);
  if (min0max1==1) for (int i=0; i<roomDATAin.length; i++) if (float(roomDATAin[i][cols])>minmaxf) minmaxf = float(roomDATAin[i][cols]);
  return minmaxf;
}

int [] getroomLOCKS(String [] rooms, int [] bin) { 
  int [] iout = new int [1+min0(rooms.length-2)+min0(rooms.length-1)];  
  for (int i=0; i<bin.length; i++) if (i<rooms.length) iout [i] = bin [i];
  return iout;
}


void scoreshow(PVector pos, PVector size, float inscore, color coloron, color coloroff) {
  pushStyle();
  if (inscore<0) inscore = 0;
  stroke(150);
  fill(coloroff);
  rect(pos.x, pos.y, size.x, size.y, size.y/2);
  fill(coloron);
  rect(pos.x, pos.y, size.x*(inscore/100), size.y, size.y/2);
  fill(150);
  textAlign(CENTER, BOTTOM);
  text("score:"+int(inscore)+"%", pos.x+size.x*.5, pos.y); 
  popStyle();
}
