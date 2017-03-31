//waddup
/*
 UI:
 
 -press UP to turn on circle visualization
 -press DOWN to turn it off
 
 -Q/A, W/S, E/D control the radius of the circles
 -T/G, Y/H, U/J control the speeds they're going
 
 -press RIGHT to preview the curve
 -press LEFT to get rid of the preview
 
 -press 0-9 to switch "levels"

  you can manually adjust initial radius and speed in code.
  search 'MODIFY' and it's those arrays

*/
import processing.serial.*;
Serial myPort;  // Create object from Serial class
int val;

//levels!!!!!!!!!!!!!!!!!!!
//first index is the level, second is radius / speed, third is the value
//FOR FILLING OUT: first {} on line is radius, second is speed
float[][][] lvls = new float[][][]{{{50,105,40},{1,-.2,1.8}},
                               {{45,110,50},{1.5,-3.,1.4}},
                               {{20,100,50},{1,1.9,-1.9}},
                               {{50,65,50},{1,-1.1,2.2}},
                               {{60,60,50},{1,-.2,2.2}},
                               {{80,30,55},{1,-1.4,-3}},
                               {{50,30,40},{1,.1,-2.6}},
                               {{50,105,40},{1,.1,-2.6}},
                               {{100,50,25},{1,-2.1,-2.1}},
                               {{100,50,50},{1,1,2.9}}};
//multiples of 360. total number of points to plot to show the whole fuckin curve
//this better be the same length as the lvls array
int[] pointCount = new int[]{5,10,10,10,5,5,10,10,10,10};

int level = 0;

//number of circles
int num = 3;

//modifyable stuffos
float[] radius;
float[] speeds;

//these get calculated
tuple[] centers;

//used for display
ArrayList<tuple> points;
ArrayList<tuple> preview;
int totalPoints = 360*5;

//for how fast it draws
float rate = 3;

int counter;

//for UI stuffs
boolean drawBack = true;
boolean drawPreview = false;

int backgroundColor;
boolean solved;

String[] symbols = new String[]{"☼","☽","☄"};

PFont titleFont;
PFont headerFont;
PFont bodyFont;
PFont italicFont;
PFont unicode;

float topMargin;
float leftMargin;

void setup(){
  
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  
  size(1280,720);
  backgroundColor=225;
  solved=false;
  background(backgroundColor);
  stroke(0);
  noFill();
  
  radius = new float[]{50,105,40}; //MODIFY
  
  speeds = new float[]{1,-0.2,1.8}; //MODIFY
  
  centers = new tuple[num];
  for (int i=0; i<centers.length; i++){
    centers[i] = new tuple(width/2,height/1.75);
  }
  
  points = new ArrayList<tuple>();
  preview = new ArrayList<tuple>();
  
  counter=0;
  
  italicFont = createFont("ACaslonPro-Italic.otf", 16);
  bodyFont = createFont("AGaramondPro-Regular.otf", 16);
  titleFont = createFont("RobotoMono-Bold.ttf", 16);
  headerFont = createFont("RobotoMono-Light.ttf", 16);
  unicode = createFont("Arial Unicode.ttf", 16);
  textFont(titleFont);
  
  topMargin = 80;
  leftMargin = width/8;
}
void drawCircle(float x, float y, float radius) {
  stroke(color(random(100,255), random(100,255),random(100,255)));
  ellipse(x, y, radius, radius);
  if(radius > 10) {
    stroke(color(0, random(100,255),random(100,255)));
    radius *= 0.75f;
    drawCircle(x, y, radius);
  }
}

