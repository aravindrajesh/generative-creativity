zombie z;

class human 
{
  PVector hlocation;
  PVector hvelocity;
  PVector hacceleration;
  float hr;
  float hmaxforce;
  float hmaxspeed;
  float hmaxrepel;
  color start=color(0, 0, 0);
  color finish;
  float amt=0.0;
  

  human(float x, float y)
  {
    hacceleration=new PVector(0.001, .002);
    hvelocity=new PVector(random(-1, 1), random(-1, 1));
    hlocation=new PVector(x, y);
    hr=2;
    hmaxspeed =1;
    hmaxforce=0.06;
    hmaxrepel=0.07;
  }
  void run(ArrayList<zombie> zombies, ArrayList<human> human1)
  {

    flock(human1);
    update();
    edge();
    render();
    paint(zombies, human1);
  }

  void flock(ArrayList<human> humans)
  {
    PVector sep =seperate (humans);
    PVector ali = alignment(humans);
    PVector coh = cohesion(humans);
    

    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);


    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  void update()
  {
    hvelocity.add (hacceleration);
    hvelocity.limit(hmaxspeed);
    hlocation.add(hvelocity);
    hacceleration.mult(0);
  }
  PVector seek(PVector target)
  {
    PVector desired = PVector.sub(target, hlocation);
    desired.normalize();
    desired.mult(hmaxspeed);
    PVector steer=PVector.sub(desired, hvelocity);
    steer.limit(hmaxforce);
    return steer;
  }
  void render(color s, color f, float amt)
  {//colorMode(HSB);
    float theta=hvelocity.heading2D()+radians(90);
    //fill(s, f, amt);
    stroke(lerpColor(s, f, amt));
    pushMatrix();
    translate(hlocation.x, hlocation.y, 50);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -hr*2);
    vertex(-hr, hr*2);
    vertex(hr, hr*2);
    endShape();
    popMatrix();
    beginShape();
    curveVertex(hlocation.x, hlocation.y);
    endShape();
  }
  void render()
  {
    float theta=hvelocity.heading2D()+radians(90);
    //fill(89,240,48);
    stroke(74, 234, 12);
    pushMatrix();
    translate(hlocation.x, hlocation.y, 50);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -hr*2);
    vertex(-hr, hr*2);
    vertex(hr, hr*2);
    endShape();
    popMatrix();
    beginShape();
    curveVertex(hlocation.x, hlocation.y);
    endShape();
  }
   void paint (ArrayList<zombie> zombies, ArrayList<human> humans)
  {
    float neighbourdist=9;
    for (zombie z:zombies)
    {
      for (human h:humans)
      {
        float d=PVector.dist(z.location, h.hlocation);
        if ((d<3)||(d<neighbourdist))
        {
          amt+=0.1;
          render(start, finish, amt);
          if (amt>=1)
          {
            amt=0.0;
            start=finish;
            finish=color(random(255), random(255), random(255));
            //render(start, finish, amt);
          }
          
        }
      }
    }
  }
  void curves()
  {
    fill(255);
    stroke(255, 0, 0);
    beginShape();
    curveVertex(hlocation.x, hlocation.y);
    curveVertex(hlocation.x, hlocation.y);
    curveVertex(hlocation.x, hlocation.y);
    curveVertex(hlocation.x, hlocation.y);
    curveVertex(hlocation.x, hlocation.y);
  }

  void edge()
  {

    if (hlocation.x > width) {
      hlocation.x = 0;
    } 
    else if (hlocation.x < 0) {
      hlocation.x = width;
    }

    if (hlocation.y > height) {
      hlocation.y = 0;
    }  
    else if (hlocation.y < 0) {
      hlocation.y = height;
    }
  }

  void applyForce(PVector force)
  {
    hacceleration.add(force);
  }

  PVector seperate(ArrayList<human> humans)
  {
    float desiredseperation=25.0f;
    PVector steer =new PVector(0, 0, 0);
    int count=0;
    for (human h:humans)
    {
      float d=PVector.dist(hlocation, h.hlocation);
      if ((d>0)&&(d<desiredseperation))
      {
        PVector diff=PVector.sub(hlocation, h.hlocation);
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
      steer.mult(hmaxspeed);
      steer.sub(hvelocity);
      steer.limit(hmaxforce);
    }
    return steer;
  }

  PVector alignment (ArrayList<human> humans)
  {
    float neighbourdist= 50;
    PVector sum=new PVector(0, 0);
    int count=0;
    for (human h:humans)
    {
      float d=PVector.dist(hlocation, h.hlocation);
      if ((d > 0) && (d < neighbourdist)) {
        sum.add(h.hvelocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(hmaxspeed);
      PVector steer = PVector.sub(sum, hvelocity);
      steer.limit(hmaxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  PVector cohesion (ArrayList<human> humans)
  {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (human h : humans) {
      float d = PVector.dist(hlocation, h.hlocation);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(h.hlocation); // Add location
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

