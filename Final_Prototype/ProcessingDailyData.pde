class ProcessingDailyData //<>// //<>//
{

  JSONArray inputData;
  JSONArray outputData;
  JSONArray dailyTasks;

  JSONObject day;

  ProcessingDailyData()
  {
  }

  void GetInputData()
  {  
    inputData = loadJSONArray("data/data2.json");
    outputData = loadJSONArray("data/usertasks.json");

    // run through the array of day objects that is input by the user
    for (int i = 0; i < inputData.size(); i++)
    {

      // get the "mood" value and the array of tasks in each day object
      day = inputData.getJSONObject(i);
      int dayCount = day.getInt("counted");
      boolean isCounted = dayCount == 1;
      if (isCounted)
      {
        continue;
      }

      String mood = day.getString("mood");
      dailyTasks = day.getJSONArray("dailyTaskList");

      // for each day object, check if the value at key "mood" is "positive"
      boolean isPositive = mood.equalsIgnoreCase("positive");
      float totalTime = 0;
      
      for (int j = 0; j < dailyTasks.size(); j++)
      {        
        JSONObject individualTaskData = dailyTasks.getJSONObject(j);
        String taskName = individualTaskData.getString("task");
        float hours = individualTaskData.getFloat("value");
        
        totalTime = totalTime + hours; // total hours spent in a day
        
        // if the task name doesn't exist in usertasks.json already...call the add new entry to user tasks function and pass isPositive
        if (!DoesEntryExistInUserTasks(taskName, outputData, isPositive, hours, totalTime))
        {
          AddNewEntryToUserTasks(taskName, outputData, isPositive, hours, totalTime);
        }
      }
      day.setInt("counted", 1);
      saveJSONArray(inputData, "data/data2.json");
    }
    // creating a hashmap that is returned by the "ScaleValues()" function
    HashMap<String, Float> myData = ScaleValues(GetMaxValue(outputData), GetMinValue(outputData), outputData);
  }

  // function for appending new task to array in the usertasks json file
  void AddNewEntryToUserTasks(String newTaskName, JSONArray outputData, boolean isPositive, float hours, float totalTime)
  {
    // setting our keys + values in the newEntry json object, appending newEntry to the usertasks json array, and saving that data. 
    //shorthand if statement, ? (the question - is it true) first value yes second value no 
    float value = isPositive ? 1 : -1;
    float score = hours / totalTime;
    score = score * value;
    
    JSONObject newEntry = new JSONObject();
    newEntry.setString("taskName", newTaskName);
    newEntry.setFloat("value", score);
    newEntry.setFloat("totalTime", hours);
    newEntry.setInt("occurances", 1);

    outputData.append(newEntry);
    saveJSONArray(outputData, "data/usertasks.json");
    //print(outputData);
  }

  // function for updating data associated with existing tasks in the "usertasks" json array 
  void UpdateExisitingEntryInUserTasks(int indexOfEntry, JSONArray outputData, boolean isPositive, float hours, float totalTime)
  {

    //shorthand if statement, ? (the question - is it true) first value yes second value no 
    // if isPositive returns true "value" = 1, otherwise "value" = -1
    float value = isPositive ? 1 : -1;
    float score = hours / totalTime;
    score = score * value;
 
    // then what is the DailyTaskArray size?
    // Add all the tasks individual values. 
    // divide them by the DailyTaskArray size. 

    // at each index passed get the int at "value" key and add "value"
    // then set the new value in the json usertasks document
    score += outputData.getJSONObject(indexOfEntry).getFloat("value");
    outputData.getJSONObject(indexOfEntry).setFloat("value", value);

    // get the value of occurances stored in the json usertasks document and increment it by 1 
    // then store that new value in the json usertasks document

    // get the value of totalTime stored in the json usertasks document and increment it by the amount of hours spent on the new entry for that task
    // then store that new value in the json usertasks document
    hours += outputData.getJSONObject(indexOfEntry).getFloat("totalTime");
    outputData.getJSONObject(indexOfEntry).setFloat("totalTime", hours);

    float occurances = outputData.getJSONObject(indexOfEntry).getFloat("occurances");
    occurances ++;
    outputData.getJSONObject(indexOfEntry).setFloat("occurances", occurances); 

    // save the changed usertasks json array to the usertasks.json file
    saveJSONArray(outputData, "data/usertasks.json");
  }

  // function returning a boolean value for whether a task exists in usertask.json array or not
  boolean DoesEntryExistInUserTasks(String taskName, JSONArray outputData, boolean isPositive, float hours, float totalTime)
  {
    // run through the userTask array 
    for (int i = 0; i < outputData.size(); i++)
    {  
      // checking if taskName from the input data is the same as the value stored at the "taskName" key in the output data at each object in the array
      // if so, DoesEntryExistInUserTasks() returns true and we call the function for updating existing data passing the index 
      if (taskName.equalsIgnoreCase(outputData.getJSONObject(i).getString("taskName")))
      {
        UpdateExisitingEntryInUserTasks(i, outputData, isPositive, hours, totalTime);
        return true;
      }
    }

    // otherwise return false
    return false;
  }

  // function for scaling the scores of each task 
  // ScaleValues returns a hashmap.
  HashMap<String, Float> ScaleValues(float max, float min, JSONArray outputData)
  {

    HashMap<String, Float> userTaskValues = new HashMap<String, Float>();

    // find biggest absolute value(ignore negative of min if negative)
    // create a ceiling 
    float absoluteMin = Math.abs(min);
    float highest = max;

    // if the value of max is smaller than the absoluteMin value, make the ceiling equal to the absoluteMin value.
    if (max < absoluteMin)
    {
      highest = absoluteMin;
    }

    // make a scale ratio by dividing the largest number by 100
    float scaleRatio = 100 / highest;

    // run through the usertasks.json array and at every object get the "taskName" key value and put it in taskName
    // and get the "value" key value and put it in value
    // multiply the value by the scale ratio
    float totalTime = 0;
    for (int j = 0; j < outputData.size(); j++)
    {
      float timePerTask = outputData.getJSONObject(j).getFloat("totalTime");
      totalTime = totalTime + timePerTask;
    }
    
    for (int i = 0; i < outputData.size(); i++)
    {
      String taskName = outputData.getJSONObject(i).getString("taskName");
      float value = outputData.getJSONObject(i).getFloat("value");
      value *= scaleRatio;

      // place the task name and the scaled value in the userTaskValues hashmap
      userTaskValues.put(taskName, value);
    }
    // return the hashmap
    return userTaskValues;
  }

  // get the maximum value in the usertasks.json array 
  float GetMaxValue(JSONArray outputData)
  {
    // set a really low number for the max so that the found max value is able to be stored
    float max = -100000000;

    // run through the usertasks.json array and get the "value" keys value at each index
    for (int i = 0; i < outputData.size(); i++)
    {
      float value = outputData.getJSONObject(i).getFloat("value");

      // if the value recieved is bigger than max, then max = value 
      if (value > max)
      {
        max = value;
      }
    }
    // return the highest number stored in the usertasks.json array 
    return max;
  }

    // get the min value in the usertasks.json array 
  float GetMinValue(JSONArray outputData)
  {
    float min = 1000000000;

    for (int i = 0; i < outputData.size(); i++)
    {
      float value = outputData.getJSONObject(i).getFloat("value");

      if (value < min)
      {
        min = value;
      }
    }
    return min;
  }
}