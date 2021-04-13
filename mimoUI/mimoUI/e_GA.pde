

boolean evolve;


float fitnessat(House ho,float [] att) {
  float f=0;
  House temph  = ho.clonenewgenes(att);
  f-=temph.totfit;
  return f;
}
class Atribute {
  String name;
  float min;
  float max;
  Atribute(String _name, float _min, float _max) {
    name=_name;
    min=_min;
    max=_max;
  }
  Atribute clone () {
    Atribute clon = new Atribute (name, min, max);
    return clon;
  }
}
class Population {
  Individual [] pop;
  int nPop;
  Atribute [] at;
  Population(House ho, int _nPop,Atribute [] _at) {
    nPop = _nPop;
    at = _at;
    pop = new Individual[nPop];
    for (int i=0; i<nPop; i++) {   
      pop[i] = new Individual(at);
      pop[i].evaluate(ho);
    }
    pop = orderInds(pop);                                                                         //Arrays is a JAVA class identifier  //sort is one of its functions: it sorts a class of comparable elements
  }
  Individual select() {
    int which = (int)floor(((float)nPop-1e-6)*(1.0-sq(random(0, 1))));                          //skew distribution; multiplying by 99.999999 scales a number from 0-1 to 0-99, BUT NOT 100
    if (which == nPop) which = 0;
    return pop[which];                                                                         //the sqrt of a number between 0-1 has bigger possibilities of giving us a smaller number
  }                                                                                            //if we subtract that squares number from 1 the opposite is true-> we have bigger possibilities of having a larger number
  Individual sex(Individual a, Individual b) {
    Individual c = new Individual(at);
    for (int i=0; i<c.genes.length; i++) {
      if (random(0, 1)<0.5) c.genes[i] = a.genes[i];
      else c.genes[i] = b.genes[i];
    }
    c.mutate();
    c.inPhens();
    return c;
  }
  void evolve(House ho) {
    Individual a = select();
    Individual b = select();                                                                  //breed the two selected individuals    
    Individual x = sex(a, b);                                                                 //place the offspring in the lowest position in the population, thus replacing the previously weakest offspring    
    pop[0] = x;                                                                               //evaluate the new individual (grow)   
    x.evaluate(ho);                                                                             //the fitter offspring will find its way in the population ranks   
    pop = orderInds(pop);
  }
  class Individual {  
    float iFit;
    int [] genes;
    float [] phenos, phenosmin, phenosmax;
    Atribute[] a;
    Individual(Atribute [] _a) {
      a=_a;
      iFit = 0;
      genes  = new int [a.length];
      phenos = new float [genes.length];
      phenosmin = new float [phenos.length];
      phenosmax = new float [phenos.length];
      for (int i=0; i<phenosmin.length; i++) phenosmin [i] = a[i].min;
      for (int i=0; i<phenosmax.length; i++) phenosmax [i] = a[i].max;    
      for (int i=0; i<genes.length; i++) genes[i] = (int) random(256);
      for (int i=0; i<phenos.length; i++) phenos [i] = map(genes[i], 0, 256, phenosmin[i], phenosmax[i]);
    }
    void inGens() {
      genes = new int [a.length];
      for (int i=0; i<genes.length; i++) genes[i] = (int) random(256);
    }
    void inPhens() {
      for (int i=0; i<phenos.length; i++) phenos [i] = map(genes[i], 0, 256, phenosmin[i], phenosmax[i]);
    }
    void mutate() {                                                                               //5% mutation rate
      for (int i=0; i<genes.length; i++) if (random(100)<5)  genes[i] = (int) random(256);
    }
    void evaluate(House ho) {
      iFit = fitnessat(ho,phenos);
    }
    Individual clone() {
      Atribute as[] = new Atribute [a.length];
      for (int i=0; i<a.length; i++) as[i] = a[i].clone();
      Individual clon = new Individual(as);
      return clon;
    }
  }  
  Individual []  orderInds(Individual [] inarr) {
    Individual tmp = inarr[0].clone();
    for (int i = 0; i < inarr.length; i++) for (int j = i + 1; j < inarr.length; j++) if (inarr[i].iFit > inarr[j].iFit) {
      tmp = inarr[i];
      inarr[i] = inarr[j];
      inarr[j] = tmp;
    }
    return inarr;
  }
}
