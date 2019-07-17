Slider sl [][];
Option en [];
Textrect tx [], tti [];
Toggle lk [];
Toggle dr;
Click evo;
Option addrooms[];
PVector uipos = new PVector (50, 10);
PVector uisize = new PVector (70, 30);
int slcolumns[][] = {{2, 3, 4}, {5, 6, 7}};  //[0-1][]: 0:area 1:width [][0-2] 0:ideal 1:min 2:max 

int frcount = 0;
int frcoutstop = 10;
boolean frcountrun = false;

void recalctree() {
  setuptr();
  setupid();
  setupdraw();
  setupga();
}

void recalchouse() {
  changeroomDATA();
  setupid();
  setupdraw();
}
void reinserthouse() {
  roomDATA=getroomDATA(rooms, roomDATAIN);
  lockgenes = getroomLOCKS(rooms, lockIN);
  setupsl(rooms, roomDATA);
  setupho();
  setuptr();
  setupid();
  setupdraw();
  setupga();
}
void evolveon() {
  setupga();
  evolve = true;
}
void evolveoff() {
  if (frameCount%90==0) evolve = false;
}

void setupsl(String [] rooms, String [][] roomDATA) {
  String ttis [] = {"", "Area", "Width", "Entry"};
  tti = new Textrect [ttis.length];
  for (int i=0; i<tti.length; i++) tti[i] = new Textrect (new PVector (uipos.x+i*uisize.x, uipos.y), uisize, ttis[i], 10);
  for (int i=0; i<tti.length; i++) tti[i].scaletoandroid(scand);
  lk = new Toggle [rooms.length];  
  for (int l=0; l<lk.length; l++)   lk[l]= new Toggle(new PVector (uipos.x-uisize.x*.5, uipos.y+l*uisize.y+uisize.y), new PVector (uisize.y, uisize.y), "candado" + l, 50);
  for (int l=0; l<lk.length; l++)   lk[l].scaletoandroid(scand);
  tx = new Textrect [rooms.length];
  for (int i=0; i<tx.length; i++) tx[i] = new Textrect (new PVector (uipos.x, uipos.y+uisize.y+uisize.y*i), new PVector (uisize.x, uisize.y), roomideals(rooms[i], 1, roomDATA), 10);
  for (int i=0; i<tx.length; i++) tx[i].scaletoandroid(scand);
  sl = new Slider [2][rooms.length];
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++)  sl[s][i] = new Slider(new PVector (uipos.x+s*uisize.x+uisize.x*1.25, uipos.y+uisize.y*2.1+uisize.y*i), new PVector (uisize.x*.45, 200), roomideals(rooms[i], 0, roomDATA), 11, 0, float(roomideals(rooms[i], slcolumns[s][0], roomDATA)), min0max1roomDATA(slcolumns[s][2], roomDATA, 1));
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++)  sl[s][i].flt = .8;
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) sl[s][i].addstops(float(roomideals(rooms[i], slcolumns[s][1], roomDATA)), float(roomideals(rooms[i], slcolumns[s][2], roomDATA)));
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) sl[s][i].scaletoandroid(scand);
  en = new Option [rooms.length];
  for (int l=0; l<en.length; l++) en[l] = new Option(new PVector (uipos.x+2*uisize.x+uisize.x, uipos.y+l*uisize.y+uisize.y+5), new PVector (uisize.x*1, uisize.y), roomsSINroom(rooms, l), 12); 
  for (int l=0; l<en.length; l++) en[l].namei = roomidealadj(rooms, rooms[l], roomDATA, 9); //buscar room seleccionado
  for (int l=0; l<en.length; l++) en[l].calcpos();
  for (int l=0; l<en.length; l++) en[l].scaletoandroid(scand);  
  addrooms = new Option [2];
  addrooms[0] = new Option(new PVector (30, height/scand-80), new PVector (30, 30), roomcodedeDATAIN(roomDATAIN), 13);
  addrooms[1] = new Option(new PVector (30, height/scand-40), new PVector (30, 30), rooms, 13);
  addrooms[0].icon = 2;
  addrooms[1].icon = 9;
  for (int l=0; l<addrooms.length; l++) addrooms[l].con = 150;
  for (int l=0; l<addrooms.length; l++) addrooms[l].scaletoandroid(scand);
  evo = new Click(new PVector (width*.5/scand-uisize.x, height/scand-uisize.y*1.5), new PVector (uisize.x, uisize.y), "design", 20);
  evo.scaletoandroid(scand);
  dr = new Toggle(new PVector (width/scand-uisize.x, height/scand-uisize.y*2), new PVector (uisize.y, uisize.y), "draw perimeter", 20);
  dr.icon = 6;
  dr.scaletoandroid(scand);
}
void drawsl() {
  for (int i=0; i<tti.length; i++) tti[i].display();
  for (int l=0; l<lk.length; l++)  lk[l].display();
  for (int i=0; i<tx.length; i++) tx[i].display();
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) sl[s][i].display();
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (!sl[s][i].otherselectarr(sl[s])) sl[s][i].display();
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (sl[s][i].drag) recalchouse();// changeroomDATA();
  for (int i=0; i<en.length; i++) en[i].display();
  for (int i=0; i<en.length; i++) if (!en[i].otherselectarr(en)) en[i].display();
  for (int a=0; a<addrooms.length; a++) addrooms[a].display();
  evo.display();
  evolveoff();
  dr.display();
  //for (int s=0; s<roomDATA.length; s++) for (int i=0; i<roomDATA[s].length; i++) text(roomDATA[s][i],300+i*20,30+s*20);
}
void presssl() {
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (!sl[s][i].otherselectarr(sl[s])) sl[s][i].press();                   //slider press
  for (int i=en.length-1; i>=0; i--) if (!en[i].otherselectarr(en)) en[i].press();
  for (int i=en.length-1; i>=0; i--) if (!en[i].state) for (int j=0; j<en[i].names.length; j++) if (en[i].isoveri()[j]) recalchouse();
  for (int l=0; l<lk.length; l++) lk[l].press();
  for (int l=0; l<lk.length; l++) if (lk[l].isover()) lockpress(rooms); 
  evo.presson();
  if (evo.state) evolveon();
  evo.pressoff();
  dr.press();
}

