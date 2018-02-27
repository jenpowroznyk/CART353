class Rolly  //<>// //<>//
{
  // Rolly variables
  PVector position;
  PVector velocity;
  PVector gravity;
  PVector jumpForce;
  PVector acceleration;

  float size;
  float maxSpeed = 5;
  float rollySpeed = 0.5;

  boolean moveLeft;
  boolean moveRight;
  boolean moveUp;
  boolean moveDown;
  boolean jump;

  // Rolly constructor
  Rolly(float x, float y, float size)
  {
    this.size = size;
    this.velocity = new PVector(0, 0);
    this.position = new PVector(x, y);
    this.gravity = new PVector(0, .5);
    this.jumpForce = new PVector(0, -30);
    this.acceleration = new PVector(0, 0);
  }

  // draw the Rolly and call the move method
  void display()
  {
    noStroke();
    fill(255, 127, 80, 160);
    ellipse(position.x, position.y, size, size);
    move();
  }
  // if a certain key is pressed, the condition for the if statements are true and add a direction to Rollys acceleration
  void move()
  {
    if (moveUp)
    {
      PVector up = new PVector(0, -rollySpeed);
      acceleration.add(up);
    } 
    if (moveDown) 
    {
      PVector down = new PVector(0, rollySpeed);
      acceleration.add(down);
    } 
    if (moveRight) 
    {
      PVector right = new PVector(rollySpeed, 0);
      acceleration.add(right);
    } 
    if (moveLeft) 
    {
      PVector left = new PVector(-rollySpeed, 0);
      acceleration.add(left);
    }
    // if enter is pressed, add jumpForce to the position and set jump to false
    if (jump)
    {
      position.add(jumpForce);
      jump = false;
    }

    // ensure that if we aren't pressing any key, our Rolly's object has a velocity of 0
    if (!moveRight && !moveLeft && !moveUp && !moveDown)
    {
      velocity.mult(0);
    }
  }

  // method to make the size of the Rolly relative to acceleration 
  void makeForceRelativeToSize()
  {
    PVector force = new PVector(0, 0);
    PVector f = PVector.div(force, size);
    acceleration.add(f);
  }

  // update the Rolly's position
  void update()
  {
    // if acceleration isn't 0 add acceleration to velocity
    if (acceleration.mag() > 0)
    {
      velocity.add(acceleration);
    }
    // limit the current velocity is greater than the set maxSpeed, make the velocity 1 and increase it by maxSpeed
    // so the velocity doesn't accumulate forever
    if (velocity.mag() > maxSpeed)
    {
      velocity.normalize();
      velocity.mult(maxSpeed);
    }
    // really ugly condition ensuring Rolly doesn't leave the sketch considering velocity
    if ((position.x + velocity.x) - size/2 > 0 && (position.x + velocity.x) + size/2 < width && (position.y + velocity.y)  + size/2 < height && (position.y + velocity.y) - size/2 > 0)
    {
      position.add(velocity);
    }

    acceleration.mult(0);
  }

  // if keyPressed booleans necessary for applying direction are true
  void applyForceFromInput()
  {

    if (keyCode == UP)
    {
      moveUp = true;
    }

    if (keyCode == DOWN) 
    {
      moveDown = true;
    }

    if (keyCode == RIGHT) 
    {
      moveRight = true;
    }

    if (keyCode == LEFT) 
    {
      moveLeft = true;
    }

    if (keyCode == ENTER)
    {
      jump = true;
    }
  }
  // if keyReleased booleans necessary for applying direction are false
  void checkKeyRelease()
  {
    if (key == CODED) {

      if (keyCode == UP)
      {
        moveUp = false;
      }

      if (keyCode == DOWN) 
      {
        moveDown = false;
      }

      if (keyCode == RIGHT) 
      {
        moveRight = false;
      }

      if (keyCode == LEFT) 
      {
        moveLeft = false;
      }
    }
  }

  // method for applying Bumper objects attract method
  void applyBumperAttract(Bumper bump)
  {
    // variable containing the value returned from Bumper attract method
    PVector f = bump.attract(this);
    // if f's magnitude is greater than max velocity divided by a lot
    if (f.mag() > maxSpeed/27); 
    {
      f.normalize();           // set f's magnitude to 1
      f.mult(maxSpeed/27);     // then cap f at a fraction of the maxSpeed
    }
    acceleration.add(f);       // add this force to acceleration
  }
}