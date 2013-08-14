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
  float noiseZ, noiseZVelocity = 0.01;
  float stepSize, angle, randomizer;
  color col, antiCol;
  int   yearMarker;
  boolean brideArrived;
  int FPY = 100;  //Number of frames per year controls the speed of the arrow
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
    setNoiseZRange(0.4);
    //col = color((int)random(40,60), 70, (int)random(0,100));
    float colorR = 215; //random(255);
    float colorG = 228; //random(255);
    float colorB = 252; //random(255);
    col = color(colorR, colorG, colorB);
    antiCol = color(255-colorR, 255-colorG, 255-colorB);
    currentFrame = 0;
  }

  void update1() {
    currentFrame ++;
    //angle = noise(p.x/noiseScale, p.y/noiseScale, noiseZ) * noiseStrength;

    p.x += stepSizeX;
    p.y += stepSizeY;


    stroke(col, agentsAlpha);
    strokeWeight(2);//strokeWidth*stepSize/2);
    line(pOld.x, pOld.y, p.x, p.y);
    drawBride(p.x, p.y, 10.00);
    //println("coord is" + p.x +"" + p.y);
    //println(currentFrame);
    //Set the condition for bride arrival at the clan
    if (FPY == currentFrame) {
      brideArrived = true;
    }

    pOld.set(p);
    noiseZ += noiseZVelocity;
  }

  void setYear(int birthYearOfBride) {
    yearMarker = birthYearOfBride;
  }
  void update2() {
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


  void setNoiseZRange(float theNoiseZRange) {
    // small values will increase grouping of the agents
    noiseZ = random(theNoiseZRange);
  }

  boolean done() {
    return brideArrived;
  }
  color getBgdColor() {
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
    fill(col, agentsAlpha);
    noStroke();
    beginShape();
    vertex(.5*shapeSize/.732, 0);
    vertex(-shapeSize/.732, -0.5*shapeSize);
    vertex(0, 0); //origin vertex 
    vertex(-shapeSize/.732, 0.5*shapeSize);
    endShape();

    popMatrix();
  }
}





