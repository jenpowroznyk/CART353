
/*** 
Class for storing data on individual tasks entered
- scores tasks
- accumulates total time per task
- accumulates an amount of occurances per task
***/

class ProcessingDailyData 
{

  JSONArray inputData;
  JSONArray outputData;
  JSONArray dailyTasks;

  JSONObject day;

  ProcessingDailyData()
  {
  }

  // function for recieving and parsing the input data
  void GetInputData()
  {  
    // load data2.json (input data) and usertasks.json (output data)
    inputData = loadJSONArray("data/data2.json");
    outputData = loadJSONArray("data/usertasks.json");

    // run through the array of day objects that is input by the user
    for (int i = 0; i < inputData.size(); i++)
    { 

      // check to see if the day object is counted: if yes --> skip to next index, otherwise...
      day = inputData.getJSONObject(i);
      int dayCount = day.getInt("counted");
      boolean isCounted = dayCount == 1;
      if (isCounted)
      {
        continue;
      }

      // get the "mood" value and the array of tasks in each day object
      String mood = day.getString("mood");
      dailyTasks = day.getJSONArray("dailyTaskList");

      // for each day object, check if the value at key "mood" is "positive"
      boolean isPositive = mood.equalsIgnoreCase("positive");
      // float for storing totalTime in a day 
      float totalTime = 0;

      // iterate over dailyTaskList 
      for (int j = 0; j < dailyTasks.size(); j++)
      {        
        JSONObject individualTaskData = dailyTasks.getJSONObject(j);   // get the object at index 
        String taskName = individualTaskData.getString("task");        // get the task name 
        float hours = individualTaskData.getFloat("value");            // get the hours 

        totalTime = totalTime + hours;                                 // total hours spent in a day

        // if the task name doesn't exist in usertasks.json already...call the add new entry to user tasks function and pass isPositive
        if (!DoesEntryExistInUserTasks(taskName, outputData, isPositive, hours, totalTime))
        {
          AddNewEntryToUserTasks(taskName, outputData, isPositive, hours, totalTime);
        }
      }

      // the day is now toggled counted, and won't be accounted for again 
      day.setInt("counted", 1);
      saveJSONArray(inputData, "data/data2.json");
    }
  }

  // function for appending new task to array in the usertasks json file
  void AddNewEntryToUserTasks(String newTaskName, JSONArray outputData, boolean isPositive, float hours, float totalTime)
  {
    // if isPositive = true --> the tasks score will be positive
    // if isPositive = false --> the tasks score will be negative
    // task score is that tasks hours over the total hours done that day 
    float value = isPositive ? 1 : -1;
    float score = hours / totalTime;
    score = score * value;

    // set all our values for new entry 
    // set occurances to 1 
    JSONObject newEntry = new JSONObject();
    newEntry.setString("taskName", newTaskName);
    newEntry.setFloat("value", score);
    newEntry.setFloat("totalTime", hours);
    newEntry.setInt("occurances", 1);

    // append the new entry to outputData and save that to the json file. 
    outputData.append(newEntry);
    saveJSONArray(outputData, "data/usertasks.json");
  }

  // function for updating data associated with existing tasks in the "usertasks" json array 
  void UpdateExisitingEntryInUserTasks(int indexOfEntry, JSONArray outputData, boolean isPositive, float hours, float totalTime)
  {

    float value = isPositive ? 1 : -1;
    float score = hours / totalTime;
    score = score * value;

    // at each index passed get the int at "value" key and add "value"
    // then set the new value in the json usertasks document
    score = score + outputData.getJSONObject(indexOfEntry).getFloat("value");
    outputData.getJSONObject(indexOfEntry).setFloat("value", score);

    // get the value of totalTime stored in the json usertasks document and increment it by the amount of hours spent on the new entry for that task
    // then store that new value in the json usertasks document
    hours += outputData.getJSONObject(indexOfEntry).getFloat("totalTime");
    outputData.getJSONObject(indexOfEntry).setFloat("totalTime", hours);

    // get the value of occurances stored in the json usertasks document and increment it by 1 
    // then store that new value in the json usertasks document
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
}
