//  x Change text index to JSON data //<>// //<>//
//  x Split dictionaries into "days"
//  x Create a check for if day is "positive" or "negative"
//    Create Input for log data
//  x Assign new "negative" + "positive" values to each task in a day
//    Create outputs for mood scale
//    Assume what clump of tasks create what moods
//    Create general interface 
//    Create a function for measuring certainty of prediction
//    Input time value AND see if it's possible to also guage based on time spent. 

//    if they appear in the same dailyTaskArray --> take their average mood value (from when they appear together),  compare it to each of their mood values without eachother
//    --> This tells you how much happier one is when they do 2 things together over with other combinations of things. 


import java.util.Map;

JSONArray dailyData;
JSONObject day;
JSONArray dailyTasks;
JSONArray userTasks;

String[] moodTest;

void setup()
{
  size(600, 400);

  // create global variables for input json array and output json array
  dailyData = loadJSONArray("data2.json");
  userTasks = loadJSONArray("usertasks.json");

  // run through the array of day objects that is input by the user
  for (int i = 0; i < dailyData.size(); i ++)
  {
    // get the "mood" value and the array of tasks in each day object
    day = dailyData.getJSONObject(i);
    String mood = day.getString("mood");
    dailyTasks = day.getJSONArray("dailyTaskList");

    // for each day object, check if the value at key "mood" is "positive"
    // if it does match, then get each object in the "dailyTaskArray" and get the task name and time spent
    moodTest = match(mood, "positive");
    if (moodTest != null)
    {
      for (int j = 0; j < dailyTasks.size(); j++)
      {        
        JSONObject individualTaskData = dailyTasks.getJSONObject(j);
        String taskName = individualTaskData.getString("task");
        float hours = 0;

        // if the task name doesn't exist in usertasks.json already...call the add new entry to user tasks function and pass isPositive as true
        if (!DoesEntryExistInUserTasks(taskName, userTasks, true, hours))
        {
          AddNewEntryToUserTasks(taskName, userTasks, true, hours);
        }
      }
    } else 
    {
      // if the value at the "mood" key does not match "positive", then get each object in the "dailyTaskArray" and get the task name and time spent values
      // if the DoesEntryExistInUserTasks returns false, then pass false to the isPositive boolean and call the AddNewEntryToUserTasks function
      for (int j = 0; j < dailyTasks.size(); j++)
      {

        JSONObject individualTaskData = dailyTasks.getJSONObject(j);
        String taskName = individualTaskData.getString("task");
        float hours = 0;

        if (!DoesEntryExistInUserTasks(taskName, userTasks, false, hours))
        {
          AddNewEntryToUserTasks(taskName, userTasks, false, hours);
        }
      }
    }
  }

  // creating a hashmap that is returned by the "ScaleValues()" function
  HashMap<String, Float> myData = ScaleValues(GetMaxValue(userTasks), GetMinValue(userTasks), userTasks);
}

// Draws the chart in the sketch
void draw()
{
}

// function for appending new task to array in the usertasks json file
void AddNewEntryToUserTasks(String newTaskName, JSONArray userTasks, boolean isPositive, float hours)
{
  // setting our keys + values in the newEntry json object, appending newEntry to the usertasks json array, and saving that data. 
  //shorthand if statement, ? (the question - is it true) first value yes second value no 
  int value = isPositive ? 1 : -1;
  JSONObject newEntry = new JSONObject();
  newEntry.setString("taskName", newTaskName);
  newEntry.setInt("value", value);
  newEntry.setInt("occurances", 1);
  newEntry.setFloat("totalTime", hours);
  userTasks.append(newEntry);
  saveJSONArray(userTasks, "data/usertasks.json");
}

