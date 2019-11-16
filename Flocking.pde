Flock flock;
PGraphics pg;
void setup() 
{
  size(800,640,P3D);
   background(255,255,255);
   //colorMode(HSB, width, height, 100); 
   frameRate(20);
  flock = new Flock();
  // Add an initial set of boids into the system

  for (int i = 0; i < 10; i++) {
    zombie z = new zombie(width/2,height/2);
    flock.addghosts(z);
    
   }
  
  for(int i=0;i<10;i++){
    human h =new human(width/2,height/2);
    flock.addhuman(h);
  }
  pg=createGraphics(80,80,P2D);
  smooth();
}

void draw() {
  
  flock.runzombie();
  flock.runhuman();
  
}

// Add a new boid into the System
void mousePressed() {
  flock.addghosts(new zombie(mouseX,mouseY));
}

