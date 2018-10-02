class SnowFlake {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PImage image;

  float scale;
  float r,g,b, z;
  int fadeOut = 0;
  int duration = 250;
  float sinX = 0;
  float rotator = 0;
  float rotatorRate;
  float glowAlpha;
  int rotatorDirection;
  
  SnowFlake(float x, float y, float zIn) {
    image = loadImage("data/snowflake.png");
    
    position = new PVector(x, y);
    velocity = new PVector(0, random(1, 2));
    acceleration = new PVector(0, random(0.005, 0.02));
    z = zIn;

    scale = random(30,60);
    sinX = random(0, 2.0);
    rotatorRate = random(0.01, 0.06);
    if (random(0,2) >= 1) {
      rotatorDirection = 1;
    }
    else {
      rotatorDirection = -1;
    }
    // print (rotatorDirection);
    // print("SnowFlake Created");
    glowAlpha = random(0.6, 0.9);
  }

  void simulate() {
    velocity.add(acceleration);
    position.add(velocity);
    fadeOut = fadeOut + 1;
    sinX += 0.02;
    rotator += rotatorRate*rotatorDirection;
    glowAlpha -= 0.05;
  }

  void draw() {
    imageMode(CENTER);
    translate(position.x+(scale/2)+sin(sinX)*20, position.y+scale/2);
    rotate(rotator);
    tint(255, map(fadeOut, 0, duration, 255, 0));
    if (glowAlpha > 0) {
      for (int i = 0; i <= 2*scale; i = i + 3) {
        fill(255, i*glowAlpha);
        ellipse(0, 0, 1*(scale-i), 1*(scale-i)); 
      }
    }
    image(image, 0, 0, scale, scale);
    
    
    // image(image, position.x+sin(sinX)*20, position.y, scale, scale);
    rotate(-rotator);
    translate(-position.x-scale/2, -position.y-scale/2);
    // fill(r, g, b,  );
    // diameter = map(fadeOut, 0, duration, 2, 20 + (z*65));
    // ellipse(position.x, position.y, diameter, diameter);
    
  }

  boolean isDead() {
    if (fadeOut > duration || position.y > (height+scale)) {
      return true;
    }
    return false;
  }
}