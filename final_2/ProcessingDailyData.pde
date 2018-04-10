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
      if(isCounted)
      {
       continue; 
      }
      
      String mood = day.getString("mood");
      dailyTasks = day.getJSONArray("dailyTaskList");
    

      // for each day object, check if the value at key "mood" is "positive"
      boolean isPositive = mood.equalsIgnoreCase("positive");
      for (int j = 0; j < dailyTasks.size(); j++)
      {        
        JSONObject individualTaskData = dailyTasks.getJSONObject(j);
        String taskName = individualTaskData.getString("task");
        float hours = individualTaskData.getInt("value");


        // if the task name doesn't exist in usertasks.json already...call the add new entry to user tasks function and pass isPositive
        if (!DoesEntryExistInUserTasks(taskName, outputData, isPositive, hours))
        {
          AddNewEntryToUserTasks(taskName, outputData, isPositive, hours);
        }
      }
        day.setInt("counted", 1);
        saveJSONArray(inputData, "data/data2.json");
    }
    // creating a hashmap that is returned by the "ScaleValues()" function
    HashMap<String, Float> myData = ScaleValues(GetMaxValue(outputData), GetMinValue(outputData), outputData);

  }

  // function for appending new task to array in the usertasks json file
  void AddNewEntryToUserTasks(String newTaskName, JSONArray outputData, boolean isPositive, float hours)
  {
    // setting our keys + values in the newEntry json object, appending newEntry to the usertasks json array, and saving that data. 
    //shorthand if statement, ? (the question - is it true) first value yes second value no 
    int value = isPositive ? 1 : -1;
    JSONObject newEntry = new JSONObject();
    newEntry.setString("taskName", newTaskName);
    newEntry.setInt("value", value);
    newEntry.setFloat("totalTime", hours);
    newEntry.setInt("occurances", 1);

    print(newEntry);
    outputData.append(newEntry);
    saveJSONArray(outputData, "data/usertasks.json");
    //print(outputData);
  }

  // function for updating data associated with existing tasks in the "usertasks" json array 
  void UpdateExisitingEntryInUserTasks(int indexOfEntry, JSONArray outputData, boolean isPositive, float hours)
  {

    //shorthand if statement, ? (the question - is it true) first value yes second value no 
    // if isPositive returns true "value" = 1, otherwise "value" = -1
      int value = isPositive ? 1 : -1;

    // then what is the DailyTaskArray size?
    // Add all the tasks individual values. 
    // divide them by the DailyTaskArray size. 

    // at each index passed get the int at "value" key and add "value"
    // then set the new value in the json usertasks document
      value += outputData.getJSONObject(indexOfEntry).getInt("value");
      outputData.getJSONObject(indexOfEntry).setInt("value", value);

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
      boolean DoesEntryExistInUserTasks(String taskName, JSONArray outputData, boolean isPositive, float hours)
      {
        // run through the userTask array 
        for (int i = 0; i < outputData.size(); i++)
        {  
          // checking if taskName from the input data is the same as the value stored at the "taskName" key in the output data at each object in the array
          // if so, DoesEntryExistInUserTasks() returns true and we call the function for updating existing data passing the index 
          if (taskName.equalsIgnoreCase(outputData.getJSONObject(i).getString("taskName")))
          {
            UpdateExisitingEntryInUserTasks(i, outputData, isPositive, hours);
            return true;
          }
        }

        // otherwise return false
        return false;
      }

      // function for scaling the scores of each task 
      // ScaleValues returns a hashmap.
      HashMap<String, Float> ScaleValues(int max, int min, JSONArray outputData)
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
        for (int i = 0; i < outputData.size(); i++)
        {
          String taskName = outputData.getJSONObject(i).getString("taskName");
          float value = outputData.getJSONObject(i).getInt("value");
          value *= scaleRatio;

          // place the task name and the scaled value in the userTaskValues hashmap
          userTaskValues.put(taskName, value);
        }
        // return the hashmap
        return userTaskValues;
      }

      // get the maximum value in the usertasks.json array 
      int GetMaxValue(JSONArray outputData)
      {
        // set a really low number for the max so that the found max value is able to be stored
        int max = -100000000;

        // run through the usertasks.json array and get the "value" keys value at each index
        for (int i = 0; i < outputData.size(); i++)
        {
          int value = outputData.getJSONObject(i).getInt("value");

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
      int GetMinValue(JSONArray outputData)
      {
        int min = 1000000000;

        for (int i = 0; i < outputData.size(); i++)
        {
          int value = outputData.getJSONObject(i).getInt("value");

          if (value < min)
          {
            min = value;
          }
        }
        return min;
      }
    }