/**    SerialCom.ino sketch to perform some handshaking between
       the arduino and processing.  sends a 'A' character over
       serial port and waits for a 'A' to be sent back from a
       processing sketch to begin communication...
       
       Joseph (relic) Unik  -  10/20/2013
**/


int inByte = 0; // incoming serial byte

void setup()
{
  Serial.begin(9600); 
  establishContact();   // send the character 'A' until contact is established with Processing
}

void loop()
{
}

void establishContact() 
{
  while (Serial.available() <= 0) 
  {
    Serial.write('A'); // send a capital A
    delay(300);
  }
}
