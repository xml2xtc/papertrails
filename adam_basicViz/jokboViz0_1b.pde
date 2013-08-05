// Adventure Class adaptation for SAIC/NU Data Viz class, Summer 2013
// version: 0.1b Aug 2, 2013
// vector moving class && CSV import system sketch, adam trowbridge 2013, atrowbri@gmail.com. 
// License: Attribution 3.0 Unportedhttp://creativecommons.org/licenses/by/3.0/
// jokbo CSV file is private and confidential, do not share.

String datafile [];          // for the entire data file, jokbo csv
String values [];            // for the individual lines, while sorting
int lowerYear;               // the lower end of the year range searched
int upperYear;               // the upper end of the year range searched

Adventure[] brides;         // create a new object called bride1 of the class Adventure

void setup() {
  size(500,800);
  
  datafile = loadStrings("jokbo1.csv"); // load the jokbo csv

  brides = new Adventure[datafile.length]; // create an array object that is the size of the length of the jokbo csv

  // this loop goes through each line of the jokbo csv and instantiates an object that holds the year and locations
  for (int i = 0 ; i < datafile.length; i++) {
    values = split(datafile[i], ',');                       // split the line
    int year = int(values[0]);                              // set the year
    float xVal = float(values[1]);                          // set the lat
    float yVal = float(values[2]);                          // set the long
    xVal = map(xVal,31.92067,42.93917,10,width-10);         // map() function changes lat to x value of current window width
    yVal = map(yVal,116.81326,134.07497,10,height-10);      // map() function changes long to y value of current window height
    brides[i] = new Adventure(year, xVal,yVal,float(width/2),float(height/2)); // create the object
  }
}
  

void draw() {
  background(255);
  
  lowerYear = 1900; // set the lower year, obviously this needs to be automated
  upperYear = 1920; // set the upper year, obviously this needs to be automated
  
  for(int i=0; i < brides.length; i++) {
    if (brides[i].theYear > lowerYear && brides[i].theYear < upperYear) { // if the year of the object is within our current range
    brides[i].adventureMove(); // use the adventureMove() method to move the ellipse
    }
  }
}

class Adventure {
  
  PVector current;                      // vector for holding the current position
  PVector destination;                  // vector for holding the destination
  PVector velocity = new PVector();     // vector for holding the velocity
  int theYear;                          // property holding the year
 
   
   Adventure(int year, float xO, float yO, float xD, float yD) {
     current = new PVector(xO,yO);                     // the current destination begins with the origin point
     destination = new PVector(xD,yD);                 // the current destination is where the bride ends up
     velocity.x = (destination.x - current.x) * .01;   // the x velocity is the x difference between the origin and destination, multimplied by .01 to slow down movement
     velocity.y = (destination.y - current.y) * .01;   // the y velocity is the y difference between the origin and destination, multimplied by .01 to slow down movement
     theYear = year;
   }
   
   void adventureMove () {
     if (current.dist(destination) > .1 ) {           // if the distance between the current position and the destination is more than .1, keep moving it
       current.add(velocity);                         // add the velocity to the current position
       ellipse(current.x,current.y,10,10);            // draw an ellipse where we are
     } else { 
       ellipse(destination.x,destination.y,10,10);    // if the distance between the current position and the destination is = or < .1, do not move it any more, draw the ellipse at the destination
     }  
  }
}
   
   
   
   

