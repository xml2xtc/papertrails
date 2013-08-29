/**
 * noise values (noise 3d) are used to animate a bunch of agents.
 * 
 * KEYS
 * m                   : toogle menu open/close
 * 1-2                 : switch noise mode
 * space               : new noise seed
 * backspace           : clear screen
 * s                   : save png
 */

import controlP5.*;
import java.util.Calendar;


// ------ agents ------
Agent[] agents = new Agent[10000]; // create more ... to fit max slider agentsCount
//Load coordinates

int agentsCount = 1;
float noiseScale = 100, noiseStrength = 10, noiseZRange = 0.4;
float overlayAlpha = 0, agentsAlpha = 100, strokeWidth = .5, agentWidthMin = 1.5, agentWidthMax = 15;
int drawMode = 1;
PShape img;
PShape img1;
int currentYear;
int timer = 0;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

//Jokbo Data import and conversion
Jokbo csvJokbo;
float clan0Y = 35.2285;
float clan0X = 128.8894;

float mapLonMax, mapLonMin, mapLatMax, mapLatMin;

PFont mono;

//PImage danny;

void setup() {
  size(700, displayHeight, P2D);
  background(244, 201, 213); 
  mono = createFont("CourierNewPSMT-60.vlw",60,true);
  //danny = loadImage("danny.png");
  //load the background map with the right aspect ratio
  img1 = loadShape("map10crop5.svg"); //blackandpink<-----
  //img = loadShape("map10crop4.svg");  //pink and green<----
  //Latitude range of the map: 33 to 39
  //Longitude range of the map: 124 to 132
  //Latitude range of the map: 32 to 40
  //Longitude range of the map: 125 to 129.5
  mapLonMax = 129.73;
  mapLonMin = 126;
  mapLatMax = 38.94;
  mapLatMin = 33;
  
  csvJokbo = new Jokbo("jokbo1.txt");
  clan0Y = map(clan0Y,mapLatMax,mapLatMin,0,height);
  clan0X = map(clan0X,mapLonMin,mapLonMax,0,width);
  //println("clan0 coord is" + clan0X +""+clan0Y);//For debug
  smooth();
  PVector p;
  for (int i=0; i<agents.length; i++) {
    agents[i] = new Agent(clan0X, clan0Y, clan0X, clan0Y);
  }

  currentYear = csvJokbo.getCurrentYear();
  println(currentYear);
  //setupGUI();
  //shape(imgswitch, 0, 0, width, height);
}

void draw() {
  //    if (millis() - timer >= 30000) {
  //    image(danny, 0, 0,width,height);
  //    
  //    timer = millis();
  //  }else{
  if (agents[0].done() == true) {
    if (csvJokbo.getCurrentYear() == 1998){
       csvJokbo = new Jokbo("jokbo1cleaned.txt");}else{
      shape(img1, 0, 0, width, height);

      //background(244,201,213); 
      agentsCount = 0;
      csvJokbo.toNextLine();
      currentYear = csvJokbo.getCurrentYear();

      //update Year text on the display
      //fill(255,7,7);
//      noStroke();
//      fill(234, 252, 234);
//      rect(clan0X - 50, clan0Y +400, 100, 40);



      while (currentYear == csvJokbo.getCurrentYear ()) {
        //Latitude range of the map: 33 to 39
        //Longitude range of the map: 124 to 132
        float lat  = csvJokbo.getLat();
        float lo  = csvJokbo.getLong();
        lat = map(lat, 38.72, 32.8, 0, height);        
        lo = map(lo, 125.77, 129.73, 0, width);
        agents[agentsCount] = new Agent(lo, lat, clan0X, clan0Y);
        agentsCount ++;
        csvJokbo.toNextLine();//This will have one line overlap
      //save("frames/jokbo_"+ agentsCount +".png");
    }
      textFont(mono);
      //textSize(width/20);
      fill(244, 201, 213);
      //fill(244,244,244,200);
      String currentYearTxt;
      currentYearTxt= str(currentYear);
      text(currentYearTxt, clan0X - 85, clan0Y + 250);  
      
}
       
  }

  
  fill(255, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);

  stroke(0, agentsAlpha);
  //draw agents
  if (drawMode == 1) {
    for (int i=0; i<agentsCount; i++) agents[i].update1();
  } 
  else {
    for (int i=0; i<agentsCount; i++) agents[i].update2();
  }

  //drawGUI();
}
//}

void keyReleased() {
  //  if (key=='m' || key=='M') {
  //    showGUI = controlP5.group("menu").isOpen();
  //    showGUI = !showGUI;
  //  }
  //  if (showGUI) controlP5.group("menu").open();
  //  else controlP5.group("menu").close();

  //if (key == '1') drawMode = 1;
  //if (key == '2') drawMode = 2;
  if (key=='s' || key=='S') saveFrame("frames/"+ timestamp() +".tiff");
  //if (key == DELETE || key == BACKSPACE) background(255);
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}


