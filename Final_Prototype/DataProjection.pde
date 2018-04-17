
/*** Class for counting and storing how many times a particular task appear with other tasks in a day ***/

class DataProjection 
{
  // creating an arrayList of arrayLists of strings
  ArrayList<ArrayList<String>> listOfTotalTasksInAllDays;

  DataProjection()
  {
    listOfTotalTasksInAllDays = new ArrayList<ArrayList<String>>();
  }

  // called in convertToJsonArray(), in main
  void ExtractPostiveTasksFromEachDay()
  {
    // load the json array of daily data 
    JSONArray totalDailyTasks = loadJSONArray("data/data2.json");

    // at each index of totalDailyTasks get the list of tasks and put them in the tasksInADay arrayList
    for (int i = 0; i < totalDailyTasks.size(); i++)
    {
      ArrayList<String> tasksInADay = new ArrayList<String>();
      JSONObject day = totalDailyTasks.getJSONObject(i);

      // if mood isn't "positive" skip to the next index
      if (!day.getString("mood").equalsIgnoreCase("positive"))
      {
        continue;
      }

      // get the array of tasks in the day object 
      JSONArray listOfDailyTasks = day.getJSONArray("dailyTaskList");

      // iterate over it
      for (int j = 0; j < listOfDailyTasks.size(); j++)
      {
        // add the task name to tasksInADay arrayList of strings
        tasksInADay.add(listOfDailyTasks.getJSONObject(j).getString("task"));
      }
      // add tasksInADay arrayList to the listOfTotalTasksInAllDays array list
      listOfTotalTasksInAllDays.add(tasksInADay);
    }
    // pass true because the day was postive
    CreateTaskRelationshipsCatalogue(true);
  }

  // same as ExtractPositiveTasksFromEachDay() except check for negative
  void ExtractNegativeTasksFromEachDay()
  {
    JSONArray totalDailyTasks = loadJSONArray("data/data2.json");

    for (int i = 0; i < totalDailyTasks.size(); i++)
    {
      ArrayList<String> tasksInADay = new ArrayList<String>();
      JSONObject day = totalDailyTasks.getJSONObject(i);

      if (day.getString("mood").equalsIgnoreCase("positive"))
      {
        continue;
      }

      JSONArray listOfDailyTasks = day.getJSONArray("dailyTaskList");
      for (int j = 0; j < listOfDailyTasks.size(); j++)
      {
        tasksInADay.add(listOfDailyTasks.getJSONObject(j).getString("task"));
      }

      listOfTotalTasksInAllDays.add(tasksInADay);
    }
    CreateTaskRelationshipsCatalogue(false);
  }

  // Function for creating a JSON object that stores tasks names as dictionary with keys of the tasks that have been submitted with it and how many times 
  void CreateTaskRelationshipsCatalogue(boolean isPositive)
  {  
    // load usertasks.json
    JSONArray uniqueTasks = loadJSONArray("data/usertasks.json");
    // if isPositive is true --> taskClumps equal positivecatalogue.json, otherwise negativecatalogue.json
    JSONObject taskClumps = isPositive ? loadJSONObject("data/positivecatalogue.json") : loadJSONObject("data/negativecatalogue.json");
    taskClumps = new JSONObject();
    
    String currentTask = "";
    
    // run through the usertasks.json array object
    for (int i = 0; i < uniqueTasks.size(); i++)
    {
      // make currentTask equal to taskName at index
      currentTask = uniqueTasks.getJSONObject(i).getString("taskName");

      // iterate over the arraylist of arraylists 
      for (int j = 0; j < listOfTotalTasksInAllDays.size(); j++)
      {
        // dailyTasks is the arrayList of task names at listOfTotalTasksInAllDays index
        ArrayList<String> dailyTasks = listOfTotalTasksInAllDays.get(j);
        
        //checking to see if the unique task name from the usertasksdata exists in the array of tasks in a single day 
        if (dailyTasks.contains(currentTask))
        {
          // if taskClumps already has that taskname stored then get that object,
          // otherwise create a new object with that taskname as the key
          JSONObject currentTaskClump;
          if (taskClumps.hasKey(currentTask))
          {
            currentTaskClump = taskClumps.getJSONObject(currentTask);
          } else
          {
            currentTaskClump = new JSONObject();
            taskClumps.setJSONObject(currentTask, currentTaskClump);
          }

          // run through the list of tasks in a day, 
          for (int k = 0; k < dailyTasks.size(); k++)
          {
            // get each taskname in dailyTasks
            // if the task name in daily tasks equals the currentTask name AND if currentTaskClump has a key of the same name from each task in the dailytasks
            // get the current task clumps key that matches that name and incriment the value
            // otherwise set a new task and give it a value of 1
            String task = dailyTasks.get(k);
            if (!task.equalsIgnoreCase(currentTask))
            {
              if (currentTaskClump.hasKey(task))
              {
                int value = currentTaskClump.getInt(task);
                value++;
                currentTaskClump.setInt(task, value);
              } else
              {
                currentTaskClump.setInt(task, 1);
              }
            }
          }
        }
      }
    }
    
    // save the taskClumps json object to the appropriate file 
    // and clear the listOfTotalTasksInAllDays
    String filePath = isPositive ? "data/positivecatalogue.json" : "data/negativecatalogue.json";
    saveJSONObject(taskClumps, filePath);
    listOfTotalTasksInAllDays.clear();
  }
}
