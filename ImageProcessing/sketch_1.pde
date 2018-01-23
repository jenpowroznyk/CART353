userImage img1;
userImage img2;

void setup()
{
  size(500, 500);
  
  img1 = new userImage("1.jpg");
  img2 = new userImage("2.jpg");
}

void draw()
{
  img1.getPixel();
  img2.getPixel2();
 
  if (mouseX < height/2 && key == 'o') {
   img1.getPixel3();

   }if (mouseX > height/2 && key == 'o')
    {
       img2.getPixel4();
  }

  if(mousePressed)
  {
    img1.getPixel5();
    
  }s
               
    if (key == 's' || key == 'S') 
    {
     rect(20, 20, 20, 20);
     save("cute.jpg");
    }
 
}