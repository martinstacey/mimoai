PVector grpos, grsize, usmouse, grmouse;
float grscale, grunit;

void setupgr() {
  grpos = new PVector(0*scand,60*scand);
  grsize= new PVector((width), (height*0.5)-(60*scand));
  grscale =40*scand;
  grunit =.8;
}
void drawgr() {
  rectMode(CORNER);
  strokeWeight(1);
  stroke(230);
  noFill();
  rect(grpos.x, grpos.y, grsize.x, grsize.y);
  float us = grunit*grscale;
  for (int x=0; x<=int(grsize.x/us); x++) for (int y=0; y<=int(grsize.y/us); y++) {
    noFill();
    if (x<int(grsize.x/us)&&y<int(grsize.y/us)) rect((x*us)+grpos.x, (y*us)+grpos.y, us, us);
    if ((x==int(grsize.x/us))&&(y<int(grsize.y/us))) rect((x*us)+grpos.x, (y*us)+grpos.y, grsize.x-(x*us), us);
    if ((y==int(grsize.y/us))&&(x<int(grsize.x/us))) rect((x*us)+grpos.x, (y*us)+grpos.y, us, grsize.y-(y*us));
  }
}
PVector scgr(PVector pos) {
  return  new PVector ((pos.x*grscale)+grpos.x, (pos.y*grscale)+grpos.y);
}
PVector inversescgr(PVector pos){
 return new PVector ((pos.x-grpos.x)/grscale, (pos.y-grpos.y)/grscale);
}
PVector mouseshrink(PVector pos){
      return new PVector (rg(inversescgr(pos).x), rg(inversescgr(pos).y));
}
float scgrfx(float pos) {
  return (pos*grscale)+grpos.x;
}
float scgrfy(float pos) {
  return (pos*grscale)+grpos.y;
}
float scsif(float pos) {
 return   pos*grscale;
}
float rg(float fin) {
  float fout = fin + grunit*.5;
  fout = roundit(fout-(fout%grunit), 2);
  return fout;
}
void grscaleDEhouse(House hoin){
  float grscaleX = grsize.x/housesizex0y1(ho,0);
  float grscaleY = grsize.y/housesizex0y1(ho,1);
  if (grscaleX<grscaleY) grscale = grscaleX;
  else grscale = grscaleY;
  //println("x:"+grsize.x/grscale+ " y:" +grsize.y/grscale);
  //println("x:"+housesizex0y1(ho,0) + " y:" + housesizex0y1(ho,1));
  
}
float housesizex0y1(House hoin, int x0y1){
  float vout = 0 ;
  if (x0y1==0) vout = hoin.homedges.get(0).pt[1].x;
  if (x0y1==1) vout = hoin.homedges.get(0).pt[1].y;
  if (x0y1==0) for (int i=0; i<hoin.homedges.size();i++) if (hoin.homedges.get(i).pt[1].x>vout) vout = hoin.homedges.get(i).pt[1].x;
   if (x0y1==1) for (int i=0; i<hoin.homedges.size();i++) if (hoin.homedges.get(i).pt[1].y>vout) vout = hoin.homedges.get(i).pt[1].y;   
  return vout;
}
