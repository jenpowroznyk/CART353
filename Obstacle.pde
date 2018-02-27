class Obstacle
{
  // Obstacle variables
  float obstacleHeight = random(- 350, - 10);
  float obstacleWidth = 10;
  float x = random(600);
  float y = height;
  float colDistance = 0;
  float G;

  PVector obsPosition;

  Obstacle()
  {
    this.obsPosition = new PVector(x, y);
  }

  // draw the obstacle
  void display()
  {
    stroke(0);
    fill(255);
    rect(obsPosition.x, obsPosition.y, obstacleWidth, obstacleHeight);
    fill(255);
  }
  
 // method for repositioning Obstacle if it's collided with by Rolly and increasing the Rolly size
  void collide()
  {  

    boolean obsLeft = (roll.position.x + roll.size /2 > obsPosition.x);
    boolean obsRight = (roll.position.x - roll.size /2 < obsPosition.x + obstacleWidth);
    boolean obsTop = (roll.position.y + roll.size /2 > obsPosition.y + obstacleHeight);
    boolean obsBottom = (roll.position.y - roll.size /2 < obsPosition.y);

    if (obsLeft && obsRight && obsTop && obsBottom)
    { 
      if (roll.size < 100)
      {
        roll.size += 5;
        //obstacleHeight -= 5;
        obstacleArrayList.remove(this);
      }
    }
  }
}