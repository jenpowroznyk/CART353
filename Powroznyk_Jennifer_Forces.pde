
/* 
 1.   x Make food items into list ( so can spawn them like crazy) 
 2.   x Destroy food items on collision 
 3.   x Spawn food objects
 4.   x Grow :)
 5.   x Fix Movement 
 6.   x Limit Rolly Size Increase/ Decrease
 7.   x Add obstacles
 8.     Add force to Rolly Movement
 9.   x Add gravity!
 10.    Create endless stream of bumpers
 11.  x Create spawn limit!
 12.  x Collision detection for obstacles
 13.  x Create bounds for everything
 14.    Create / apply other forces
 15.    Fix Mass
 */

// variables for spawn times
int time = 0;
float timeDifference = random(10000, 20000);

// variables for bump array size
int bumpCount = 4;

// creating rolly var
Rolly roll;

// creating ArrayList's (They're awesome)
ArrayList<Food> foodArrayList = new ArrayList<Food>();
ArrayList<SuperFood> superFoodArrayList = new ArrayList<SuperFood>();
ArrayList<Obstacle> obstacleArrayList = new ArrayList<Obstacle>();
ArrayList<Bumper> bumpArrayList = new ArrayList<Bumper>();

void setup()
{
  size(600, 400);

  //make an array list of 5 Foods 
  for (int i = 0; i < 5; i++) 
  {
    //add a new Food
    foodArrayList.add(new Food());
  }
  //make an array list of 3 SuperFoods
  for (int i = 0; i < 3; i++) 
  {
    //add a new superFood
    superFoodArrayList.add(new SuperFood());
  }
  //make an array list of 4 Obstacles
  for (int i = 0; i < 4; i++) 
  {
    //add a new Obstacle
    obstacleArrayList.add(new Obstacle());
  }
  //make an array list of Bumpers to the size of bumpCount
  for (int i = 0; i < bumpCount; i++)
  {
    //add a new Bumper
    bumpArrayList.add(new Bumper(random (3, 20), random(height), random(width), random(1, 3)));
  }
  // instantiate new rolly
  roll = new Rolly(300, 200, 30);
}

void draw()
{

  background(255);
  // if milliseconds are over 3000, add a new food and time is now equal to current millisecond 
  if (millis() > time + timeDifference)
  {

    // Limit the possible amount of spawns to 5
    if (superFoodArrayList.size() < 5)
    {
      // create a new SuperFood
      superFoodArrayList.add(new SuperFood());
    }

    // Limit the amount of possible spawns to 7
    if (foodArrayList.size() < 7)
    {
      // create new Food
      foodArrayList.add(new Food());
    }

    // make the time value equal to the current millis so that the counter doesn't stop after the first cycle
    time = millis();
  }

  // if the array list size is less than 4 create a new Obstacle
  if (obstacleArrayList.size() < 4)
  {
    obstacleArrayList.add(new Obstacle());
  }
  // for each item of type food in foodArray, call collide()
  for (int i = 0; i < foodArrayList.size(); i++)
  { 
    //run through obj in food array list, call collide method for each 
    foodArrayList.get(i).collide();
  }
  // for each item of type food in superfoodArray, call collide()
  for (int i = 0; i < superFoodArrayList.size(); i++)
  { 
    //run through obj in superFood array list, call collide method for each 
    superFoodArrayList.get(i).collide();
  }
  // for each item of type food in objectArray, call collide()
  for (int i = 0; i < obstacleArrayList.size(); i++)
  { 
    //run through obj in object array list, call collide method for each 
    obstacleArrayList.get(i).collide();
  }

  // Display our objects
  for (Obstacle ob : obstacleArrayList)
  {
    ob.display();
  }

  for (Food f : foodArrayList)
  {
    f.display();
  }

  for (SuperFood sf : superFoodArrayList)
  {
    sf.display();
    // call the grow function
    sf.grow();
  }

  // display and move Bumper objects
  for (Bumper bump : bumpArrayList)
  {
    // for each instance of a Bumper object call the attract method in Rolly 
    roll.applyBumperAttract(bump);
    // if the Bumpers have passed the sketch width, replace them before 0 on the x axis, give them a random y, mass and speed value
    if (bump.position.x > width)
    {
      bump.position.x = random(-10, -5);
      bump.position.y = random(height);
      bump.mass = random(3, 20);
      bump.bumpSpeed = random(1, 3);
    }

    bump.display();
    bump.move();
  }

  // for each item of type Bumper in bumpArray, call push()
  for (int i = 0; i < bumpArrayList.size(); i++)
  {
    bumpArrayList.get(i).push();
  }
  
  roll.display();
  roll.makeForceRelativeToSize();
  roll.update();
}

// if keyPressed call applyForceFromInput method in roll object
void keyPressed()
{ 
  roll.applyForceFromInput();
}

// if keyReleased call checkKeyRelease method in roll object
void keyReleased()
{
  roll.checkKeyRelease();
}