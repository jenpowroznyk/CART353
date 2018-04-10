class DataProjection
{
  ArrayList<ArrayList<String>> listOfTotalTasksInAllDays;

  DataProjection()
  {
    listOfTotalTasksInAllDays = new ArrayList<ArrayList<String>>();
  }
  
  void ExtractPostiveTasksFromEachDay()
  {
     
     JSONArray totalDailyTasks = loadJSONArray("data/data2.json");
    // at each index get the list of tasks and put them in the ListOfDailyTasks json array
    for (int i = 0; i < totalDailyTasks.size(); i++)
    {
      ArrayList<String> tasksInADay = new ArrayList<String>();
      JSONObject day = totalDailyTasks.getJSONObject(i);
      if(!day.getString("mood").equalsIgnoreCase("positive"))
      {
       continue; 
      }
   
      JSONArray listOfDailyTasks = day.getJSONArray("dailyTaskList");
      for(int j = 0; j < listOfDailyTasks.size(); j++)
      {
        tasksInADay.add(listOfDailyTasks.getJSONObject(j).getString("task"));
      }
      
      listOfTotalTasksInAllDays.add(tasksInADay);
    }
    
    CreateTaskRelationshipsCatalogue(true);
  }
  
  void ExtractNegativeTasksFromEachDay()
  {
     JSONArray totalDailyTasks = loadJSONArray("data/data2.json");
    // at each index get the list of tasks and put them in the ListOfDailyTasks json array
    for (int i = 0; i < totalDailyTasks.size(); i++)
    {
      ArrayList<String> tasksInADay = new ArrayList<String>();
      JSONObject day = totalDailyTasks.getJSONObject(i);
      if(day.getString("mood").equalsIgnoreCase("positive"))
      {
        continue;
      }
   
      JSONArray listOfDailyTasks = day.getJSONArray("dailyTaskList");
      for(int j = 0; j < totalDailyTasks.size(); j++)
      {
        tasksInADay.add(listOfDailyTasks.getJSONObject(j).getString("task"));
      }
      
      listOfTotalTasksInAllDays.add(tasksInADay);
    }
  }

  void CreateTaskRelationshipsCatalogue(boolean isPositive)
  {  
    JSONArray uniqueTasks = loadJSONArray("data/usertasks.json");
    JSONObject taskClumps = isPositive ? loadJSONObject("data/positivecatalogue.json") : loadJSONObject("data/negativecatalogue.json");
 
    String currentTask = "";
    
    for (int i = 0; i < uniqueTasks.size(); i++)
    {
      currentTask = uniqueTasks.getJSONObject(i).getString("taskName");
      
      for(int j = 0; j < listOfTotalTasksInAllDays.size(); j++)
      {
        ArrayList<String> dailyTasks = listOfTotalTasksInAllDays.get(j);
        //checking to see if the (unique) task name from the usertasksdata exists in the array of tasks in a single day 
        if(dailyTasks.contains(currentTask))
        {
          JSONObject currentTaskClump;
          if(taskClumps.hasKey(currentTask))
          {
            currentTaskClump = taskClumps.getJSONObject(currentTask);
          }
          else
          {
           currentTaskClump = new JSONObject();
           taskClumps.setJSONObject(currentTask, currentTaskClump);
          }
          
          for(int k = 0; k < dailyTasks.size(); k++)
          {
            String task = dailyTasks.get(k);
            if(!task.equalsIgnoreCase(currentTask))
            {
              if(currentTaskClump.hasKey(task))
              {
                int value = currentTaskClump.getInt(task);
                value++;
                currentTaskClump.setInt(task, value);
              }
              else
              {
               currentTaskClump.setInt(task,1); 
              }
            }
          }
        }
      }
    }
    
    String filePath = isPositive ? "data/positivecatalogue.json" : "data/negativecatalogue.json";
    saveJSONObject(taskClumps, filePath);
  }
}