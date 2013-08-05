String datafile [];
String values [];
float marriages[][];
int currentSet;

// create a new object called bride1 of the class Adventure
Adventure[] brides;

void setup() {
  size(500,800);
  // bride1 = new Adventure(0,0,400,400);
  
  datafile = loadStrings("jokbo1.csv");
  marriages = new float[datafile.length][3];
  
  brides = new Adventure[datafile.length];
  values = split(datafile[i], ',');

  for (int i = 0 ; i < datafile.length; i++) {
    brides[i] = Adventure(values[1],values[2],width/2,height/2);
  }
}
  

void draw() {
  background(255);
  // bride1.adventureMove();
  

}

class Adventure {
  
  PVector current;
  PVector destination;
  PVector velocity = new PVector();
   
   Adventure(float xO, float yO, float xD, float yD) {
     current = new PVector(xO,yO);
     destination = new PVector(xD,yD);
     velocity.x = (destination.x - current.x) * .01;
     velocity.y = (destination.y - current.y) * .01; 
   }
   
   void adventureMove () {
     if (current.dist(destination) > .1 ) {
       current.add(velocity);
       ellipse(current.x,current.y,10,10);  
     } else { 
       ellipse(destination.x,destination.y,10,10);  
     }  
  }
}
   
   
   
   


