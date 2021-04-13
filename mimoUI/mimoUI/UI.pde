UI ui;
void setupUI() {
  ui = new UI();
  setupho();
  setuptr();
  setupid();
  setupdraw();
  setupsl(rooms, roomDATA);
  changeroomDATA();
  setupga();
  setupdz();
}
void drawUI() {
  ui.display();
}
void pressUI() {
  ui.press();
}


class UI {
  int page = 4;
  PFont fontBold;
  PFont fontRegular;
  PFont fontThin;
  PImage mimaImg1;
  ArrayList<Click> clicks;
  ShapeCreator shape;
  UI() {
    fontBold = createFont("NotoSans-Medium.ttf", 18*scand);
    fontRegular = createFont("NotoSans-Light.ttf", 12*scand);
    fontThin = createFont("NotoSans-Thin.ttf", 12*scand);
    mimaImg1 = loadImage("mimaImg1.png");
    clicks = new ArrayList<Click> ();
    clicks.add(new Click(new PVector(width-50*scand, height/2-30*scand), new PVector(30, 30), "next", 32)); //0
    clicks.add(new Click(new PVector(width/2-0*scand, height-120*scand), new PVector(40, 40), "Start", 31));//1
    clicks.add(new Click(new PVector(width / 2-50*scand, height/4-0*scand), new PVector(100, 40), "Click here", 40));//2

    clicks.add(new Click(new PVector(width / 2-100*scand, height/2+30*scand), new PVector(200, 40), "Draw", 41));//3
    clicks.add(new Click(new PVector(width / 2-100*scand, height/2+70*scand), new PVector(200, 40), "Erase", 40));//4
    clicks.add(new Click(new PVector(width / 2-100*scand, height*0.75), new PVector(200, 40), "Furniture", 40));//5
    clicks.add(new Click(new PVector(width / 2-100*scand, height-60*scand), new PVector(200, 40), "Done", 40));//6

    clicks.get(0).icon =18;
    clicks.get(1).icon =19;
    clicks.get(1).textsize =19;
    clicks.get(2).textsize =19;
    clicks.get(3).textsize =19;
    clicks.get(4).textsize =19;
    clicks.get(5).textsize =19;
    clicks.get(6).textsize =19;
    setupgr();
    shape = new ShapeCreator(new PVector (0.8, 0.8), new PVector (4, 4));
  }
  void display() {
    if (page==0) page0();
    if (page==1) page1();
    if (page==2) page2();
    if (page==3) page3();
    if (page==4) page4();
    if (page==5) page5();
  }
  void page0() {
    if (mousePressed && page==0) page++;
    textFont(fontBold);
    //textSize(18 * scand);
    noStroke();
    fill(0);
    PVector logopos = new PVector(width / 2, height / 2 - 60*scand);
    this.logo(logopos);
    textAlign(CENTER);
    text("M  I  M  A    H  O  U  S  I  N  G", width / 2, height / 2);
    text("AI", width / 2, height / 2 + 20*scand);
    textFont(fontRegular);
    text("Development by Martin Stacey", width / 2, height  * .5+55*scand);
    text("Design by Studio-Rana", width / 2, height  * .5+75*scand);
    textFont(fontThin);
    textSize(12 * scand);
    text("© Mima Housing 2021 - designed by Studio-Rana", width / 2, height - 30 * scand);
  }

  void page1() {

    image(mimaImg1, 0, 0, width, height);
    PVector logopos = new PVector(width / 2, 60*scand);
    fill(0);
    noStroke();
    this.logo(logopos);
    textFont(fontBold);
    textAlign(CENTER, CENTER);
    text("Architecture", width / 2, 100*scand);
    textFont(fontRegular);
    text("MIMA is a multidisciplinary office", width / 2, 140*scand);
    text("that focuses on the conception", width / 2, 160*scand);
    text("and retail of architectural", width / 2, 180*scand);
    text("products.", width / 2, 200*scand);

    clicks.get(0).display();
  }
  void page2() {
    PVector logopos = new PVector(width / 2, 60*scand);
    pushStyle();
    fill(0);
    noStroke();
    this.logo(logopos);
    textFont(fontBold);
    textAlign(CENTER, CENTER);
    text("Dynamic catalog", width / 2, 100*scand);
    textFont(fontRegular);
    text("Based on our architectural system", width / 2, 140*scand);
    text("developed with Martin", width / 2, 160*scand);
    text("Stacey", width / 2, 180*scand);
    text("We've isolated each of the.", width / 2, 220*scand);
    text("properties we support below, so", width / 2, 240*scand);
    text("you know what to expect.", width / 2, 260*scand);
    fill(240);
    rectMode(CORNER);

    rect(0, height-200*scand, width, 200*scand);
    textFont(fontBold);
    clicks.get(1).display();
    popStyle();
  }
  void page3() {
    fill(240);
    noStroke();
    rect(0, 0, width, 50*scand);
    fill(0);
    PVector logopos = new PVector(width / 2, 30*scand);
    this.logo(logopos);
    drawgr();
    textFont(fontRegular);
    textSize(15);
    fill(50);
    textAlign(LEFT, CENTER);
    text("Click on the grid back apply Smart", 30*scand, height-100*scand);
    text("Animate to entire objects or, as", 30*scand, height-80*scand);
    text("well as individual layers within a", 30*scand, height-60*scand);
    text("Component or Group.", 30*scand, height-40*scand);
    clicks.get(2).display();
    
  }
  void page4() {
    fill(240);
    noStroke();
    rect(0, 0, width, 60*scand);
    rect(0, height*0.5, width, height*0.5);
    fill(0);
    PVector logopos = new PVector(width / 2, 30*scand);
    this.logo(logopos);
    drawgr();
    shape.display();
    clicks.get(3).display();
    clicks.get(4).display();
    clicks.get(5).display();
    clicks.get(6).display();
  }
  void page5() {
    fill(240);
    noStroke();
    rect(0, 0, width, 60*scand);
    rect(0, height*0.5, width, height*0.5);
    fill(0);
    PVector logopos = new PVector(width / 2, 30*scand);
    this.logo(logopos);
    drawgr();
     drawho();
  }

  void logo(PVector _pos) {
    rectMode(CENTER);
    rect(_pos.x - 8*scand, _pos.y, 3*scand, 20*scand);
    rect(_pos.x + 8*scand, _pos.y, 3*scand, 20*scand);
    ellipse(_pos.x, _pos.y, 3*scand, 3*scand);
  }
  void press() {
    for (Click c : clicks) c.presson();
    if (clicks.get(0).state && page==1) page++;
    if (clicks.get(1).state && page==2) page++;
    if (clicks.get(2).state && page==3) page++;
    if (clicks.get(6).state && page==4) {
      page++;
      ArrayList<Zone> zones = new ArrayList <Zone>(); 
      zones.add(new Zone(shape.Position, shape.End));
      setuphoinedges(zones); 
      recalctree();
      recalchouse();
    }
    for (Click c : clicks) c.pressoff();
    shape.press();
    
  }
}
