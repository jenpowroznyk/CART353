
/*** 
 Jennifer Powroznyk
 CART353 - Final Prototype
 Concordia 2018
 ***/

// importing libraries
import g4p_controls.*;
import java.util.Map;

// creating a page counter to determine what page to draw
int pageCount = 0;

// creating task fields
GTextField task;
GTextField task1;
GTextField task2;
GTextField task3;
GTextField task4;
GTextField individualTask;
GTextField taskName;
GTextField timeSpent;

// group for selecting negative or positive day 
GToggleGroup moodSelect;
GOption negative;
GOption positive;

// creating buttons
GButton calculate;
GButton calculateIndividual;
GButton newDay;
GButton submitTasks;
GButton submitDay; 
GButton done;
GButton testTasks;
GButton returnToData;
GButton viewTimeData;

// create json array for task input 
JSONArray dailyData;
JSONArray userTasks;

// string arrays for storing input
String[] taskNames;
String[] moodInput;
String[] taskContainer;
String[] timeContainer;

// variables for displaying task information on submit
String[] tasksToPrint = new String[6];
String[] tasksTimeToPrint = new String[6];
int numberOfTasksSubmitted = 0;

// variables to place task information in hashmap
String hmTask = "";
float hmTime;
String hmMood;

HashMap<String, Float> storedDailyValues = new HashMap<String, Float>();

// booleans to toggle display of mood prediction
Boolean calculatePressed = false;
Boolean individualCalculate = false;

// create objects 
PredictMood moodPrediction;
GenerateRandomData generate;
ProcessingDailyData processInput;
DataProjection createCatalogue;
VisualizeData seeData;

void setup()
{
  size(600, 400);
  // setting colour scheme to 15 using G4P's method for custom colours
  // this is referencing a png of a colour grid in data folder
  G4P.setGlobalColorScheme(15);

  // running code to generate fake data 
  //generate = new GenerateRandomData();
  //generate.CreateRandomizedJSONData(60);

  // instantiating buttons
  // mood select buttons 
  positive = new GOption(this, 20, 125, 80, 50, "Positive");
  negative = new GOption(this, 100, 125, 110, 50, "Negative");
  moodSelect = new GToggleGroup();
  moodSelect.addControls(positive, negative);

  // home button
  returnToData = new GButton(this, width - 90, 20, 70, 20, "Home");

  // submit day buttons
  submitTasks = new GButton(this, 510, 150, 70, 20, "Submit");
  submitDay = new GButton(this, 20, 180, 80, 20, "Submit Day");
  done = new GButton(this, 20, 330, 70, 20, "DONE");

  // home buttons
  testTasks = new GButton(this, width / 2 - 45, 80, 90, 20, "Test Positivity");
  viewTimeData = new GButton(this, width / 2 - 50, 120, 100, 20, "View Time Chart");
  newDay = new GButton(this, width / 2 - 35, 160, 70, 20, "New Day");

  // submit day text fields 
  timeSpent = new GTextField(this, 230, 150, 90, 20);
  timeSpent.setText("HOURS");
  taskName = new GTextField(this, 20, 150, 200, 20);
  taskName.setText("TASK NAME");

  // fields / buttons for mood prediction
  task = new GTextField(this, 20, 40, 100, 20);
  task.setText("Task");

  task1 = new GTextField(this, 20, 70, 100, 20);
  task1.setText("Task");

  task2 = new GTextField(this, 20, 100, 100, 20);
  task2.setText("Task");

  task3 = new GTextField(this, 20, 130, 100, 20);
  task3.setText("Task");

  task4 = new GTextField(this, 20, 160, 100, 20);
  task4.setText("Task");

  individualTask = new GTextField(this, 20, 260, 200, 20);
  individualTask.setText("Individual Task");

  calculate = new GButton(this, 20, 190, 70, 20, "Calculate");
  calculateIndividual = new GButton(this, 20, 290, 70, 20, "Calculate");

  // function for drawing page
  drawPage1();
  // instantiating custom classes 
  seeData = new VisualizeData(this);
  moodPrediction = new PredictMood();
  dailyData = loadJSONArray("data2.json");
  processInput = new ProcessingDailyData();
  createCatalogue = new DataProjection();
}

