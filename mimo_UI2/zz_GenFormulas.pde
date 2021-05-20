//                                                                              CLONES
int [] cloneintarr (int inarr[]) {
  int outarr []= new int [inarr.length];
  for (int i=0; i<outarr.length; i++) outarr[i] = inarr[i];
  return outarr;
}
PVector [] clonevecarr (PVector inarr[]) {
  PVector outarr []= new PVector [inarr.length];
  for (int i=0; i<outarr.length; i++) outarr[i] = inarr[i].copy();
  return outarr;
}
String [] clonestarr(String [] stin) {
  String [] stout = new String [stin.length];
  for (int i=0; i<stin.length; i++) stout[i] = stin[i];
  return stout;
}
ArrayList <Border> cloneborderslist(ArrayList <Border> bin) {
  ArrayList <Border> bout = new ArrayList <Border> ();
  if (bin!=null)for (int i=0; i<bin.size(); i++) bout.add(bin.get(i).cloneit());
  return bout;
}

ArrayList <Mueble> clonemuebles(ArrayList <Mueble> bin) {
  ArrayList <Mueble> bout = new ArrayList <Mueble> ();
  if (bin!=null)for (int i=0; i<bin.size(); i++) bout.add(bin.get(i).cloneit());
  return bout;
}




//                                                                              INT
//                                                                                     factorials


int factorial(int num) {
  if (num>12) println("numero factorial muy grande");
  return fact(num);
}
int fact(int num) {
  if (num <= 1) return 1;
  else return num*fact(num - 1);
}                                   
int min0(int num) {
  if (num>=0) return num;
  else return 0;
}

//                                                                              FLOAT
float roundit(float numin, int dec) {                                                    //round
  float dec10 = pow(10, dec);
  float roundout = round(numin * dec10)/dec10;
  return roundout;
}
float roundspan(float fin, float spanu) {
  float fout = fin + spanu*.5;
  fout = roundit(fout-(fout%spanu), 2);
  return fout;
}
float avgfloat(float a, float b) {
  return a*.5+b*.5;
}
float wavgfloat(float a, float b, float wa) {
  return a*wa+b*(1-wa);
}
float divNaN0(float a, float b) {
  if (a==0&&b==0) return 0;
  else return a/b;
} 
float [] ranflarr(int num, float min, float max) {                                     //   random array
  float rout[] = new float [num];
  for (int i=0; i<rout.length; i++) rout [i] = random(min, max);
  return rout;
}
float min0max1fl(int min0max1, float a, float b) {
  float fout;
  if ((min0max1==0&&a<b)||(min0max1==1&&a>b))  fout=a;
  else fout =b;
  return fout;
}
//VECTOR
PVector avgvector(PVector a, PVector b) {
  return new PVector (a.x*.5+b.x*.5, a.y*.5+b.y*.5);
}
PVector wavgvector(PVector a, PVector b, float wa) {
  return new PVector (a.x*wa+b.x*(1-wa), a.y*wa+b.y*(1-wa));
}
//                                                                              STRING
//                                                                                      equal
boolean txequal(String a, String b) {
  if (a==null||b==null) return false;
  else {
    int al= a.length();
    int bl= b.length();
    int minl;
    boolean bout = true;
    if (al!=bl) bout = false;
    if (al<bl) minl = al;
    else minl = bl;
    for (int i=0; i<minl; i++) if (a.charAt(i)!=b.charAt(i)) bout = false; 
    return bout;
  }
}

ArrayList <String> removeemptyst(ArrayList <String> stin) {
  ArrayList <String> stout = new ArrayList <String> ();
  for (int i=0; i<stin.size(); i++) if (!txequal(stin.get(i), "")) stout.add(stin.get(i));
  return stout;
}
String [] removeemptystarr(String [] stin) {
  ArrayList <String> stout = new ArrayList <String> ();
  for (int i=0; i<stin.length; i++) if (!txequal(stin[i], "")) stout.add(stin[i]);
  String starrout[] = new String [stout.size()];
  for (int i=0; i<starrout.length; i++) starrout[i] = stout.get(i);
  return starrout;
} 
String [] subtostarr(String [] stin, String strremove) {
  ArrayList <String> stout = new ArrayList <String> ();
  for (int i=0; i<stin.length; i++) if (!txequal(stin[i], strremove)) stout.add(stin[i]);
  String starrout[] = new String [stout.size()];
  for (int i=0; i<starrout.length; i++) starrout[i] = stout.get(i);
  starrout = getroomNAMES(starrout);
  return starrout;
}
String [] addtostarr(String [] inarr, String newstr) {//addtostarr
  String stout [] = new String [inarr.length+1];
  for (int i=0; i< inarr.length; i++) stout[i] = inarr[i];
  stout[inarr.length] = newstr;
  stout = getroomNAMES(stout);
  return stout;
}
//                                                                                        permutations
String[] permutation01(String [] pre, float num) {
  int numin = factorial(pre.length)-1;
  if (num<1)  numin =int(map(num, 0, 1, 0, factorial(pre.length))); 
  String newA[] = perm(pre, 0, new ArrayList <String[]> (), numin);
  return newA;
}
String[]  perm(String[] iA, int s, ArrayList <String[]> igm, int nume) {    
  for (int i = s; i < iA.length; i++) {
    String temp = iA[s];
    iA[s] = iA[i];
    iA[i] = temp;
    perm(iA, s + 1, igm, nume);
    iA[i] = iA[s];
    iA[s] = temp;
  }
  if (s == iA.length - 1) {
    String toadd= "";
    for (int i=0; i<iA.length-1; i++) toadd = toadd + iA[i] + ",";
    toadd = toadd + iA[iA.length-1];   
    igm.add(split(toadd, ","));
  }
  String [] ig1 = null;
  if (igm.size()>nume)  ig1 = igm.get(nume);
  return ig1;
}
boolean vectorsequal(PVector a, PVector b) {
  return a.x==b.x&&a.y==b.y;
}


void daline(PVector a, PVector b, float space) {
  float distper = (space/PVector.dist(a, b))/2;
  boolean odd = true;
  for (float i=0; i<1; i+=distper) {
    float nexti = i+distper;
    PVector p1 = new PVector(b.x*i+a.x*(1-i), b.y*i+a.y*(1-i));
    PVector p2 = new PVector(b.x*nexti+a.x*(1-nexti), b.y*nexti+a.y*(1-nexti));
    if (PVector.dist(p2, p1)<PVector.dist(b, p1)) if (odd) line(p1.x, p1.y, p2.x, p2.y);
    if (PVector.dist(p2, p1)>=PVector.dist(b, p1))if (odd) line(p1.x, p1.y, b.x, b.y);
    odd = !odd;
  }
}