// function for updating data associated with existing tasks in the "usertasks" json array 
void UpdateExisitingEntryInUserTasks(int indexOfEntry, JSONArray userTasks, boolean isPositive, float hours)
{

  //shorthand if statement, ? (the question - is it true) first value yes second value no 
  // if isPositive returns true "value" = 1, otherwise "value" = -1
  int value = isPositive ? 1 : -1;

  // then what is the DailyTaskArray size?
  // Add all the tasks individual values. 
  // divide them by the DailyTaskArray size. 

  // at each index passed get the int at "value" key and add "value"
  // then set the new value in the json usertasks document
  value += userTasks.getJSONObject(indexOfEntry).getInt("value");
  userTasks.getJSONObject(indexOfEntry).setInt("value", value);

  // get the value of occurances stored in the json usertasks document and increment it by 1 
  // then store that new value in the json usertasks document
  int occurance = userTasks.getJSONObject(indexOfEntry).getInt("occurances");
  occurance++;
  userTasks.getJSONObject(indexOfEntry).setInt("occurances", occurance);

  // get the value of totalTime stored in the json usertasks document and increment it by the amount of hours spent on the new entry for that task
  // then store that new value in the json usertasks document
  hours += userTasks.getJSONObject(indexOfEntry).getFloat("totalTime");
  userTasks.getJSONObject(indexOfEntry).setFloat("totalTime", hours);

  // save the changed usertasks json array to the usertasks.json file
  saveJSONArray(userTasks, "data/usertasks.json");
}

// function returning a boolean value for whether a task exists in usertask.json array or not
boolean DoesEntryExistInUserTasks(String taskName, JSONArray userTasks, boolean isPositive, float hours)
{
  // run through the userTask array 
  for (int i = 0; i < userTasks.size(); i++)
  {  
    // checking if taskName from the input data is the same as the value stored at the "taskName" key in the output data at each object in the array
    // if so, DoesEntryExistInUserTasks() returns true and we call the function for updating existing data passing the index 
    if (taskName.equalsIgnoreCase(userTasks.getJSONObject(i).getString("taskName")))
    {
      UpdateExisitingEntryInUserTasks(i, userTasks, isPositive, hours);
      return true;
    }
  }

  // otherwise return false
  return false;
}

// function for scaling the scores of each task 
// ScaleValues returns a hashmap.
HashMap<String, Float> ScaleValues(int max, int min, JSONArray userTasks)
{

  HashMap<String, Float> userTaskValues = new HashMap<String, Float>();

  // find biggest absolute value(ignore negative of min if negative)
  // create a ceiling 
  int absoluteMin = Math.abs(min);
  int ceiling = max;

  // if the value of max is smaller than the absoluteMin value, make the ceiling equal to the absoluteMin value.
  if (max < absoluteMin)
  {
    ceiling = absoluteMin;
  }

  // make a scale ratio by dividing the largest number by 100
  float scaleRatio = 100 / ceiling;

  // run through the usertasks.json array and at every object get the "taskName" key value and put it in taskName
  // and get the "value" key value and put it in value
  // multiply the value by the scale ratio
  for (int i = 0; i < userTasks.size(); i++)
  {
    String taskName = userTasks.getJSONObject(i).getString("taskName");
    float value = userTasks.getJSONObject(i).getInt("value");
    value *= scaleRatio;

    // place the task name and the scaled value in the userTaskValues hashmap
    userTaskValues.put(taskName, value);
  }

  for (Map.Entry value : userTaskValues.entrySet()) 
  {
    print(value.getKey() + " is ");
    println(value.getValue());
  }

  // return the hashmap
  return userTaskValues;
}

// get the maximum value in the usertasks.json array 
int GetMaxValue(JSONArray userTasks)
{
  // set a really low number for the max so that the found max value is able to be stored
  int max = -100000000;

  // run through the usertasks.json array and get the "value" keys value at each index
  for (int i = 0; i < userTasks.size(); i++)
  {
    int value = userTasks.getJSONObject(i).getInt("value");

    // if the value recieved is bigger than max, then max = value 
    if (value > max)
    {
      max = value;
    }
  }
  // return the highest number stored in the usertasks.json array 
  return max;
}

// Return function for ensuring the min value of the barChart is set to the smalles time value in the log
// This is to ensure that the values are never too small to be displayed
int GetMinValue(JSONArray userTasks)
{
  int min = 1000000000;

  for (int i = 0; i < userTasks.size(); i++)
  {
    int value = userTasks.getJSONObject(i).getInt("value");

    if (value < min)
    {
      min = value;
    }
  }
  return min;
}

// eat 76
// 67
// 23
// min 20 , max 80 