void draw(){
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    //println(val);
    readInput(val);
  }
   
  if (solved){
    textFont(headerFont);
    textSize(48);
    drawCircle(width/2,height/1.75, 1000);
    text("SELECT NEXT CYCLE", width/2 - textWidth("SELECT NEXT CYCLE")/2, height/1.1);
  }else{
     background(225);
  }
  stroke(100);
  float d=counter*rate;
  counter++;
  
  for (int i=1; i<radius.length; i++){
    
    tuple c = circ(d*speeds[i-1],radius[i-1],centers[i-1]);
    centers[i] = c;
    if (drawBack){
      textFont(unicode);
      textSize(36);
      text(symbols[i-1], centers[i-1].x,centers[i-1].y);
      stroke(200);
      ellipse(c.x,c.y,radius[i]*2,radius[i]*2);
      stroke(100);
      line(centers[i-1].x,centers[i-1].y,centers[i].x,centers[i].y);
    }
  }
  
  tuple last = circ(d*speeds[speeds.length-1],radius[radius.length-1],centers[centers.length-1]);
  if (drawBack){
    //first circle
    stroke(200);
    ellipse(centers[0].x,centers[0].y,radius[0]*2,radius[0]*2);
    text(symbols[2], centers[centers.length-1].x,centers[centers.length-1].y);
    //and last line
    stroke(100);
    line (centers[centers.length-1].x,centers[centers.length-1].y, last.x, last.y);
  }
  
    stroke(200,200,255);
    drawCurve();
    
    stroke (10);
    drawLine();
  
  if (points.size()>totalPoints){
    points.remove(0);
  }
  points.add(last);
  

  
  stroke(0);
  for (int i=0; i<points.size(); i++){
    point(points.get(i).x, points.get(i).y);
  }
  
  fill(0);
  textFont(headerFont);
  textSize(36);
  text("CYCLE "+level, leftMargin + 80, 50 + topMargin - 20);
 fill(150,150,255);
   text("ALIGNED", width - leftMargin * 3 + 80, 50 + topMargin - 20);
  fill(0);
  textFont(headerFont);
  textSize(14);
  text("MASS\nLIGHT",leftMargin,150 + topMargin);
  
  for (int i=0; i<radius.length;i++){
    fill(0);
    textFont(italicFont);
    textSize(14);
    text("O " + (i+1), leftMargin + (80*(i+1)),100 + topMargin);
    line (leftMargin + (80*(i+1)), 100 + topMargin + 5, leftMargin + (80*(i+1)) + textWidth("O " + (i+1)), 100 + topMargin + 5);
    textFont(bodyFont);
    text(nf(radius[i], 1,0)+"\n"+nf(speeds[i], 1,1),leftMargin+(80*(i+1)),150 + topMargin);
   
    fill(150,150,255);
   
    textFont(unicode);
    textSize(48);
    text(symbols[i], width - leftMargin * 3 + (80*(i+1)), 100 + topMargin);
     textFont(bodyFont);
    text(nf(lvls[level][0][i], 1,0)+"\n"+ nf(lvls[level][1][i],1,1) ,width - leftMargin * 3 + (80*(i+1)),150 + topMargin);
  }
  noFill();
}

//idk why i made all the radius integers oops
tuple circ(float deg, float rad, tuple center){
  float x;
  float y;
  x = center.x + rad * cos(radians(deg) +PI/2);
  y = center.y + rad * sin(radians(deg) +PI/2);
  return new tuple(x,y);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      drawBack = true;
    } else if (keyCode == DOWN) {
      drawBack = false;
    } else if (keyCode == LEFT) {
      preCompute();
      drawPreview = true;
    } else if (keyCode == RIGHT) {
      drawPreview = false;
    }
  }else{
    if (key == 'a'){
      radius[0]-=5;
    }
    if (key == 's'){
      radius[1]-=5;
    }
    if (key == 'd'){
      radius[2]-=5;
    }
    if (key == 'q'){
      radius[0]+=5;
    }
    if (key == 'w'){
      radius[1]+=5;
    }
    if (key == 'e'){
      radius[2]+=5;
    }
    
    //first 3 up the speed
    //last 3 down the speed
    if (key == 't'){
      speeds[0] += 0.1;
      rounded(speeds[0],1);
    }
    if (key == 'y'){
      speeds[1] += 0.1;
      rounded(speeds[1],1);
    }
    if (key == 'u'){
      speeds[2] += 0.1;
      rounded(speeds[2],1);
    }
    if (key == 'g'){
      speeds[0] -= 0.1;
      rounded(speeds[0],1);
    }
    if (key == 'h'){
      speeds[1] -= 0.1;
      rounded(speeds[1],1);
    }
    if (key == 'j'){
      speeds[2] -= 0.1;
      rounded(speeds[2],1);
    }
    
    //check if matched the level
    checkAnswer();
    
    //for setting level
    if ((key >= '0') && (key <= '9')){
      changeLevel(int(key)-48);
      checkAnswer();
    }
    clearList();
  }
}

