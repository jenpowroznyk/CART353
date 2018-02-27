class Bumper { //<>// //<>// //<>// //<>//

  // create variables for Bumper class
  float size = random(50, 100); 
  float mass;
  float G; 
  float colDistance = 0;
  float bumpSpeed;
  boolean canAttract;
  //create a PVector for the Bumpers position and assign it the value of x and y in the constructor
  PVector position;

  Bumper(float m, float x, float y, float s)
  {
    mass = m;
    position = new PVector(x, y);
    G = 1;
    this.bumpSpeed = s;
  }

  // function for attracting the Rolly object 
  // taken from CART 353 exerc_2_8 with Rilla Khaled
  PVector attract(Rolly roll) {

    // create a condition so that if the collision distance between Rolly and Bumper instance is more than 100
    // we can go ahead and apply the attraction force on Rolly
    if (canAttract)
    {
      PVector force = PVector.sub(position, roll.position);   // calculate direction of force considering the Bumper position and the Rolly position
      float d = force.mag();                              // get the magnitude (distance between objects) of the force vector 
      d = constrain(d, 1, 40);                        // constrain forces magnitude to a value between 1 and 40
      force.normalize();                                  // normalize the force vector (make it's magnitude 1)
      float strength = (G * mass * roll.size) / (d * d);      // calculate gravitional force magnitudem NOTE: this equation remains confusing to me. I now understand that the force is relative to the objects mass, direction and gravity
      force.mult(strength);                                  // add the attraction stregth equation to the force vector
      return force;                                          // return the value of force to vector f in the applyBumperAttract method when attract() is called
    }

    return new PVector(0, 0);                                // return a value of 0 because vector f expects one
  }
  // display the ellipse 
  void display()
  {
    fill(0);
    ellipse(position.x, position.y, mass, mass);
  }

  // increase ellipses x position by bumpSpeed
  void move()
  {
    position.x += bumpSpeed;
  }

  // method for pushing the rolly away once it collides with the Bumpers
  void push()
  {  
    //measure the distance of Roll obj's x, y position, to the disance of each Bumper obj's x, y position
    float distance = dist(roll.position.x, roll.position.y, position.x, position.y);

    //if the distance considering the Roll and Bumper objects radius is less than or equal to the collision distances value (0)
    if (distance - abs(roll.size / 2 + mass / 2) < colDistance)
    {      
      canAttract = false;                                                     // then cancel the attract method
      roll.maxSpeed = 50;                                                     // max the max speed 50
      PVector swoosh = PVector.sub(roll.position, position);                  // get a direction for swoosh  based on Rolly and Bumper position
      swoosh.normalize();                                                     // make the magnitude of swoosh equal to 1
      swoosh.mult(25);                                                        // multiply swoosh by 25
      roll.velocity.add(swoosh);                                              // add swoosh to roll's velocity   
    } else if (distance - abs(roll.size / 2 + mass / 2) > colDistance + 100)  // if the collision distance between Rolly and Bumper is more than 100, 
    {
      canAttract = true;                                                      // Bumpers can attract the Rolly
      roll.maxSpeed = 3;                                                      // the maximum velocity for Rolly is back to 3 (it's original value)
    }
  }
}