void lockpress(String [] rooms) {
  boolean onelockselect = false;
  for (int l=0; l<lk.length; l++) if (lk[l].state) onelockselect = true; 
  int pmin = getngnum("pmin", rooms.length);
  int pmax = getngnum("pmax", rooms.length);
  int lmin = getngnum("lmin", rooms.length);
  int lmax = getngnum("lmax", rooms.length);
  int smin = getngnum("smin", rooms.length);
  int smax = getngnum("smax", rooms.length);
  if (!onelockselect)  for (int i=pmin; i<pmax; i++) lockgenes[i] = 0;    //genes permutation  a 0
  if (!onelockselect)  for (int i=lmin; i<lmax; i++) lockgenes[i] = 0;    //genes locationtree a 0         //seguro si se pudieran cambiar a unos?????
  if (onelockselect)   for (int i=pmin; i<pmax; i++) lockgenes[i] = 1;    //genes permutation  a 1
  if (onelockselect)   for (int i=lmin; i<lmax; i++) lockgenes[i] = 1;    //genes locationtree a 1
  for (int i=smin; i<smax; i++) lockgenes[i] = 0;                         //todos los genes se hacen 0
  for (int l=0; l<lk.length; l++) if (lk[l].state) {
    for (int n=0; n<ho.no.size(); n++) if (txequal(ho.no.get(n).code, rooms[l])) {
      for (int i=smin; i<smax; i++) {
        if (ho.ng[i].loc.length()<ho.no.get(n).loc.length()) if (txequal(ho.ng[i].loc, ho.no.get(n).loc.substring(0, ho.ng[i].loc.length()))) lockgenes[i] = 1;
     
    }
    }
  }
  
  
  recalctree();
}
void pressadddrooms() {
  for (int a=0; a<addrooms.length; a++) addrooms[a].press(); 
  for (int a=0; a<addrooms.length; a++) if (addrooms[a].namei!=-1) {
    if (addrooms[0].namei!=-1) rooms = addtostarr(rooms, roomDATAIN[addrooms[0].namei][0]);
    if (addrooms[1].namei!=-1) rooms = subtostarr(rooms, rooms[addrooms[1].namei]);
    reinserthouse();
  }
  for (int a=0; a<addrooms.length; a++) addrooms[a].pressoff();
}
void releasesl() {
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) if (!sl[s][i].otherselectarr(sl[s])) sl[s][i].release();
}
void changeroomDATA() {
  for (int s=0; s<sl.length; s++) for (int i=0; i<sl[s].length; i++) roomDATA [i][slcolumns[s][0]] = sl[s][i].value+"";
  for (int i=0; i<en.length; i++) roomDATA [i][9] = en[i].names[en[i].namei];
  grscaleDEhouse(ho);
}
