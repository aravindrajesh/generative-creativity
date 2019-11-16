class Flock
{
  ArrayList<zombie> ghosts;
  ArrayList<human> humans;
  
  Flock()
  {
    ghosts=new ArrayList<zombie>();
    humans =new ArrayList<human>();
  }
  
  void runzombie()
  {
    for(zombie z:ghosts)
    {
      z.run(ghosts,humans);
    }
  }
  
  void runhuman()
  {
    for(human h:humans)
    {
      h.run(ghosts,humans);
    }
  }
 void addghosts(zombie z){
  ghosts.add(z);
}
void addhuman(human h)
{
  humans.add(h);
}
}

