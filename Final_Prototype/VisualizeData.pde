 //<>//
//Importing Library
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
  JSONArray outputData ;
  BarChart barChart;

  float[] time;
  float[] moodValue;
  String[] tasks;

  float x = 50;
  float y = 50;
  float size;

  VisualizeData(PApplet pApp)
  {
    barChart = new BarChart(pApp);
    
    
    outputData = loadJSONArray("data/usertasks.json"); 
    time = new float [outputData.size()];
    moodValue = new float [outputData.size()];
    tasks = new String [outputData.size()];

    getTaskValues();
    // Create font, set it to serif at size 10

    // If the value is larger than the smallest time value, display it
    barChart.setMinValue(GetMinValue());
    // If the value is smaller than the set largest time value, display it
    barChart.setMaxValue(GetMaxValue());
    
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
  void getTaskValues()
  {
 
    outputData = loadJSONArray("data/usertasks.json"); 
    for (int i = 0; i < outputData.size(); i++)
    {
      JSONObject taskData = outputData.getJSONObject(i);

      time[i] = taskData.getFloat("totalTime");
      tasks[i] = taskData.getString("taskName");
      moodValue[i] = taskData.getFloat("value");
    }
  }
  // Return function for ensuring the max value of the barChart is set to the largest time value in the log
  // This is to ensure that the values are never too large to be displayed
  float GetMaxValue()
  {
    float max = -1000000;

    for (int i = 0; i < time.length; i++)
    {
      float value = time[i];

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
    float min = 10000000; 

    for (int i = 0; i < time.length; i++)
    {
      float value = time[i];
      if (value < min)
      {
        min = value;
      }
    }

    return min;
  }

  //// Return function for the total amount of "positive" time spent
  //float GetTotalPositiveTime()
  //{
  //  float totalPositiveTime = 0;
  //  for (String[] splitLine : tableOfContents)
  //  {
  //    // if string at index 2 is equal to "positive" then convert index 2 into a float and add that value to totalPositiveTime 
  //    if (splitLine[2].equalsIgnoreCase("positive"))
  //    {
  //      totalPositiveTime += Float.parseFloat(splitLine[1]);
  //    }
  //  }
  //  return totalPositiveTime;
  //}


  void drawTaskValues()
  {
    textFont(createFont("Serif", 10), 10);
    barChart.draw(15, 15, width-30, height-30);
  }
}