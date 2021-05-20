//tratar de ordenar cuando se setupid setuptr setupga y quitar despues setupdraw de clonacion
boolean inandroid = false;
boolean keybisopen = false;
float scand = 1;
String [] roomsIN =  { "Be","Ba"};
//String [] roomsIN =  {"Li", "Be", "Ba", "Ki"};
//String [] rooms = {"Li", "Be", "Ba", "Ki"};  //0:code 1:name 2:area
//String [] rooms = {"Be","Ki"};
int [] lockIN = {0, 0};
String [][] roomDATAIN={{"Be", "Bedroom", "14.4", "8.8", "24.0", "4.0", "3.2", "4.8", "1.00", "Li", "1"}, {"Ba", "Bathroom", "4.8", "3.2", "8.0", "2.4", "1.6", "3.2", "0.98", "Be", "1"}, {"Cl", "Closet", "3.2", "0.8", "12.8", "0.8", "0.8", "0.8", "0.50", "Be", "2"}, {"Di", "Dining", "12.0", "8.8", "24.0", "4.0", "3.2", "4.8", "0.83", "Li", "0"}, {"Ki", "Kitchen", "3.2", "0.8", "12.8", "0.8", "0.8", "0.8", "0.25", "Li", "2"}, {"La", "Laundry", "4.0", "3.2", "4.8", "2.4", "1.6", "3.2", "0.33", "Li", "1"}, {"Li", "Living", "20.0", "16.0", "24.0", "4.8", "3.2", "6.4", "0.50", "", "0"}, {"Ha", "Hall", "2.4", "1.6", "12.8", "1.6", "1.6", "1.6", "0.50", "Li", "2"}};

String [] rooms = getroomNAMES(roomsIN);
String [][] roomDATA=getroomDATA(rooms, roomDATAIN);
int [] lockgenes = getroomLOCKS(rooms, lockIN);

void setup(){
  size(360,640);
  //size(640,360);
  setupsl(rooms, roomDATA);
  setupUI();
}
void draw(){
  background(255);
  //drawsl();
  drawUI();
}
void mousePressed(){
  pressUI();
 presssl();
}
