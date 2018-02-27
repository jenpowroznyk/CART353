class Food
{
  // food variables
  float size = 10;
  float x = random(600);
  float y;
  float colDistance = 0;
  boolean counter;

  Food()
  {
  }

  void display()
  {
    // used to anchor food to bottom of screen 
    y = height / 2 - size/2;

    noStroke();
    fill(0);
    ellipse(x, y, size, size);
    fill(255);
    ellipse(x, y, size / 1.5, size / 1.5);
  }

  // method for removing Food if it's collided with by Rolly
  void collide()
  {  
    //measure the distance of roll objects x, y position, to the disance of each food objects x, y position
    float distance = dist(roll.position.x, roll.position.y, x, y);
    
    //if the distance considering the roll and food objects radius is less than or equal to the collision distances value
    if (distance - abs(roll.size / 2 + size / 2) <= colDistance)
    {      
      //then remove the food object from the list array 
      foodArrayList.remove(this);
  
    }
  }
}