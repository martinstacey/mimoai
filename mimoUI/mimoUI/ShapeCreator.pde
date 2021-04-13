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
    changeSize();

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
    //if (cornerButtons.get(2).Select) End = cornerButtons.get(2).Position;
  }
  void changeSize() {
    if (cornerButtons.get(2).Select) {
      End = cornerButtons.get(2).Position;
      cornerButtons.get(1).Position.x = cornerButtons.get(2).Position.x;
      cornerButtons.get(3).Position.y = cornerButtons.get(2).Position.y; 
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
    Size = new PVector(0.4, 0.4);
    Corner = corner;
  }
  void display() {
    fill(40);
    noStroke();
    if (Select) fill(100);
    ellipse(scgr(Position).x, scgr(Position).y, scsif(Size.x), scsif(Size.y));
    if (Select) {
      PVector mouse =  mouseshrink(new PVector(mouseX, mouseY));
      Position = mouse;
    }
  }
  boolean isOver() {
    PVector mouse =  mouseshrink(new PVector(mouseX, mouseY));
    boolean Xis = Position.x-(Size.x)< mouse.x &&  mouse.x < (Position.x + Size.x) ;
    boolean Yis = Position.y-(Size.y)< mouse.y &&  mouse.y < (Position.y + Size.y) ;    
    return Xis && Yis;
  }
  void press() {
    if (isOver()) Select = !Select;
  }
}
