//waddup
/*
 UI:
 
 -press UP to turn on circle visualization
 -press DOWN to turn it off
 
 -Q/A, W/S, E/D, R/F control the radius of the circles
 
 -press RIGHT to preview the curve
 -press LEFT to get rid of the preview

*/

int[] radius;
tuple[] centers;
ArrayList<tuple> points;
ArrayList<tuple> preview;

float rate = 0.01;
int totalPoints = 360*2;

int counter;

boolean drawBack = true;
boolean drawPreview = false;

void setup(){
  size(900,680);
  background(255);
  stroke(0);
  noFill();
  radius = new int[3];
  radius[0] = 100;
  radius[1] = 75;
  radius[2] = 50;
  //radius[3] = 25;
  
  centers = new tuple[3];
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
    
    tuple c = circ(d*i,radius[i-1],centers[i-1]);
    centers[i] = c;
    if (drawBack){
      ellipse(c.x,c.y,radius[i]*2,radius[i]*2);
      line(centers[i-1].x,centers[i-1].y,centers[i].x,centers[i].y);
    }
  }
  
  tuple last = circ(d*radius.length,radius[radius.length-1],centers[centers.length-1]);
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
tuple circ(float deg, int rad, tuple center){
  float x;
  float y;
  x = center.x + rad * cos(deg+PI/2);
  y = center.y + rad * sin(deg+PI/2);
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
    
      tuple c0 = circ(d*j,radius[j-1],c[j-1]);
      c[j] = c0;
    }
  
    point = circ(d*radius.length,radius[radius.length-1],c[c.length-1]);
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