
/***
 - class for determining the percentage value of positivity associated to a cluster of tasks input by user
 - also shows the percentge value of an individual tasks positivity scaled to the highest and lowest values 
 - displays these figures 
 ***/

class PredictMood
{
  ArrayList<String> taskNameInput;
  JSONArray totalDailyTasks; 
  float finalPercentageValue;
  float chosenTaskValue = 0;

  PredictMood()
  {
    taskNameInput = new ArrayList<String>();
    totalDailyTasks = loadJSONArray("data/usertasks.json");
  }

  // filter through and store the values associated with the input task names
  void storeTaskNames(ArrayList<String> taskNameInput)
  {  
    String name = "";
    // array of floats for storing tasks time, occurances and score values
    float [] otherValues = new float [3];

    // creata a new hashmap of strings and float arrays 
    HashMap<String, float []> catalogue;
    catalogue = new HashMap<String, float []>();

    // run through taskNameInput array list 
    for (int i = 0; i < taskNameInput.size(); i++)
    {
      // get the name at index
      name = taskNameInput.get(i);
      // if the name equals task then skip to next index
      if (name.equalsIgnoreCase("Task"))
      {
        continue;
      }

      // iterate over totalDailyTasks array object
      for (int j = 0; j < totalDailyTasks.size(); j++)
      {

        JSONObject storedTaskObject = totalDailyTasks.getJSONObject(j);
        String storedTask = storedTaskObject.getString("taskName");

        // if name doesn't match the name in the jsonArray  then continue to next index, otherwise...
        if (!name.equalsIgnoreCase(storedTask))
        {
          continue;
        } else {
          // set the otherValues array values to [totalTime],[occurances],[value]
          otherValues[0] = storedTaskObject.getFloat("totalTime");
          otherValues[1] = storedTaskObject.getFloat("occurances"); 
          otherValues[2] = storedTaskObject.getFloat("value"); 

          // put the task name and the task score into the catologue hashmap 
          catalogue.put(storedTask, otherValues);
        }
      }
    }
    // call calculate projecion and pass the catalogue hashmap 
    calculateProjection(catalogue);
  }

  // calculate the percentage value of positivity for a cluster of tasks input 
  void calculateProjection(HashMap<String, float []> catalogue)
  {  
    float totalValue = 0;  // value for the total time of all tasks recorded
    float totalChosenValues = 0; // value for the total time for the input tasks

    // get total value of all tasks in usertasks.json
    for (int j = 0; j < totalDailyTasks.size(); j++)
    {
      JSONObject storedTaskObject = totalDailyTasks.getJSONObject(j);
      float taskValue = storedTaskObject.getFloat("value");
      totalValue = totalValue + taskValue;
    }

    // get total value of the tasks input for calculation
    for (Map.Entry me : catalogue.entrySet()) {   
      float[] myFloats = (float[]) me.getValue();
      float chosenTaskValues = myFloats[2];
      totalChosenValues = totalChosenValues + chosenTaskValues;
    }
    // divide the total input value by the total value recorded and multiply it by 100 to get your percentage value.
    float someValue = totalChosenValues / totalValue;
    finalPercentageValue = someValue * 100;
  }

  // displays the calculated projection  
  void displayClumpProjection()
  {
    // format value
    fill(0);
    textSize(25);
    // rounds off a float to the 2nd decimal point (found online)
    String displayData = String.format("%.2f", finalPercentageValue);
    String formatted = displayData + "%";
    text(formatted, 200, 200);
    textSize(16);
    text("chance of having a positive day.", 275, 200);
  }

  // called to display individual task datas score
  void displayIndividualProjection()
  {
    fill(0);
    textSize(25);
    String displayData = String.format("%.2f", chosenTaskValue);
    String formatted = displayData + "%";
    text(formatted, 360, 300);
    textSize(16);
    text("positive.", 435, 300);
  }

  // function for scaling the score of the individual task to be measured 
  void ScaleTaskValue(String taskName)
  {
    // the methods being called return float values 
    float max = GetMaxValue(totalDailyTasks); // returns the highest value attributed to a task stored in usertasks.json
    float min = GetMinValue(totalDailyTasks); // returns the lowest value attributed to a task stored in usertasks.json

    // run over the totalDailyTasks array
    for (int i = 0; i < totalDailyTasks.size(); i++)
    {
      // if the task name that was input matches the one in the object at index i of totalDailyTasks array 
      if (totalDailyTasks.getJSONObject(i).getString("taskName").equalsIgnoreCase(taskName))
      {
        // chosenTaskValue = the value of that task
        chosenTaskValue = totalDailyTasks.getJSONObject(i).getFloat("value");
      }
    }

    // find biggest absolute value(ignore the negative of min, if it is negative)
    // create a ceiling 
    // recieved help for the scaling of values
    float absoluteMin = Math.abs(min);
    float highest = max;

    // if the value of max is smaller than the absoluteMin value, make the ceiling equal to the absoluteMin value
    if (max < absoluteMin)
    {
      highest = absoluteMin;
    }

    // make a scale ratio by dividing the largest number by 100
    float scaleRatio = 100 / highest;
    
    // multiply the chosenTaskValue by the scale ratio 
    // this is your score
    chosenTaskValue *= scaleRatio;
  }

  // get the maximum value in the usertasks.json array 
  float GetMaxValue(JSONArray totalDailyTasks)
  {
    // set a really low number for the max so that the found max value is able to be stored
    float max = -100000000;

    // run through the usertasks.json array and get the "value" keys value at each index
    for (int i = 0; i < totalDailyTasks.size(); i++)
    {
      float value = totalDailyTasks.getJSONObject(i).getFloat("value");
      String formattedValue = String.format("%.2f", value);
      float officialValue = parseFloat(formattedValue);


      // if the value recieved is bigger than max, then max = value 
      if (officialValue > max)
      {
        max = officialValue;
      }
    }
    // return the highest number stored in the usertasks.json array 
    return max;
  }

  
  // get the minimum value in the usertasks.json array 
  float GetMinValue(JSONArray totalDailyTasks)
  {
    float min = 1000000000;

    for (int i = 0; i < totalDailyTasks.size(); i++)
    {
      float value = totalDailyTasks.getJSONObject(i).getFloat("value");
      String formattedValue = String.format("%.2f", value);
      float officialValue = parseFloat(formattedValue);

      if (officialValue < min)
      {
        min = officialValue;
      }
    }
    return min;
  }
}
