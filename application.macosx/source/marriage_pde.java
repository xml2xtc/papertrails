import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.Calendar; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class marriage_pde extends PApplet {

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





// ------ agents ------
Agent[] agents = new Agent[10000]; // create more ... to fit max slider agentsCount
  //Load coordinates

int agentsCount = 1;
float noiseScale = 100, noiseStrength = 10, noiseZRange = 0.4f;
float overlayAlpha = 0, agentsAlpha = 50, strokeWidth = .5f, agentWidthMin = 1.5f, agentWidthMax = 15;
int drawMode = 1;
PShape img;
int currentYear;
int timer = 0;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

//Jokbo Data import and conversion
Jokbo csvJokbo;
float clan0Y = 35.2285f;
float clan0X = 128.8894f;




//PImage danny;


public void setup(){
  size(900,900,P2D);
  //danny = loadImage("danny.png");
  img = loadShape("map10.svg");  //load the background map with the right aspect ratio
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
  //setupGUI();
    //shape(img, 0, 0, width, height);
}

public void draw(){
//    if (millis() - timer >= 30000) {
//    image(danny, 0, 0,width,height);
//    
//    timer = millis();
//  }else{
  if (agents[0].done() == true){
     shape(img, 0, 0, width, height);
     agentsCount = 0;
     csvJokbo.toNextLine();
     currentYear = csvJokbo.getCurrentYear();
     
     //update Year text on the display
     //fill(255,7,7);
     //noStroke();
     //rect(500,80,65,40);
     textSize(width/10);
     fill(244,201,213,200);
     text(""+currentYear,clan0X + 50,clan0Y + 50);
     
     while (currentYear == csvJokbo.getCurrentYear()) {
       float lat  = csvJokbo.getLat();
       float lo  = csvJokbo.getLong();
       lat = map(lat,39,33,0,height);
       lo = map(lo,124.5f,132,0,width);
       agents[agentsCount] = new Agent(lo, lat, clan0X, clan0Y);
       agentsCount ++;
       csvJokbo.toNextLine();//This will have one line overlap
       //save("frames/jokbo_"+ agentsCount +".png");
     }
//     if (agentsCount >= 1){
//     saveFrame("frames/jokbo_"+ agentsCount +".png");
//     }
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

  //drawGUI();
}
//}

public void keyReleased(){
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

public String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}
//
////function that adjusts the stroke color based on the time
//void adjustStrokecolor(){
//
//  
//  
//}
// M_1_5_03_TOOL.pde
// Agent.pde, GUI.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

class Agent {
  PVector p, pOld;
  float noiseZ, noiseZVelocity = 0.01f;
  float stepSize, angle, randomizer, dO;
  int col, antiCol;
  int   yearMarker;
  boolean brideArrived;
  int FPY = 1000;  //Number of frames per year controls the speed of the arrow
  int currentFrame;
  float clan0X, clan0Y;
  float stepSizeX, stepSizeY;

  Agent(float m, float n, float clan0X, float clan0Y) {
    p = new PVector(m, n);
    pOld = new PVector(p.x, p.y);
    stepSize = random(2, 10);
    //println(""+p.x+" "+p.y+" "+clan0X+" "+clan0Y);

    //stepSize is the speed based on FPY
    stepSizeX = (clan0X-p.x)/FPY;
    stepSizeY = (clan0Y-p.y)/FPY;
    //dO = ((clan0X+clan0Y)-(p.x-p.y)/255);
    println("distance from Origin:"+dO); 
    //direction 
    if ((clan0X-p.x)<0) {
      angle = PI + atan((clan0Y-p.y)/(clan0X-p.x));
    }
    else {
      angle = atan((clan0Y-p.y)/(clan0X-p.x));
    }

    //println("Step Size is "+stepSizeX+" "+stepSizeY);
    brideArrived = false;
    // init noiseZ
    setNoiseZRange(0.4f);
    //col = color((int)random(40,60), 70, (int)random(0,100));
    float colorR = 245; //random(255);
    float colorG = 240; //random(255);
    float colorB = 255; //random(255);
    col = color(colorR, colorG, colorB);
    antiCol = color(255-colorR, 255-colorG, 255-colorB);
    currentFrame = 0;
  }

  public void update1() {
    currentFrame ++;
    //angle = noise(p.x/noiseScale, p.y/noiseScale, noiseZ) * noiseStrength;

    p.x += stepSizeX;
    p.y += stepSizeY;


    stroke(col, agentsAlpha);
    strokeWeight(2);//strokeWidth*stepSize/2);
    line(pOld.x, pOld.y, p.x, p.y);
    drawBride(p.x, p.y, 5.50f);
    //println("coord is" + p.x +"" + p.y);
    //println(currentFrame);
    //Set the condition for bride arrival at the clan
    if (FPY == currentFrame) {
      brideArrived = true;
    }

    pOld.set(p);
    noiseZ += noiseZVelocity;
  }

  public void setYear(int birthYearOfBride) {
    yearMarker = birthYearOfBride;
  }
  public void update2() {
    angle = noise(p.x/noiseScale, p.y/noiseScale, noiseZ) * noiseStrength;

    p.x += cos(angle) * stepSize;
    p.y += sin(angle) * stepSize;

    // offscreen wrap
    if (p.x<-10) p.x=pOld.x=width+10;
    if (p.x>width+10) p.x=pOld.x=-10;
    if (p.y<-10) p.y=pOld.y=height+10;
    if (p.y>height+10) p.y=pOld.y=-10;

    stroke(col, agentsAlpha);
    strokeWeight(strokeWidth);
    line(pOld.x, pOld.y, p.x, p.y);
    float agentWidth = map(randomizer, 0, 1, agentWidthMin, agentWidthMax);
    pushMatrix();
    translate(pOld.x, pOld.y);    
    rotate(atan2(p.y-pOld.y, p.x-pOld.x));
    line(0, -agentWidth, 0, agentWidth);
    popMatrix();

    pOld.set(p);
    noiseZ += noiseZVelocity;
  }


  public void setNoiseZRange(float theNoiseZRange) {
    // small values will increase grouping of the agents
    noiseZ = random(theNoiseZRange);
  }

  public boolean done() {
    return brideArrived;
  }
  public int getBgdColor() {
    return antiCol;
  }
  //change the moving objectshape: 
  private void drawBride(float brideLocX, float brideLocY, float shapeSize) {
    pushMatrix();
    translate(brideLocX, brideLocY); //translate it the coordinate of the object
    rotate(angle);
    float colorR = 255; //random(255);
    float colorG = 254; //random(255);
    float colorB = 245; //random(255);
    col = color(colorR, colorG, colorB);
    //start to draw the bride shape centered at where it should be 
    fill(col);
    noStroke();
    beginShape();
    vertex(.5f*shapeSize/.732f, 0);
    vertex(-shapeSize/.732f, -0.3f*shapeSize);
    vertex(0, 0); //origin vertex 
    vertex(-shapeSize/.732f, 0.3f*shapeSize);
    endShape();

    popMatrix();
  }
}





public void setupGUI(){
  int activeColor = color(0,130,164);
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorLabel(color(50));
  controlP5.setColorValue(color(255));

//  ControlGroup ctrl = controlP5.addGroup("menu",15,25,35);
//  ctrl.setColorLabel(color(255));
//  ctrl.close();

  sliders = new Slider[10];

  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  int posY = 0;

//  sliders[si++] = controlP5.addSlider("agentsCount",1,10000,left,top+posY+0,len,15);
//  posY += 30;
//
//  sliders[si++] = controlP5.addSlider("noiseScale",1,1000,left,top+posY+0,len,15);
//  sliders[si++] = controlP5.addSlider("noiseStrength",0,100,left,top+posY+20,len,15);
//  posY += 50;
//
//  sliders[si++] = controlP5.addSlider("strokeWidth",0,10,left,top+posY+0,len,15);
//  posY += 30;
//
//  sliders[si++] = controlP5.addSlider("noiseZRange",0,5,left,top+posY+0,len,15);
//  posY += 30;
//
//  sliders[si++] = controlP5.addSlider("agentsAlpha",0,255,left,top+posY+0,len,15);
//  sliders[si++] = controlP5.addSlider("overlayAlpha",0,255,left,top+posY+20,len,15);

  for (int i = 0; i < si; i++) {
//    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].captionLabel().toUpperCase(true);
    sliders[i].captionLabel().style().padding(4,3,3,3);
    sliders[i].captionLabel().style().marginTop = -4;
    sliders[i].captionLabel().style().marginLeft = 0;
    sliders[i].captionLabel().style().marginRight = -14;
    sliders[i].captionLabel().setColorBackground(0x99ffffff);
  }

}

public void drawGUI(){
  controlP5.show();
  controlP5.draw();
}

// called on every change of the gui
public void controlEvent(ControlEvent theEvent) {
  //println("got a control event from controller with id "+theEvent.controller().id());
  // noiseSticking changed -> set new values
  if(theEvent.isController()) {
    if (theEvent.controller().id() == 3) {
      for(int i=0; i<agentsCount; i++) agents[i].setNoiseZRange(noiseZRange);  
    }
  }
}








class Jokbo {
  private String [][] csv;
  int csvWidth = 0;
  int linecount = 1;  //counting how many lines have been executed
  
  Jokbo (String filename) {
    String [] lines = loadStrings(filename);
    //calculate max width of csv file
    for (int i=0; i < lines.length; i++) {
      String [] chars=split(lines[i],'\t');
      if (chars.length>csvWidth) csvWidth=chars.length;
    }

    //create csv array based on # of rows and columns in csv file
    csv = new String [lines.length][csvWidth];

    //parse values into 2d array
    for (int i=0; i < lines.length; i++) {
      String [] temp = new String [lines.length];
      temp= split(lines[i], '\t');
      for (int j=0; j < temp.length; j++){
         csv[i][j]=temp[j];
      }
    }
    println(lines.length);
  }
  
  //Lattitude coord of the bride's clan
  public float getLat(int linenumber) {
    return Float.parseFloat(trim(csv[linenumber][5]));
  }
  
  //Longitudinal coord of the bride's clan
  public float getLong(int linenumber) {
    return Float.parseFloat(trim(csv[linenumber][6]));
  }
  
    public float getLat() {
    return Float.parseFloat(trim(csv[linecount][5]));
  }
  
  //Longitudinal coord of the bride's clan
  public float getLong() {
    return Float.parseFloat(trim(csv[linecount][6]));
  }
  
  //birth year of the bride
  public int getYear(int linenumber) {
    int year = Integer.parseInt(trim(csv[linenumber][2]));
    return year;
  }
  
  //The clan ID of where the bride came from
  public int getClanID(int linenumber) {
    int ID = Integer.parseInt(trim(csv[linenumber][4]));
    return ID;
  }
  
  public void toNextLine(){
    linecount++;
  }
  
  public int getCurrentYear(){
    return Integer.parseInt(trim(csv[linecount][2]));
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "marriage_pde" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
