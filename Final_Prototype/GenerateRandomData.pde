
/*** 
 Class used to generate an array of day objects with intention of populating the system
 I recieved help writing this class
 ***/

// importing java random library 
import java.util.Random;

// create array of task name options
String[] catalogueOfTasks = {"Homework", "Run", "Gym", "Played Video games", "Programmed", "Dance", "Reading", "Sleeping", "Partying", "Studying", "Went out with friends", "Cooked", "Cleaned", "Watched TV", "Listened to music", "Transit", "Played Guitar", 
  "Surfed the web", "Talked on the phone", "Watched hockey", "Pottery Class", "Tutoring", "Worked", "Played chess", "Played catan", "Went for a walk", "Cuddled my dog" };
class GenerateRandomData
{   

  GenerateRandomData()
  {
  }

  // A long can store extremely large integers
  // https://forum.processing.org/one/topic/using-java-classes.html
  // https://stackoverflow.com/questions/47229709/how-does-java-util-random-work
  
  // passing an integer to tell the function how many day objects to generate 
  void CreateRandomizedJSONData(int sizeOfData)
  {
    // create main array object 
    JSONArray mainArray = new JSONArray();
    // randomMillis is equal to the systems current millisecond (for extra random values)
    Long randomMillis = System.currentTimeMillis();
    // create a new random object of randomMillis
    Random generator = new Random(randomMillis);
    // set the limit of tasks to select from to the length of the catalogue of tasks 
    int numOfTasksToChooseFrom = catalogueOfTasks.length;

     // run this for each day object we are making 
    for (int i = 0; i < sizeOfData; i++)
    {
      // make new json object 
      JSONObject newDayObject = new JSONObject();

      /*** 
      "The nextInt(int n) method is used to get a pseudorandom,
      uniformly distributed int value between 0 (inclusive) and the specified
      value (exclusive), drawn from this random number generator's sequence." (very cool)
      
      Reference: https://www.tutorialspoint.com/java/util/random_nextint_inc_exc.htm
      ***/
      
      // determine mood selection
      int moodValue = generator.nextInt(1000);
      int modifier = generator.nextInt(101);

      // continue until you get not 0 then get another random int between 0 and 101
      while (modifier == 0)
      {
        modifier = generator.nextInt(101);
      }
      // get the remainder of moodValue / modifier 
      // reference: https://processing.org/reference/modulo.html
      moodValue = moodValue % modifier;
      
      // if moodValue isn't between 25 - 75 mood is "positive" otherwise mood is "negative"
      String mood = "";
      if (moodValue < 25 || moodValue > 75)
      {
        mood = "Positive";
      } else
      {
        mood = "Negative";
      }
      
      // set the mood value in the newObject
      newDayObject.setString("mood", mood);

      //Decide number of tasks for the day
      int size = generator.nextInt(6);        // choose between 0 - 6 
      size = (size < 3) ? 3 : size;           // confine size to 3 if it's less than 3 
      JSONArray dailyTasks = new JSONArray(); // create new json array 

      // run through the curren size value
      for (int j = 0; j < size; j++)
      {
        
        //Generate random name and a time value
        int taskNameValue = generator.nextInt(numOfTasksToChooseFrom); // generate a task name value from 0 to numOfTasksToChooseFrom
        float time = generator.nextFloat() * 5;                        // generate a random time value 

        //set the object values into the newTask object
        JSONObject newTask = new JSONObject();
        newTask.setString("task", catalogueOfTasks[taskNameValue] );
        newTask.setFloat("value", time);

        // set the json object in dailyTasks at index
        dailyTasks.setJSONObject(j, newTask);
      }
      // create the new json Object and append it to the main array at index
      newDayObject.setJSONArray("dailyTaskList", dailyTasks);
      newDayObject.setInt("counted", 0);
      mainArray.setJSONObject(i, newDayObject);
    }
    // save the new json array to generatedData.json
    saveJSONArray(mainArray, "data/generatedData.json");
  }
}