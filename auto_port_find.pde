/**    SerialCom.ino sketch MUST be uploaded to arduino to work!
       Auto locates the Arduino's COM ort.  searches for a 'A' character over
       serial port and then sends a 'A' back to the arduino initiating the
       communication.  Reports the COM port that was found.
       
       Joseph (relic) Unik  -  10/20/2013
**/


import processing.serial.*;

Serial myPort;

boolean pause = true;
boolean searchInProgress;
boolean noPort;

int portCount;
int comport, comport2;               // if bluetooth module is being used it sometimes echoes the arduino handshaking char
int inByte, portFound;
int[] availablePorts = new int[3];   // stores available COM port index numbers
int portsInArray = 0;                // number of arduino ports found, should be 1 unless bluetooth is being used

String portName, msg;

void setup()
{
  background(0);
  size(1024, 768);
  arduinoSearch();
}


void draw()
{
  if(pause == false)   // pause loop until port is found...
  {
    //  any code outside of this loop will always loop
    background(0);
    stroke(0, 128, 255);
    fill(0);
    rect(155, 175, 675, 400);
    fill(255,255,255);
    textAlign(CENTER);
    text("Arduino responded on port index # " + comport, width/2, height/2 - 30);
    portName = Serial.list()[comport];
    text("Port index # " + comport + " is  " + portName, width/2, height/2 + 30);
    textAlign(LEFT);      // always set textalign back to left ;)
  }
}

void mousePressed()
{
  findComPort();
}

void arduinoSearch()
{
  pause = true;
  delay(10);
  background(0);
  searchInProgress = false;
  stroke(0, 128, 255);
  fill(0);
  rect(155, 175, 675, 400);
  fill(255);
  textAlign(CENTER);
  text("Arduino COM port discovery tool", width/2, 240);
  text("It appears that the application has been run for the very first time and / or", width/2, 300);
  text("the COM port has changed.  The application will now search all available COM", width/2, 330);
  text("ports looking for the Arduino's COM port.", width/2, 360);
  text("the search need not be repeated .. unless the COM ports change in the future", width/2, 390);
  text("... Connect the Arduino to a USB port before continuing ...", width/2, 450);
  fill(0, 255, 0);
  text(".. Click the mouse button to start searching .. this will take a few minutes ..", width/2, 500);
  textAlign(LEFT);
}

void findComPort()
{
  background(0);
  stroke(0, 128, 255);
  fill(0);
  rect(155, 175, 675, 400);
  fill(255);
  
  for(portCount = 0; portCount < Serial.list().length; portCount ++) 
  {
   portName = Serial.list()[portCount];
   
   try 
   {
     myPort = new Serial(this, portName, 9600);
   } 
   catch (NullPointerException e) 
   {
     e.printStackTrace();
     portName = null;
   }

   if (portName == null)    
   {
     pause = false;
     println("NULL Serial");  
     msg = "Error Connecting to Port or Port not Found";
     text(msg, 235, 300);
     delay(2000);
     arduinoSearch();
   } 

   else 
   {
     delay(2000);
     
     if (myPort.available() > 0)
     {
       inByte=(char)myPort.read();   
     }
    
     println("Data  Found = " + inByte);
     
     if (inByte == 65)
     {
       pause = false;
       portFound = portCount;
       println("found port " + portCount + " which is " + portName);
       availablePorts[portsInArray] = portFound;
       portsInArray ++;
       pause = true;
     }   
   }  
    myPort.stop();
  }  
  
  comport = availablePorts[0];
  comport2 = availablePorts[1];
  
  println("Done scanning Ports - " + (portsInArray) + " Ports found...");
  
  if((portsInArray) == 0) 
  {
    fill(255);
    textAlign(CENTER);
    text("... No Arduino found on any port ...", width/2, height/2-30);
    text("Did you upload the SerialCom.ino example to the Arduino?", width/2, height/2+30);
    
  }
  
  if((portsInArray) > 0)
  {
    pause = false;
  }
}