// function for displaying G4P elements on page
// toggling between a counter 
void drawPage1() {

  // submit day 
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
    returnToData.setVisible(true);

    viewTimeData.setVisible(false);
    calculateIndividual.setVisible(false);
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
    testTasks.setVisible(false);
    individualTask.setVisible(false);
  }

  // mood prediction
  if (pageCount == 1)
  { 
    fill(255, 127, 80);
    textSize(14);
    text("Enter a sequence of tasks to see how likely they are to effect your day positively.", 20, 20, 500, 80);

    task.setVisible(true);
    rect(20, 60, 100, 0.5);
    task1.setVisible(true);
    rect(20, 90, 100, 0.5);
    task2.setVisible(true);
    rect(20, 120, 100, 0.5);
    task3.setVisible(true);
    rect(20, 150, 100, 0.5);
    task4.setVisible(true);
    rect(20, 180, 100, 0.5);

    text("Enter a single task to see how positively it effects you in comparison to all stored tasks.", 20, 240, 500, 80);

    individualTask.setVisible(true);
    rect(20, 280, 100, 0.5);
    calculateIndividual.setVisible(true);
    calculate.setVisible(true);
    returnToData.setVisible(true);

    viewTimeData.setVisible(false);
    newDay.setVisible(false);
    done.setVisible(false);
    positive.setVisible(false);
    negative.setVisible(false);
    submitTasks.setVisible(false);
    submitDay.setVisible(false);
    timeSpent.setVisible(false);
    taskName.setVisible(false);
    testTasks.setVisible(false);
  }

  // mood select
  if (pageCount == 2)
  {
    fill(255, 127, 80);
    textSize(25);
    text("Do you feel accomplished today?", 20, 40, 500, 80);

    returnToData.setVisible(true);
    positive.setVisible(true);
    negative.setVisible(true);
    submitDay.setVisible(true);

    viewTimeData.setVisible(false);
    calculateIndividual.setVisible(false);
    individualTask.setVisible(false);
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
    testTasks.setVisible(false);
  }

  // home
  if (pageCount == 3)
  {  
    viewTimeData.setVisible(true);
    newDay.setVisible(true);
    testTasks.setVisible(true);

    calculateIndividual.setVisible(false);
    individualTask.setVisible(false);
    positive.setVisible(false);
    negative.setVisible(false);
    submitDay.setVisible(false);
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
  }

  // time chart
  if (pageCount == 4)
  { 
    returnToData.setVisible(true);

    viewTimeData.setVisible(false);
    newDay.setVisible(false);
    testTasks.setVisible(false);
    calculateIndividual.setVisible(false);
    individualTask.setVisible(false);
    positive.setVisible(false);
    negative.setVisible(false);
    submitDay.setVisible(false);
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
  }
}

// G4P function for handling button events 
void handleButtonEvents(GButton button, GEvent event) {

  // if x button clicked --> change page
  if (button == testTasks && event == GEvent.CLICKED) 
  {
    drawPage1();
    pageCount = 1;
  }

  if (button == done && event == GEvent.CLICKED) 
  {
    drawPage1();
    pageCount = 2;
  }
  if (button == viewTimeData && event == GEvent.CLICKED) 
  {
    drawPage1();
    pageCount = 4;
  }

  // ensure that booleans determining mood prediction are false
  // so mood predictions are not being drawn
  if (button == returnToData && event == GEvent.CLICKED) 
  {
    drawPage1();
    individualCalculate = false;
    calculatePressed = false;
    pageCount = 3;
  }

  if (button == submitTasks && event == GEvent.CLICKED) {

    // make new string arrays, and place the time / name values into their respective string arrays
    timeContainer = new String[] { timeSpent.getText() };
    taskContainer = new String[] { taskName.getText() };

    // if both of the arrays at index 0 are full continue
    // otherwise print error message
    if (!timeContainer[0].isEmpty()  && !taskContainer[0].isEmpty() )
    {
      hmTask = taskContainer[0]; // make hmTask equal to taskContainer at index 0
      hmTime = Float.parseFloat(timeContainer[0]);  // make hmTime equal to timeContainer parsed as a float, at index 0
      numberOfTasksSubmitted++; // increase the number of tasks submitted by 1 to check overflow of printed tasks

      storedDailyValues.put(hmTask, hmTime); // create an object to put in the hashmap --> key: task name , value: time value
      printTaskValuesOnSubmit(storedDailyValues); // call printTaskValuesOnSubmit passing storedDailyValues hashmap with the newly stored object
    } else {

      println("FILL IN BOTH FIELDS PLEASE");
    }
  } 
  if (button == submitDay && event == GEvent.CLICKED) 
  {
    // if positive is selected hmMood is "positive"
    if (positive.isSelected() == true)
    {
      moodInput = new String[] { positive.getText() };
      hmMood = moodInput[0];
    }
    // if negative is selected hmMood is "negative"
    if (negative.isSelected() == true)
    {
      moodInput = new String[] { negative.getText() };
      hmMood = moodInput[0];
    }

    // call convertToJsonArray() to convert data to JSONArray
    // Then create the time chart
    pageCount = 3;
    drawPage1();
    convertToJsonArray();
    seeData.getTaskValues();
  }

  if (button == calculate && event == GEvent.CLICKED) 
  {
    // create a new array list of strings
    ArrayList<String> tasksToBeProjected = new ArrayList<String>();

    // add all the names input to the tasksToBeProjected array list
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

    // call storeTaskNames() in predictMood and pass the tasksToBeProjected array list
    moodPrediction.storeTaskNames(tasksToBeProjected);
    // display the mood prediction
    calculatePressed = true;
  }

  if (button == calculateIndividual && event == GEvent.CLICKED) 
  {
    String taskName = individualTask.getText();

    // call ScaleTaskValue() in predictMood and pass the task name that was input
    moodPrediction.ScaleTaskValue(taskName);
    // display mood prediction 
    individualCalculate = true;
  }

  if (button == newDay && event == GEvent.CLICKED) 
  {
    pageCount = 0;
    drawPage1();
  }
}

