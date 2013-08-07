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
float overlayAlpha = 0, agentsAlpha = 100, strokeWidth = 2, agentWidthMin = 1.5, agentWidthMax = 15;
int drawMode = 1;
PShape img;
int currentYear;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

//Jokbo Data import and conversion
Jokbo csvJokbo;
float clan0Y = 35.2285;
float clan0X = 128.8894;




void setup(){
  size(640,640,P2D);

  img = loadShape("map.svg");  //load the background map with the right aspect ratio
  //Latitude range of the map: 33 to 39
  //Longitude range of the map: 124 to 132

  csvJokbo = new Jokbo("jokbo1.txt");
  clan0Y = map(clan0Y,39,33,0,height);
  clan0X = map(clan0X,124,132,0,width);
  //println("clan0 coord is" + clan0X +""+clan0Y);//For debug
  smooth();
  PVector p;
  for(int i=0; i<agents.length; i++) {
    agents[i] = new Agent(clan0X,clan0Y,clan0X,clan0Y);
  }
  
  currentYear = csvJokbo.getCurrentYear();
  setupGUI();
    shape(img, 0, 0, width, height);
}

void draw(){
  if (agents[0].done() == true){
     //shape(img, 0, 0, width, height);
     agentsCount = 0;
     csvJokbo.toNextLine();
     currentYear = csvJokbo.getCurrentYear();
     
     //update Year text on the display
     fill(255,8,157);
     rect(500,80,65,40);
     textSize(24);
     fill(0,102,153);
     text(""+currentYear,500,100);
     
     while (currentYear == csvJokbo.getCurrentYear()) {
       float lat  = csvJokbo.getLat();
       float lo  = csvJokbo.getLong();
       lat = map(lat,39,33,0,640);
       lo = map(lo,124.5,132,0,640);
       agents[agentsCount] = new Agent(lo, lat, clan0X, clan0Y);
       agentsCount ++;
       csvJokbo.toNextLine();//This will have one line overlap
     }
        
  }
     
  fill(255, overlayAlpha);
  noStroke();
  rect(0,0,width,height);
  
  
  stroke(0, agentsAlpha);
  //draw agents
  if (drawMode == 1) {
    for(int i=0; i<agentsCount; i++) agents[i].update1();
  } 
  else {
    for(int i=0; i<agentsCount; i++) agents[i].update2();
  }

  drawGUI();
}

void keyReleased(){
  if (key=='m' || key=='M') {
    showGUI = controlP5.group("menu").isOpen();
    showGUI = !showGUI;
  }
  if (showGUI) controlP5.group("menu").open();
  else controlP5.group("menu").close();

  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key=='s' || key=='S') saveFrame(timestamp()+".png");
  if (key == DELETE || key == BACKSPACE) background(255);
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}
