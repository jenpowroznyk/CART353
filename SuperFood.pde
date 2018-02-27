class SuperFood
{
  // SuperFood variables
  float superSize = 5;
  float dif = 5; 
  float sfGrowthB = 0;
  float sfGrowth = 0;
  float sfWidth = 10;
  float sfHeight = 10;
  float x = random(600);
  float y;
  float colDistance = 0;

  SuperFood()
  {
  }
 // draw the SuperFood
  void display()
  {
    // used to anchor SuperFood to bottom of screen 
    y = height / 2 - sfHeight/2;

    noStroke();
    fill(255, 127, 80, 160);
    ellipse(x, y, sfGrowthB + dif, sfGrowthB + dif);
    fill(255);
    ellipse(x, y, sfGrowth, sfGrowth);
  }

 //method for the pulsing animation 
  void grow()
  {

    if (sfGrowth < sfGrowthB + dif)
    { 
      if (sfGrowthB < superSize)
      {
        sfGrowthB += 0.1;
      }
      sfGrowth += 0.1;
    } else
    {
      sfGrowth = 0;
      sfGrowthB = 0;
    }
  }
 // method for removing SuperFood if it has collided with Rolly
  void collide()
  {  
    //measure the distance of roll objects x, y position, to the disance of each food objects x, y position
    float distance = dist(roll.position.x, roll.position.y, x, y);

    //if the distance considering the roll and food objects radius is less than or equal to the collision distances value
    //then remove the food object from the list array and decrease the Rolly size
    if (distance - abs(roll.size / 2 + sfGrowthB / 2) <= colDistance)
    {      

      if (roll.size > 5)
      {
        roll.size -= 5;
      }

      superFoodArrayList.remove(this);
    }
  }
}