// function for converting input data to JSONArray
// done in PApplet because of G4P limitations
void convertToJsonArray()
{
  // create new json object and json array 
  JSONObject dayObject = new JSONObject();
  JSONArray dailyTaskList = new JSONArray();

  // if storedDailyValues hashmap is not empty 
  if (!storedDailyValues.isEmpty()) {

    // with json objects, instead of creating a copy of the object to place in the array
    // calling a json object points to an objects memory address (pointing to the same thing) 
    // need to specify type otherwise program has trouble compiling 
    
    // run over the storedDailyValues hashmap, at each object... 
    for (Map.Entry<String, Float> me : storedDailyValues.entrySet()) 
    {  
      String taskName = me.getKey(); // get the task name
      float taskTime = me.getValue(); // get the task time
      
      JSONObject taskData = new JSONObject(); // create a new json object named task data
      taskData.setString("task", taskName); // set "task" to the task name
      taskData.setFloat("value", taskTime); // set "value" to task time

      dailyTaskList.append(taskData); // append taskData json object to dailyTaskList
    }

    dayObject.setInt("counted", 0); // create a key to see if a day is counted
    dayObject.setString("mood", hmMood); // set the mood key as either "positive" or "negative"
    dayObject.setJSONArray("dailyTaskList", dailyTaskList); // place the dailyTaskList json array into the object
    dailyData.append(dayObject); // append new dayObject to dailyData array (found in data2.json file)
    saveJSONArray(dailyData, "data/data2.json"); // save the new dailyData json array 
  
    storedDailyValues.clear(); // clear the hashmap so we don't input the same information the next day
  }
  processInput.GetInputData();                        // go organize / score the data
  createCatalogue.ExtractPostiveTasksFromEachDay();   // create task pairs of positive day
  createCatalogue.ExtractNegativeTasksFromEachDay();  // create task pairs of negative days
}

// function for printing tasks on submit 
// passing the storedDailyValues hashmap into it so we have that data stored
// I believe a hashmap may not have a clear sequence which is why the information displays in a weird order on screen
void printTaskValuesOnSubmit(HashMap<String, Float> storedDailyValues)
{
  // ensure we are never displaying more than the numberOfTasksSubmitted
  int counter = 0;
  int overflowCounter = numberOfTasksSubmitted;
  
  // run through the hashmap at each object
  for (Map.Entry me : storedDailyValues.entrySet()) {
    // if the overflowCounter is larger than 6, then decrease it and reiterate
    if (overflowCounter > 6)
    {
      overflowCounter--;
      continue;
    }
    // get the value of each key and parse it to a float from an object
    float timeDisplay = Float.parseFloat(me.getValue().toString());
    // turn it back into a string
    String time = str(timeDisplay);
    
    // at each index get the task name and time and print it 
    // increment the counter by 1
    tasksToPrint[counter] = (me.getKey().toString());
    tasksTimeToPrint[counter] = time + "h";
    counter++;
  }
}

void draw() {

  background(255);
  fill(0);

  drawPage1();

  if (individualCalculate)
  {
    moodPrediction.displayIndividualProjection();
  }

  if (calculatePressed)
  {
    moodPrediction.displayClumpProjection();
  }

  if (pageCount == 4)
  {
    seeData.drawTaskValues();
  }

  // if we're on submit tasks page
  if (pageCount == 0) {
    // if tasks to print at index 0 is full
    if (tasksToPrint[0] != null)
    {
      int initalYPos = 190;
      // run through tasksToPrint and if...
      for (int i = 0; i < tasksToPrint.length; i++)
      {
        // index is full
        if (tasksToPrint[i] != null) {
          // print the name and time stored at that index
          textSize(11);
          text(tasksToPrint[i], 20, initalYPos);
          text(tasksTimeToPrint[i], 230, initalYPos);
          
          // increment the y position by 20
          initalYPos += 20;
        }
      }
    }
  }
}