void clearList(){
  int size = points.size();
  for (int i=0; i<size; i++){
    points.remove(0);
  }
}

//shows it for the LEVEL not the current thing
void preCompute(){
  int size = preview.size();
  float[] r = lvls[level][0];
  float[] s = lvls[level][1];
  for (int i=0; i<size; i++){
    preview.remove(0);
  }
  tuple[] c = new tuple[centers.length];
  c[0] = centers[0];
  float d = 0;
  float count = 0;
  for (int i=0; i<totalPoints; i++){
    //for each degree
    tuple point;
    d = count*rate;
    for (int j=1; j<radius.length; j++){
    
      tuple c0 = circ(d*s[j-1],r[j-1],c[j-1]);
      c[j] = c0;
    }
  
    point = circ(d*s[s.length-1],r[r.length-1],c[c.length-1]);
    preview.add(point);
    count ++;
  }
}

void drawCurve(){
  for (int i=1; i<preview.size(); i++){
    line(preview.get(i-1).x,preview.get(i-1).y,preview.get(i).x,preview.get(i).y);
    //point(preview.get(i).x,preview.get(i).y);
  }
}

void drawLine(){
  for (int i=1; i<points.size(); i++){
    stroke((1-float(i) / float(points.size())) * 255);
    line(points.get(i-1).x,points.get(i-1).y,points.get(i).x,points.get(i).y);
    //point(preview.get(i).x,preview.get(i).y);
  }
}

void changeLevel(int l){
    level = l;
    //radius = lvls[level][0];
    //speeds = lvls[level][1];
    
    //randomize it to make it gamey
    for (int i=0; i<radius.length; i++){
      radius[i] = lvls[level][0][i]+((int)random(10)-5)*5;
      if (i != 2){
        speeds[i] = lvls[level][1][i]+((int)random(10)-5)*.1;
      }else{
        speeds[i] = lvls[level][1][i];
      }
    }
    
    preCompute();
    totalPoints = 360 * pointCount[level];
    
}

void checkAnswer(){
  boolean right = true;
  for (int i=0; i<radius.length; i++){
    if (!eq(radius[i],lvls[level][0][i],4)){
      right = false;
    }
    if (!eq(speeds[i],lvls[level][1][i],0.09)){
      right = false;
    }
  }
  solved = right;
}

void readInput(int val){
  //println(val);
  if (val%10 == 0){
    println("capacitor "+val+" "+val/10);
    if (val/10 == 1){
      //capacitor on
    }if (val/10 == 2){
      //capcaitor off
    }
  }else if (val%10 == 1){
    println("potentiometer "+val+" "+val/10);
    //speed of middle circle
    speeds[1] = lvls[level][1][1] + (val/10 - 5)*0.1;
  }else if (val%10 == 2){
    println("bend "+val+" "+val/10);
    //speed of biggest circle
    speeds[0] = lvls[level][1][0] + (val/10 - 5)*0.1;
  }else if (val%10 == 3){
    println("photor1 "+val+" "+val/10);
    //radius of biggest
    radius[0] = lvls[level][0][0] + (val/10 - 5)*5;
  }else if (val%10 == 4){
    println("photor2 "+val+" "+val/10);
    //radius of middle
    radius[1] = lvls[level][0][1] + (val/10 - 5)*5;
  }else if (val%10 == 5){
    println("photor3 "+val+" "+val/10);
    //radius of small
    radius[2] = lvls[level][0][2] + (val/10 - 5)*5;
  }
}

//helper stuffos -----------------

boolean eq(float x, float y, float range){
  if (x < (y+range) && x > (y-range)){
    return true;
  }
    //println(x+", "+y+", "+range);
  return false;
}

float rounded(float num, int places){
  return round(num*(places*10))/(places*10);
}

class tuple{
  float x;
  float y;
  tuple(float j, float k){
    x=j;
    y=k;
  }
}