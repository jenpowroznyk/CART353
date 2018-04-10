class PredictMood
{
  ArrayList<String> taskNameInput;
  JSONArray totalDailyTasks; 

  PredictMood()
  {
    taskNameInput = new ArrayList<String>();
    totalDailyTasks = loadJSONArray("data/usertasks.json");
  }

  void PrintThing(ArrayList<String> taskNameInput)
  {  
    String name = "";

    float [] otherValues = new float [3];

    HashMap<String, float []> catalogue;
    catalogue = new HashMap<String, float []>();

    for (int i = 0; i < taskNameInput.size(); i++)
    {
      name = taskNameInput.get(i);
      if (name.equalsIgnoreCase("Task"))
      {
        continue;
      }

      for (int j = 0; j < totalDailyTasks.size(); j++)
      {

        JSONObject storedTaskObject = totalDailyTasks.getJSONObject(j);
        String storedTask = storedTaskObject.getString("taskName");

        if (!name.equalsIgnoreCase(storedTask))
        {
          continue;
        } else {
          otherValues[0] = storedTaskObject.getInt("totalTime");
          otherValues[1] = storedTaskObject.getInt("occurances"); 
          otherValues[2] = storedTaskObject.getInt("value"); 

          catalogue.put(storedTask, otherValues);
        }
      }
    }
    calculateProjection(catalogue);
  }

  void calculateProjection(HashMap<String, float []> catalogue)
  {  
    float totalValue = 0; 
    float totalChosenValues = 0;

    for (int j = 0; j < totalDailyTasks.size(); j++)
    {
      JSONObject storedTaskObject = totalDailyTasks.getJSONObject(j);
      int taskValue = storedTaskObject.getInt("value");
      totalValue = totalValue + taskValue;
    }

    for (Map.Entry me : catalogue.entrySet()) {   
      float[] myFloats = (float[]) me.getValue();
      float chosenTaskValues = myFloats[2];
      totalChosenValues = totalChosenValues + chosenTaskValues;
    }
     float someValue = totalChosenValues / totalValue;
     float finalPercentageValue = someValue * 100;
     println(finalPercentageValue);
  }
}