
/*** 
 
 1. fix task display so they are in order (use a list instead of a hashmap)
 2. Add Page explanations 
 3. Clump tasks data
 4. Create display for data 
 5. Comment everything 
 
 ***/


import g4p_controls.*;
import java.util.Map;

int pageCount = 0;

GTextField task;
GTextField time;
GTextField task1;
GTextField time1;
GTextField task2;
GTextField time2;
GTextField task3;
GTextField time3;
GTextField task4;
GTextField time4;

GButton calculate;
GButton newDay; 


PredictMood moodPrediction;
String[] taskNames;
GTextArea thistest;
// variables for Processing Daily Data

JSONArray dailyData;
JSONArray userTasks;

// variables for data input 

GTextField taskName;
GTextField timeSpent;

GToggleGroup moodSelect;
GOption negative;
GOption positive;

GButton submitTasks;
GButton submitDay; // On submission of mood
GButton done;

String[] moodInput;
String[] taskContainer;
String[] timeContainer;
String[] tasksToPrint = new String[6];
String[] tasksTimeToPrint = new String[6];
int numberOfTasksSubmitted = 0;

// variables to place in hashmap
String hmTask = "";
float hmTime;
String hmMood;

HashMap<String, Float> storedDailyValues = new HashMap<String, Float>();

//DisplayTextOnSubmit displayTasks; 

ProcessingDailyData processInput;
DataProjection createCatalogue;

void setup()
{
  size(600, 400);
  G4P.setGlobalColorScheme(15);

  // page one buttons 
  positive = new GOption(this, 20, 125, 80, 50, "Positive");
  negative = new GOption(this, 100, 125, 110, 50, "Negative");

  moodSelect = new GToggleGroup();
  moodSelect.addControls(positive, negative);

  submitTasks = new GButton(this, 510, 150, 70, 20, "Submit");
  submitDay = new GButton(this, 20, 180, 80, 20, "Submit Day");
  done = new GButton(this, 20, 330, 70, 20, "DONE");

  timeSpent = new GTextField(this, 230, 150, 90, 20);
  timeSpent.setText("HOURS");
  taskName = new GTextField(this, 20, 150, 200, 20);
  taskName.setText("TASK NAME");

  // displayTasks = new DisplayTextOnSubmit(hmTask, hmTime);

  // page 2 buttons
  task = new GTextField(this, 20, 20, 200, 20);
  task.setText("Task");

  task1 = new GTextField(this, 20, 50, 200, 20);
  task1.setText("Task");

  task2 = new GTextField(this, 20, 80, 200, 20);
  task2.setText("Task");

  task3 = new GTextField(this, 20, 110, 200, 20);
  task3.setText("Task");

  task4 = new GTextField(this, 20, 140, 200, 20);
  task4.setText("Task");

  calculate = new GButton(this, 20, 170, 70, 70, "Calculate");
  newDay = new GButton(this, 230, 170, 70, 70, "New Day");

  drawPage1();
  dailyData = loadJSONArray("data2.json");
  processInput = new ProcessingDailyData();
  createCatalogue = new DataProjection();
}

void drawPage1() {

  if (pageCount == 0)
  {
    fill(255, 127, 80);
    textSize(25);
    text("Enter a task and the amount of time spent on it.", 20, 40, 500, 80);

    fill(0);
    rect(20, 170, 200, 0.5);
    rect(230, 170, 90, 0.5);
    submitTasks.setVisible(true);
    timeSpent.setVisible(true);
    taskName.setVisible(true);
    done.setVisible(true);

    positive.setVisible(false);
    negative.setVisible(false);
    submitDay.setVisible(false);
    task.setVisible(false);
    task1.setVisible(false);
    task2.setVisible(false);
    task3.setVisible(false);
    task4.setVisible(false);
    calculate.setVisible(false);
    newDay.setVisible(false);
  }

  if (pageCount == 1)
  {
    task.setVisible(true);
    task1.setVisible(true);
    task2.setVisible(true);
    task3.setVisible(true);
    task4.setVisible(true);
    calculate.setVisible(true);
    newDay.setVisible(true);

    done.setVisible(false);
    positive.setVisible(false);
    negative.setVisible(false);
    submitTasks.setVisible(false);
    submitDay.setVisible(false);
    timeSpent.setVisible(false);
    taskName.setVisible(false);
  }

  if (pageCount == 2)
  {
    fill(255, 127, 80);
    textSize(25);
    text("Do you feel accomplished today?", 20, 40, 500, 80);
    
    positive.setVisible(true);
    negative.setVisible(true);
    submitDay.setVisible(true);

    done.setVisible(false);
    submitTasks.setVisible(false);
    timeSpent.setVisible(false);
    taskName.setVisible(false);
    task.setVisible(false);
    task1.setVisible(false);
    task2.setVisible(false);
    task3.setVisible(false);
    task4.setVisible(false);
    calculate.setVisible(false);
    newDay.setVisible(false);
  }
}

