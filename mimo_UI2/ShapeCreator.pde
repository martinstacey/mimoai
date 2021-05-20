class ShapeCreator {
  PVector Position;
  PVector End;

  ArrayList<CornerButtons> cornerButtons;
  ShapeCreator(PVector position, PVector end) {
    Position = position;
    End = end;
    calculateCorners();
  }
  void calculateCorners() {
    ArrayList<PVector> corners = new ArrayList<PVector>();
    corners.add(Position);
    corners.add(new PVector(End.x, Position.y));
    corners.add(End);
    corners.add(new PVector(Position.x, End.y));
    cornerButtons = new ArrayList<CornerButtons>();
    for (int i=0; i<corners.size(); i++)
      cornerButtons.add(new CornerButtons(corners.get(i), i));
  }
  void display() {
    pushStyle();
    changeSizeOfHouse();

    rectMode(CORNERS);
    fill(200, 100);

    rect(scgr(Position).x, scgr(Position).y, scgr(End).x, scgr(End).y);
    for (int i=0; i<cornerButtons.size(); i++)
      cornerButtons.get(i).display();

    popStyle();
  }
  void press() {
    for (int i=0; i<cornerButtons.size(); i++) {
      cornerButtons.get(i).press();
    }
  }
  void changeSizeOfHouse() {
    if (cornerButtons.get(0).Select) {
      Position = cornerButtons.get(0).Position;
      cornerButtons.get(1).Position.y = cornerButtons.get(0).Position.y;
      cornerButtons.get(3).Position.x = cornerButtons.get(0).Position.x;
    }
    if (cornerButtons.get(1).Select) {
      Position.y = cornerButtons.get(1).Position.y;
      End.x = cornerButtons.get(1).Position.x;
      cornerButtons.get(0).Position.y = cornerButtons.get(1).Position.y;
      cornerButtons.get(2).Position.x = cornerButtons.get(1).Position.x;
    }
    
    
    
    if (cornerButtons.get(2).Select) {
      End = cornerButtons.get(2).Position;
      cornerButtons.get(1).Position.x = cornerButtons.get(2).Position.x;
      cornerButtons.get(3).Position.y = cornerButtons.get(2).Position.y;
    }
        if (cornerButtons.get(3).Select) {
      Position.x = cornerButtons.get(3).Position.x;
      End.y = cornerButtons.get(3).Position.y;
      cornerButtons.get(0).Position.x = cornerButtons.get(3).Position.x;
      cornerButtons.get(2).Position.y = cornerButtons.get(3).Position.y;
    }
  }
  PVector Size() {
    return new PVector (End.x- Position.x, End.y-Position.y);
  }
}

class CornerButtons {
  PVector Position;
  PVector Size;
  boolean Select;
  int Corner;
  CornerButtons(PVector position, int corner) {
    Position = position;
    Size = new PVector(0.3, 0.3);
    Corner = corner;
  }
  void display() {
    fill(40);
    noStroke();
    if (Select) fill(100);
    ellipse(scgr(Position).x, scgr(Position).y, scsif(Size.x), scsif(Size.y));
    if (Select) ellipse(scgr(Position).x, scgr(Position).y, scsif(Size.x)*2, scsif(Size.y)*2);
    if (Select) {
      PVector mouse =  mouseshrink(new PVector(mouseX, mouseY));
      Position = mouse;
    }
  }
  boolean isOver() {
    PVector mouse =  mouseshrink(new PVector(mouseX, mouseY));
    boolean Xis = Position.x-(Size.x*2)< mouse.x &&  mouse.x < (Position.x + Size.x*2) ;
    boolean Yis = Position.y-(Size.y*2)< mouse.y &&  mouse.y < (Position.y + Size.y*2) ;    
    return Xis && Yis;
  }
  void press() {
    if (isOver()) Select = !Select;
  }
}
