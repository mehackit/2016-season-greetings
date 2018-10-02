class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;

  float diameter;
  float r,g,b, z;
  int fadeOut = 0;
  int duration = 450;
  float sinX = 0;

  Particle(float x, float y, float zIn, float rIn, float gIn, float bIn) {
    position = new PVector(x, y);
    velocity = new PVector(0, random(0, 1));
    acceleration = new PVector(0, random(0.005, 0.02));
    z = zIn;
    r = rIn;
    g = gIn;
    b = bIn;
    diameter = random(1,12);
  }

  void simulate() {
    velocity.add(acceleration);
    position.add(velocity);
    fadeOut = fadeOut + 1;
    sinX += 0.015;
  }

  void draw() {
    noStroke();
  
    fill(r, g, b,  map(fadeOut, 0, duration, 255, 0));
    // diameter = map(fadeOut, 0, duration, 2, 20 + (z*65));
    ellipse(position.x+sin(sinX)*10, position.y, diameter, diameter);
    
  }

  boolean isDead() {
    if (fadeOut > duration || position.y > (height+diameter)) {
      return true;
    }
    return false;
  }
  
  PVector getPosition() {
    return position;
  }
}