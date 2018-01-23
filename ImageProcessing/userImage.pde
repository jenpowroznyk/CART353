class userImage
{
  PImage img;
  String imageFile;
  float r, g, b;
  float r2, g2, b2;
  float xPos, yPos;
  float i = 255;
  
  
  userImage(String imageFile)
  {
  img = loadImage(imageFile);
  
  }
  

  void display(float xPos, float yPos)
  {
    background(0);
    image(img, xPos, yPos);
  }
  

  void getPixel()
  {
      loadPixels();
      img.loadPixels();
      
      for (int y = 0; y < height; y++)
      {
        for(int x = 0; x < width; x++)
        {
          int loc = x + y * width;
          float r2 = red(img.pixels[loc]);
          float g2 = green(img.pixels[loc]);
          float b2 = blue(img.pixels[loc]);
          
          
          
          color c = color(r2, g2, b2, 100);
          pixels[loc] = c;
        }
      updatePixels();
      }
  } 
 
  void getPixel2()
  {
    loadPixels();
      img.loadPixels();
      
      for (int y = 0; y < height; y++)
      {
        for(int x = 0; x < width; x++)
        {
          int loc = x + y * width;
          float r = red(pixels[loc]);
          float g = green(img.pixels[loc]);
          float b = blue(pixels[loc]);
          
          float changeR = map(mouseX, 0, width, 0, 500);
          float changeB = map(mouseY, 0, width, 0, 500);
          
          color c = color(r + changeR, g, b + changeB);
          pixels[loc] = c;
          
        }
      }
      updatePixels();
   }
  
  
  void getPixel3()
  {
    loadPixels();
      img.loadPixels();
      
      for (int y = 0; y < height/2; y++)
      {
        for(int x = 0; x < width; x++)
        {
          int loc = x + y * width;
          float r = red(img.pixels[loc]);
          float g = green(img.pixels[loc]);
          float b = blue(img.pixels[loc]);
         
          
          color c = color(r + random(255), g, b);
          pixels[loc] = c;
          
 
        }
      }
      updatePixels();
    }
 
   void getPixel4()
  {
    loadPixels();
      img.loadPixels();
      
      for (int y = 0; y < height; y++)
      {
        for(int x = 0; x < width/2; x++)
        {
          int loc = x + y * width;
          float r = red(img.pixels[loc]);
          float g = green(img.pixels[loc]);
          float b = blue(img.pixels[loc]);
         
          
          color c = color(r, g + random(255), b);
          pixels[loc] = c;
          
 
        }
      }
      updatePixels();
    }
    
     void getPixel5()
  {
    loadPixels();
      img.loadPixels();
      
      for (int y = 0; y < height; y++)
      {
        for(int x = 0; x < width; x++)
        {
          int loc = x + y * width;
          float r = red(pixels[loc]);
          float g = green(pixels[loc]);
          float b = blue(pixels[loc]);
            
            if (mousePressed)
            {
                color c = color(random(255), g, b);
                pixels[loc] = c;
            }        
            
        }
      }
      updatePixels();
    }
}
  