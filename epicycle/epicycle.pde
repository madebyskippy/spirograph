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
float rate = 1;

int counter;

//for UI stuffs
boolean drawBack = true;
boolean drawPreview = false;

void setup(){
  size(900,680);
  background(255);
  stroke(0);
  noFill();
  
  radius = new float[]{50,105,40}; //MODIFY
  
  speeds = new float[]{1,-0.2,1.8}; //MODIFY
  
  centers = new tuple[num];
  for (int i=0; i<centers.length; i++){
    centers[i] = new tuple(width/2,height/2);
  }
  
  points = new ArrayList<tuple>();
  preview = new ArrayList<tuple>();
  
  counter=0;
}

void draw(){
  background(255);
  stroke(200);
  float d=counter*rate;
  counter++;
  
  for (int i=1; i<radius.length; i++){
    
    tuple c = circ(d*speeds[i-1],radius[i-1],centers[i-1]);
    centers[i] = c;
    if (drawBack){
      ellipse(c.x,c.y,radius[i]*2,radius[i]*2);
      line(centers[i-1].x,centers[i-1].y,centers[i].x,centers[i].y);
    }
  }
  
  tuple last = circ(d*speeds[speeds.length-1],radius[radius.length-1],centers[centers.length-1]);
  if (drawBack){
    //first circle
    ellipse(centers[0].x,centers[0].y,radius[0]*2,radius[0]*2);
    
    //and last line
    line (centers[centers.length-1].x,centers[centers.length-1].y, last.x, last.y);
  }
  
  if (points.size()>totalPoints){
    points.remove(0);
  }
  points.add(last);
  
  if (drawPreview){
    stroke(255,175,175);
    drawCurve();
  }
  
  stroke(0);
  for (int i=0; i<points.size(); i++){
    point(points.get(i).x, points.get(i).y);
  }
  
  
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
    }
    if (key == 'y'){
      speeds[1] += 0.1;
    }
    if (key == 'u'){
      speeds[2] += 0.1;
    }
    if (key == 'g'){
      speeds[0] -= 0.1;
    }
    if (key == 'h'){
      speeds[1] -= 0.1;
    }
    if (key == 'j'){
      speeds[2] -= 0.1;
    }
    
    //for setting level
    if ((key >= '0') && (key <= '9')){
      println(int(key)-48);
      radius = lvls[int(key)-48][0];
      speeds = lvls[int(key)-48][1];
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

void preCompute(){
  int size = preview.size();
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
    
      tuple c0 = circ(d*speeds[j-1],radius[j-1],c[j-1]);
      c[j] = c0;
    }
  
    point = circ(d*speeds[speeds.length-1],radius[radius.length-1],c[c.length-1]);
    preview.add(point);
    count ++;
  }
}

void drawCurve(){
  for (int i=0; i<preview.size(); i++){
    point(preview.get(i).x,preview.get(i).y);
  }
}

class tuple{
  float x;
  float y;
  tuple(float j, float k){
    x=j;
    y=k;
  }
}