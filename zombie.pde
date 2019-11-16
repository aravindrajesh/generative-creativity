//human hum;
//movement movement;
class zombie
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector attraction;
  float r;
  float maxforce;
  float maxspeed;
  float maxrepel;

  zombie(float x, float y)
  {
    acceleration =new PVector(0.001, .002);
    velocity =new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    attraction= new PVector(0.001, 0.002);
    r=2;
    maxspeed =0.5;
    maxforce=0.06;
    maxrepel=0.07;
  }
  void run(ArrayList<zombie> ghost, ArrayList<human> humans) 
  {
    flock(ghost, humans);
    update();
    edge();
    render();
  }
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }

  void flock(ArrayList<zombie> zombies, ArrayList<human> humans)
  {
    PVector sep =seperate (zombies);
    PVector ali = alignment(zombies);
    PVector coh = cohesion(zombies);
    PVector att= cohesiony(zombies, humans);



    sep.mult(2.5);
    ali.mult(1.0);
    coh.mult(1.0);
    att.mult(1.0);

    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(att);
  }

  PVector seeky(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer=PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }

  PVector  cohesiony (ArrayList<zombie> zombies, ArrayList<human> humans) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (zombie ghosts : zombies)
    {
      for (human h:humans)
      {
        float d = PVector.dist(h.hlocation, ghosts.location);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(h.hlocation); // Add location
          count++;
        }
      }
    }
    if (count > 0) {
      sum.div(count);
      return seeky(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }

  void update()
  {
    velocity.add (acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }
  PVector seek(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer=PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }
  void render()
  {
    float theta=velocity.heading2D()+radians(90);
    fill(255, 255, 255);
    stroke(247, 25, 25);
    pushMatrix();
    translate(location.x, location.y, 50);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
    beginShape();
    curveVertex(location.x, location.y);
    endShape();
  }
  void curves()
  {
    fill(255);
    stroke(255, 0, 0);
    beginShape();
    curveVertex(location.x, location.y);
    curveVertex(location.x, location.y);
    curveVertex(location.x, location.y);
    curveVertex(location.x, location.y);
    curveVertex(location.x, location.y);
  }

  void edge()
  {

    if (location.x > width) {
      location.x = 0;
    } 
    else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    }  
    else if (location.y < 0) {
      location.y = height;
    }
  }

  PVector seperate(ArrayList<zombie> zombies)
  {
    float desiredseperation=45.0f;
    PVector steer =new PVector(0, 0, 0);
    int count=0;
    for (zombie ghosts:zombies)
    {
      float d=PVector.dist(location, ghosts.location);
      if ((d>0)&&(d<desiredseperation))
      {
        PVector diff=PVector.sub(location, ghosts.location);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count>0) {
      steer.div((float)count);
    }
    if (steer.mag()>0)
    {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  PVector alignment (ArrayList<zombie> zombies)
  {
    float neighbourdist= 50;
    PVector sum=new PVector(0, 0);
    int count=0;
    for (zombie ghosts:zombies)
    {
      float d=PVector.dist(location, ghosts.location);
      if ((d > 0) && (d < neighbourdist)) {
        sum.add(ghosts.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  PVector cohesion (ArrayList<zombie> zombies) {
    float neighbordist = 30;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (zombie ghosts : zombies) {
      float d = PVector.dist(location, ghosts.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(ghosts.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
}

