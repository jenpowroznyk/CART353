//Importing Library //<>//
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

// Creating barChart object
BarChart barChart;
// Creating an arrayList of Strings
ArrayList<String[]> tableOfContents = new ArrayList<String[]>();

void setup()
{
  size(600, 400);

  // Read content of timelog file and create a string array of it's individual lines
  String[] timeLogData = loadStrings("timelog");
  // Array to test for "//" string
  String[] checkIfMatched;
  
  // Run through each line element of the timeLogData array
  // Check for "//", if the string data found is the same, skip this string and continue to the next
  // If the data isn't matched, split the string at each comma and add that to the tableOfContents array
  for (String line : timeLogData)
  {
    checkIfMatched = match(line, "//");
    if (checkIfMatched!= null)
    {
      continue;
    }

    tableOfContents.add(line.split(","));
  }

  // Create new BarChart object
  // Create new Array of floats to hold the time value spent on each category
  // Create new Array of Strings to hold the category name
  barChart = new BarChart(this);
  float[] userValues = new float [tableOfContents.size()];
  String[] thingsUserDid = new String [tableOfContents.size()];
  
  // Run through all the seperated string data from our timelog file
  for (int i = 0; i < tableOfContents.size(); i++)
  {
    // Get the value at index 1 (time spent on category), return a float value instead of a string and put it in the userValues array
    userValues[i] = Float.parseFloat(tableOfContents.get(i)[1]);
    // Get the value at index 0 (category name), append it to index 2 (negative or positive value), put it in the thingsUserDid array
    thingsUserDid[i] = tableOfContents.get(i)[0] + " (" + tableOfContents.get(i)[2] + ")";
  }
 
  // giCenter barChart method that creates the bar length for the chart using the values stored in the userValues array
  barChart.setData(userValues);

  // giCenter barChart method that scales the size of the chart by setting a minimum and maximum value 
  // If the value is larger than the smallest time value, display it
  barChart.setMinValue(GetMinValue());
  // If the value is smaller than the set largest time value, display it
  barChart.setMaxValue(GetMaxValue());

  // Create font, set it to serif at size 10
  textFont(createFont("Serif", 10), 10);

  // giCenter barChart method choosing to display the value axis
  barChart.showValueAxis(true);
  // giCenter barChart method setting the thingsUserDid value as the bar labels //<>//
  barChart.setBarLabels(thingsUserDid);
  // giCenter barChart method choosing to display the category axis
  barChart.showCategoryAxis(true);

  // giCenter BarChart method for bar colours and appearance
  barChart.setBarColour(color(0, 0, 0));
  // giCenter BarChart method for spacing between bars
  barChart.setBarGap(1);

  // giCenter BarChart method for placing categories on the y axis and values on x axis
  barChart.transposeAxes(true);
}

// Draws the chart in the sketch
void draw()
{
  // Give the chart a size, a location and draw it
  // giCenter BarChart.draw(x location, y location, size, size)
  background(255);
  barChart.draw(15, 15, width-30, height-30);
}

// Return function for ensuring the max value of the barChart is set to the largest time value in the log
// This is to ensure that the values are never too large to be displayed
float GetMaxValue()
{
  float max = 0;

  for (String[] splitLine : tableOfContents)
  {
    float value = Float.parseFloat(splitLine[1]);

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

  for (String[] splitLine : tableOfContents)
  {
    float value = Float.parseFloat(splitLine[1]);
    if (value < min)
    {
      min = value;
    }
  }

  return min;
}

// Return function for the total amount of "positive" time spent
float GetTotalPositiveTime()
{
  float totalPositiveTime = 0;
  for (String[] splitLine : tableOfContents)
  {
    // if string at index 2 is equal to "positive" then convert index 2 into a float and add that value to totalPositiveTime 
    if (splitLine[2].equalsIgnoreCase("positive"))
    {
      totalPositiveTime += Float.parseFloat(splitLine[1]);
    }
  }
  return totalPositiveTime;
}

// Return function for the total amount of "negative" time spent
float GetTotalNegativeTime()
{
  float totalNegativeTime = 0;
  for (String[] splitLine : tableOfContents)
  {
     // if string at index 2 is equal to "positive" then convert index 2 into a float and add that value to totalNegativeTime 
    if (splitLine[2].equalsIgnoreCase("negative"))
    {
      totalNegativeTime += Float.parseFloat(splitLine[1]);
    }
  }
  return totalNegativeTime;
}