void handleButtonEvents(GButton button, GEvent event) {

  if (button == done && event == GEvent.CLICKED) 
  {
    drawPage1();
    pageCount = 2;
  }

  if (button == submitTasks && event == GEvent.CLICKED) {

    // not sure about this if statement
    // Trying to make sure both text fields are populated before submission
    // So that the hashmap doesn't mess up

    timeContainer = new String[] { timeSpent.getText() };
    taskContainer = new String[] { taskName.getText() };

    //LOOK AT THIS IF BECAUSE IT"S BREAKING THINGS 
    // After testing it seemed to break something LOOK AT IT
    if (!timeContainer[0].isEmpty()  && !taskContainer[0].isEmpty() )
    {
      hmTask = taskContainer[0];
      hmTime = Float.parseFloat(timeContainer[0]);
      numberOfTasksSubmitted++;

      storedDailyValues.put(hmTask, hmTime);
      printTaskValuesOnSubmit(storedDailyValues);
    } else {

      println("FILL IN BOTH FIELDS PLEASE");
    }
  } 

  if (button == submitDay && event == GEvent.CLICKED) 
  {
    if (positive.isSelected() == true)
    {
      moodInput = new String[] { positive.getText() };
      hmMood = moodInput[0];
    }

    if (negative.isSelected() == true)
    {
      moodInput = new String[] { negative.getText() };
      hmMood = moodInput[0];
    }

    pageCount = 1;
    drawPage1();
    convertToJsonArray();
  }

  if (button == calculate && event == GEvent.CLICKED) 
  {

    ArrayList<String> tasksToBeProjected;
    tasksToBeProjected = new ArrayList<String>();

    String name = task.getText();
    tasksToBeProjected.add(name);

    String name1 = task1.getText();
    tasksToBeProjected.add(name1);

    String name2 = task2.getText();
    tasksToBeProjected.add(name2);

    String name3 = task3.getText();
    tasksToBeProjected.add(name3);

    String name4 = task4.getText();
    tasksToBeProjected.add(name4);

    moodPrediction = new PredictMood();
    moodPrediction.PrintThing(tasksToBeProjected);
  }

  if (button == newDay && event == GEvent.CLICKED) 
  {
    pageCount = 0;
    drawPage1();
  }
}

void convertToJsonArray()
{
  JSONObject dayObject = new JSONObject();
  JSONArray dailyTaskList = new JSONArray();

  if (!storedDailyValues.isEmpty()) {

    // with json objects, instead of creating a copy of the object to place in the array
    // calling a json object points to an objects memory address (pointing to the same thing) 
    // need to specify type otherwise program has trouble compiling 
    for (Map.Entry<String, Float> me : storedDailyValues.entrySet()) 
    {  
      String taskName = me.getKey();
      float taskTime = me.getValue();

      JSONObject taskData = new JSONObject();
      taskData.setString("task", taskName);
      taskData.setFloat("value", taskTime);

      dailyTaskList.append(taskData);
    }

    dayObject.setInt("listed", 0);
    dayObject.setInt("counted", 0);
    dayObject.setString("mood", hmMood);
    dayObject.setJSONArray("dailyTaskList", dailyTaskList);
    dailyData.append(dayObject);
    saveJSONArray(dailyData, "data/data2.json");
    //println(dailyData);
    storedDailyValues.clear();
  }
  processInput.GetInputData();
  createCatalogue.ExtractPostiveTasksFromEachDay();
  createCatalogue.ExtractNegativeTasksFromEachDay();
}

void printTaskValuesOnSubmit(HashMap<String, Float> storedDailyValues)
{
  int counter = 0;
  int overflowCounter = numberOfTasksSubmitted;
  for (Map.Entry me : storedDailyValues.entrySet()) {
    if (overflowCounter > 6)
    {
      overflowCounter--;
      continue;
    }

    float timeDisplay = Float.parseFloat(me.getValue().toString());
    String time = str(timeDisplay);

    tasksToPrint[counter] = (me.getKey().toString());
    tasksTimeToPrint[counter] = time + "h";
    counter++;
  }
}

void draw() {

  background(255);
  fill(0);

  drawPage1();


  //timeSpent = new GTextField(this, 230, 20, 90, 20);
  //timeSpent.setText("HOURS");
  //taskName = new GTextField(this, 20, 20, 200, 20);
  //taskName.setText("TASK NAME");
  if (pageCount == 0) {
    if (tasksToPrint[0] != null)
    {
      int initalYPos = 190;

      for (int i = 0; i < tasksToPrint.length; i++)
      {
        if (tasksToPrint[i] != null) {
          textSize(11);
          text(tasksToPrint[i], 20, initalYPos);
          text(tasksTimeToPrint[i], 230, initalYPos);

          initalYPos += 20;
        }
      }
    }
  }
}
