UI ui;

boolean drawFurniture = true;
boolean ShowButtons = false;
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
  int page = 0;
  PFont fontBold;
  PFont fontRegular;
  PFont fontThin;
  PImage mimaImg1;
  ArrayList<Click> clicks;
  ArrayList<Toggle> toggles;
  ArrayList<Click> roomClicks;
  ShapeCreator shape;
  UI() {
    fontBold = createFont("NotoSans-Medium.ttf", 18*scand);
    fontRegular = createFont("NotoSans-Light.ttf", 12*scand);
    fontThin = createFont("NotoSans-Thin.ttf", 12*scand);
    mimaImg1 = loadImage("mimaImg1.png");
    clicks = new ArrayList<Click> ();

    clicks.add(new Click(new PVector(width-50*scand, height/2-30*scand), new PVector(30, 50), "next", 32)); //0
    clicks.add(new Click(new PVector(width/2-0*scand, height-120*scand), new PVector(40, 50), "Start", 31));//1
    clicks.add(new Click(new PVector(width / 2-50*scand, height/4-0*scand), new PVector(100, 50), "Click here", 40));//2

    clicks.add(new Click(new PVector(width / 2-150*scand, height/2+25*scand), new PVector(300, 50), "Draw", 41));//3
    clicks.add(new Click(new PVector(width / 2-150*scand, height/2+80*scand), new PVector(300, 50), "Erase", 40));//4
    clicks.add(new Click(new PVector(width / 2-150*scand, height*0.75+300*scand), new PVector(300, 50), "Furniture", 40));//5
    clicks.add(new Click(new PVector(width / 2-150*scand, height-60*scand), new PVector(300, 50), "Done", 40));//6
    clicks.add(new Click(new PVector(width / 2-180*scand, height-60*scand), new PVector(360, 60), "+", 40));//7

    clicks.add(new Click(new PVector(width / 2-180*scand, height-60*scand), new PVector(360, 60), "x", 40));//8

    roomClicks = new ArrayList<Click> ();

    roomClicks.add(new Click(new PVector(0*scand, height*0.5+0*scand), new PVector(120, 85), "Bedroom", 20));
    roomClicks.add(new Click(new PVector(120*scand, height*0.5+0*scand), new PVector(120, 85), "Bathroom", 20));
    roomClicks.add(new Click(new PVector(240*scand, height*0.5+0*scand), new PVector(120, 85), "Master bedroom", 20));

    roomClicks.add(new Click(new PVector(0*scand, height*0.5+85*scand), new PVector(120, 85), "Dinning room", 20));
    roomClicks.add(new Click(new PVector(120*scand, height*0.5+85*scand), new PVector(120, 85), "Kitchen", 20));
    roomClicks.add(new Click(new PVector(240*scand, height*0.5+85*scand), new PVector(120, 85), "Laundry", 20));

    roomClicks.add(new Click(new PVector(0*scand, height*0.5+170*scand), new PVector(120, 85), "Living room", 20));
    roomClicks.add(new Click(new PVector(120*scand, height*0.5+170*scand), new PVector(120, 85), "Closet", 20));
    roomClicks.add(new Click(new PVector(240*scand, height*0.5+170*scand), new PVector(120, 85), "Other", 20));

    String secName[] = {"Be","Ba","Ma","Di","Ki","La","Li","Cl","Ot"};
    for (int i=0; i<roomClicks.size(); i++) {
      roomClicks.get(i).secondaryName = secName[i];
      roomClicks.get(i).coff = 100;
      roomClicks.get(i).textsize = 14;
    }

    for (int i=0; i<clicks.size(); i++) {
      clicks.get(i).coff = 0;
      clicks.get(i).textsize = 17;
    }
    clicks.get(7).textsize = 22;
    clicks.get(8).textsize = 18;
    clicks.get(0).icon =18;
    clicks.get(1).icon =19;

    toggles = new ArrayList<Toggle> ();
    toggles.add(new Toggle(new PVector(width / 2+40*scand, height*0.75+20*scand), new PVector(20, 20), "Furniture", 10));  // Toggle(PVector _pos, PVector _size, String _name, int _type)


    toggles.get(0).textsize = 17;
    toggles.get(0).coff = 0;
    setupgr();
    shape = new ShapeCreator(new PVector (0.8, 0.8), new PVector (6.4, 6.4));
  }
  void display() {

    if (page==0) page0();
    if (page==1) page1();
    if (page==2) page2();
    if (page==3) page3();
    if (page==4) page4();
    if (page==5) page5();
    if (page==6) page6();
    fill(255, 0, 0);
    text(page, 5, 15);
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
    rect(0, 0, width, 60*scand);
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
    toggles.get(0).display();
    clicks.get(3).display();
    clicks.get(4).display();
    //clicks.get(5).display();
    clicks.get(6).display();
  }
  void page5() {
    fill(240);
    noStroke();
    rect(0, 0, width, 60*scand);
    rect(0, height - (60*scand), width, (60*scand));
    fill(0);
    PVector logopos = new PVector(width / 2, 30*scand);
    this.logo(logopos);
    drawgr();
    drawho();
    textFont(fontRegular);
    textSize(15);
    fill(50);

    textAlign(LEFT, CENTER);
    text("Add rooms apply Smart Animate", 30*scand, height-160*scand);
    text("to entire objects or, as well as", 30*scand, height-140*scand);
    text("individual layers within a", 30*scand, height-120*scand);
    text("Component or Group.", 30*scand, height-100*scand);

    clicks.get(7).display();
  }

  void page6() {
    fill(240);
    noStroke();
    rect(0, 0, width, 60*scand);
    rect(0, height - (70*scand), width, (70*scand));
    fill(0);
    PVector logopos = new PVector(width / 2, 30*scand);
    this.logo(logopos);
    drawgr();
    drawho();
    textFont(fontRegular);
    textSize(15);
    fill(50);
    clicks.get(8).display();
    for (int i=0; i<roomClicks.size(); i++) {
      roomClicks.get(i).display();
    }
  }
  void pressadddrooms() {
    for (int a=0; a<roomClicks.size(); a++) roomClicks.get(a).presson(); 
      for (int a=0; a<roomClicks.size(); a++) if (roomClicks.get(a).state) {
         rooms = addtostarr(rooms, roomClicks.get(a).name);
         rooms = subtostarr(rooms, roomClicks.get(a).name);
        reinserthouse();
  }
  for (int a=0; a<roomClicks.size(); a++) roomClicks.get(a).pressoff();
}


  void logo(PVector _pos) {
    rectMode(CENTER);
    rect(_pos.x - 8*scand, _pos.y, 3*scand, 20*scand);
    rect(_pos.x + 8*scand, _pos.y, 3*scand, 20*scand);
    ellipse(_pos.x, _pos.y, 3*scand, 3*scand);
  }
  void press() {
    for (Toggle t : toggles) t.press();
    for (Click c : clicks) c.presson();

    if (clicks.get(8).state && page==6) {
      page--;
      clicks.get(7).state = false;
    }
    if (clicks.get(7).state && page==5) {
      page++;
      clicks.get(8).state = false;
    }
    if (clicks.get(6).state && page==4) {
      page++;
      ArrayList<Zone> zones = new ArrayList <Zone>(); 
      zones.add(new Zone(shape.Position, shape.End));
      setuphoinedges(zones); 
      recalctree();
      recalchouse();
    }
    if (clicks.get(2).state && page==3) page++;
    if (clicks.get(1).state && page==2) page++;
    if (clicks.get(0).state && page==1) page++;
    for (Click c : clicks) c.pressoff();
        for (Click c : roomClicks){
          //c.presson();
          
          //if (c.state){
          //  println(rooms);
          //  println(addrooms[0].namei);
          //  println(roomDATAIN[addrooms[0].namei][0]);
          //rooms = addtostarr(rooms, roomDATAIN[addrooms[0].namei][0]);
          //rooms = subtostarr(rooms, rooms[addrooms[1].namei]);
          //reinserthouse();
            //println(c.secondaryName);
          //}

          c.pressoff();
        }
        
            for (Click c : roomClicks) c.presson();
    for (Click c : roomClicks) if (c.state){
      
    }
    for (Click c : roomClicks) c.pressoff();
    shape.press();

    drawFurniture = toggles.get(0).state;
    pressadddrooms();
  }
}
