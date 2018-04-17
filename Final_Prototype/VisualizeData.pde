 
/*** Class for drawing the time chart using the giCenter chart library ***/

//Importing Library for drawing bar charts 
import org.gicentre.utils.spatial.*; 
import org.gicentre.utils.network.*;
import org.gicentre.utils.network.traer.physics.*;
import org.gicentre.utils.geom.*;
import org.gicentre.utils.move.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.gui.*;
import org.gicentre.utils.colour.*;
import org.gicentre.utils.text.*;
import org.gicentre.utils.*;
import org.gicentre.utils.network.traer.animation.*;
import org.gicentre.utils.io.*;

class VisualizeData
{
  JSONArray outputData;
  BarChart barChart;

  float[] time;
  float[] moodValue;
  String[] tasks;

  float x = 50;
  float y = 50;
  float size;

  // the barChart class needs to reference the main sketch so we pass it a variable storing the PApplet called "pApp"
  VisualizeData(PApplet pApp)
  {
    barChart = new BarChart(pApp);
    // load usertasks.json array 
    outputData = loadJSONArray("data/usertasks.json"); 
    // create an array of floats / string that is as large as the outputData array size
    time = new float [outputData.size()];
    moodValue = new float [outputData.size()];
    tasks = new String [outputData.size()];

    getTaskValues();

    // Barchart stuff
    // If the value is larger than the smallest time value, display it
    barChart.setMinValue(GetMinValue());
    // If the value is smaller than the set largest time value, display it
    barChart.setMaxValue(GetMaxValue());
    // set time value
    barChart.setData(time);
    // giCenter barChart method choosing to display the value axis
    barChart.showValueAxis(true);
    // giCenter barChart method setting the thingsUserDid value as the bar labels
    barChart.setBarLabels(tasks);
    // giCenter barChart method choosing to display the category axis
    barChart.showCategoryAxis(true);
    // giCenter BarChart method for bar colours and appearance
    barChart.setBarColour(color(0, 0, 0));
    // giCenter BarChart method for spacing between bars
    barChart.setBarGap(0);
    // giCenter BarChart method for placing categories on the y axis and values on x axis
    barChart.transposeAxes(true);
  }

  // function for getting individual task names, values, mood
  void getTaskValues()
  {
    outputData = loadJSONArray("data/usertasks.json"); 
    // run through the json array 
    for (int i = 0; i < outputData.size(); i++)
    {
      // get the object at index
      JSONObject taskData = outputData.getJSONObject(i);

      // place the values in the appropriate array at index
      time[i] = taskData.getFloat("totalTime");
      tasks[i] = taskData.getString("taskName");
      moodValue[i] = taskData.getFloat("value");
    }
  }
  // Return function for ensuring the max value of the barChart is set to the largest time value in the time array 
  // This is to ensure that the values are never too large to be displayed
  float GetMaxValue()
  { 
    // set this really low so the first iteration is definitely higher
    float max = -1000000;
    // run through the time array 
    for (int i = 0; i < time.length; i++)
    {
      float value = time[i];
      // if time at i is more than the max, make the max equal to that number
      if (value > max)
      {
        max = value;
      }
    }

    return max;
  }

  // Return function for ensuring the min value of the barChart is set to the smalles time value in the log
  // This is to ensure that the values are never too small to be displayed
  float GetMinValue()
  {
    // set this really high so the first iteration is definitely lower
    float min = 10000000; 
    // run through the time array 
    for (int i = 0; i < time.length; i++)
    {
      float value = time[i];

      // if time at i is less than the max, make the max equal to that number
      if (value < min)
      {
        min = value;
      }
    }

    return min;
  }

  // called in draw
  void drawTaskValues()
  {
    fill(255, 127, 80);
    textSize(14);
    text("Amount of time spent on each listed task.", 20, 20, 500, 20);
    fill(0);
    textSize(10);
    barChart.draw(- 100, 40, width-20, height-60);
  }
}
