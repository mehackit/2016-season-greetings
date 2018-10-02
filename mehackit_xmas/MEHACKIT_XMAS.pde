import oscP5.*;
import netP5.*;

OscP5 oscP5; 
NetAddress sonicPi; 

int snowFlakeSummonAmount = 14;
PVector leftHand = new PVector(0,0,0);
PVector rightHand = new PVector(0,0,0);
int users = 0;
float r, g, b;
float rAdd;
float gAdd;
float bAdd;
float time;
float flakeTime;
float ry;
float sinX;
float textX;

ArrayList<Particle> particles;
ArrayList<SnowFlake> snowFlakes;

PShape logo;
String texti;
PFont fontti;

void setup() {
  size(1280, 720, P3D);
  //fullScreen(P3D);
  smooth();
  oscP5 = new OscP5(this, 8000);
  sonicPi = new NetAddress("127.0.0.1",4559); 

  particles = new ArrayList<Particle>();
  snowFlakes = new ArrayList<SnowFlake>();
  
  r = 255;
  g = 0  ;
  b = 155;
  rAdd = -0.5;
  gAdd = -0.4;
  bAdd = -0.6;
  
  time = millis() + random(50, 400);
  flakeTime = millis() + random(800,100);
  
  logo = loadShape("data/mehackit.obj");
  logo.disableStyle();
  logo.setFill(color(255,255,255,0));
  logo.setStroke(color(255));
  
  fontti = loadFont("q24.vlw");
  textFont(fontti, 24);
  // textSize(32);
  textAlign(LEFT);
  textX = width;
  texti = "Merry Christmas & Happy New Year 2017!";
}

void draw() {
  
  // Update background colors on each cycle
  
  r = r + rAdd;
  g = g + gAdd;
  b = b + bAdd;
  
  background(r, g, b);
  lights();
  
  // Summon SNOW particles 
  
  if (time <= millis()) {
    time = millis() + random(5, 100);
    
    // Particle with random colors :)
    // Particle p1 = new Particle(random(0, width), -20, 0, random(0, 255), random(0, 255), random(0, 255));
    for (int i = 0; i < snowFlakeSummonAmount; i++) {
      Particle p1 = new Particle(random(-5, width+5), -30, 0, 255, 255, 255);
      particles.add(p1);
    }
  }
  
  // Summon SNOWFLAKES
  
  if (flakeTime <= millis()) {
    flakeTime = millis() + random(400, 600);
    
    float x = random(0, width);
    float y = random(5, 200);
    
    SnowFlake s1 = new SnowFlake(x, y, 0);
    snowFlakes.add(s1);
    
    sendOscFlake();
    
    //line(x-20, y-20, x+20, y+20);
    //line(x+20, y-20, x-20, y+20);
  }
  
  if (mousePressed == true) {
    SnowFlake s1 = new SnowFlake(mouseX, mouseY, 0);
    snowFlakes.add(s1);
    
    sendOscFlake();    
  }
  
  stroke(255,255,255,255);
  fill(255,255,255,120);
  text(texti, textX, height -30);
  
  pushMatrix();
  stroke(255,255,255,255);
  fill(255,255,255,map(sin(sinX),-1,1,40,255));
  translate(width/2, height/2 + 60, 240);
  rotateZ(PI);
  rotateY(ry);
  shape(logo);
  popMatrix();
    
  // Draw SNOW particles 
  
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    
    p.simulate();
    p.draw();
  }
  
  // Draw SNOWFLAKES 

  for (int i = 0; i < snowFlakes.size(); i++) {
    SnowFlake s = snowFlakes.get(i);
    
    s.simulate();
    pushMatrix();
    s.draw();
    popMatrix();
  }
  
  // Check that color values stay within boundaries

  if (r <= 0 || r >= 255) rAdd = -1 * rAdd;
  if (g <= 0 || g >= 100) gAdd = -1 * gAdd;
  if (b <= 0 || b >= 255) bAdd = -1 * bAdd;
  
  // Remove SNOW particles that are off-screen
  // Otherwise the program would start to slow down a lot...
  
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    
    if (p.isDead() == true) {
      particles.remove(i);
    }
  }
  
  // Same thing for dem SNOWFLAKES
  
  for (int i = snowFlakes.size() - 1; i >= 0; i--) {
    SnowFlake s = snowFlakes.get(i);
    
    if (s.isDead() == true) {
      snowFlakes.remove(i);
    }
  } 
  
  ry += 0.02;
  sinX += 0.02;
  textX -= 2;
  
  if (textX <= 0-textWidth(texti)) textX = width;
  
  //saveFrame("frames/####.tif");
}

void sendOscFlake() {
  OscMessage toSend = new OscMessage("/snowflake");
  toSend.add((int)random(0,21));
  oscP5.send(toSend, sonicPi);
  println(toSend); 
}