import processing.serial.*;
import controlP5.*;
import java.io.*;

Serial myPort;
ControlP5 cp5;
int waitTime = 500;
boolean connectionStatus = false;
String fileName = "textfile.txt";
char newLine = '\n';
char carriageReturn = '\r';
boolean stopTrigger = false;
Textarea consoletext;
Println console;

void setup()
{
  noStroke();
  size(800, 520);
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();

  cp5.addTextlabel("title")
    .setText("Monarch Interface Application")
    .setPosition(10, 10)
    .setFont(createFont("Arial", 22))
    .setColor(color(255, 255, 250, 255))
    ;
  cp5.addButton("stopButton")
    .setSize(90, 50)
    .setFont(createFont("arial", 22))
    .setCaptionLabel("STOP")
    .setPosition(20, 70)
    ;
  cp5.addButton("sendButton")
    .setFont(createFont("arial", 22))
    .setSize(90, 50)
    .setCaptionLabel("SEND")
    .setPosition(20, 140)
    ;

  cp5.addTextfield("waitTimeInput")
    .setId(6)
    .setPosition(20, 420)
    .setSize(200, 35)
    .setFont(createFont("arial", 20))
    .setAutoClear(false)
    .setCaptionLabel("Wait per Line")
    .setText(Integer.toString(waitTime))
    ;
  cp5.addTextfield("fileNameInput")
    .setId(6)
    .setPosition(20, 340)
    .setSize(200, 35)
    .setFont(createFont("arial", 20))
    .setAutoClear(false)
    .setCaptionLabel("Filename")
    .setText(fileName)
    ;
  cp5.addTextlabel("statusLabel")
    .setText("Status:")
    .setPosition(20, 220)
    .setFont(createFont("Arial", 20))
    .setColor(color(255, 255, 250, 255))
    ;
  cp5.addTextlabel("statusLabelb")
    .setText("DISCONNECTED")
    .setPosition(55, 255)
    .setFont(createFont("Arial", 20))
    .setColor(color(255, 255, 250, 255))
    ;
  cp5.addTextlabel("ctext")
    .setText("Console | Serial Injection")
    .setPosition(365, 3)
    .setColor(color(200, 0, 0, 255))
    .setFont(createFont("Arial", 18))
    ;
  consoletext = cp5.addTextarea("txt")
    .setPosition(370, 30)
    .setSize(420, 480)
    .setFont(createFont("", 12))
    .setLineHeight(14)
    .setColor(color(255, 255, 255, 255))
    .setColorBackground(color(100, 100))
    .setColorForeground(color(255, 100))

    ;

  myPort = new Serial(this, "COM9", 9600);
  myPort.bufferUntil('\n');
  console = cp5.addConsole(consoletext);
  println("SYSTEM: GUI Loaded");
}

void draw()
{
  background(0);
  fill(255);
}

public void sendButton() {
  stopTrigger = false;
  sendCode();
}
public void stopButton() {
  stopTrigger = true;
}


void sendCode() {
  try {
    FileInputStream fstream = new FileInputStream(sketchPath(fileName));

    DataInputStream in = new DataInputStream(fstream);
    BufferedReader br = new BufferedReader(new InputStreamReader(in));
    
    String strLine;
    while (((strLine = br.readLine()) != null) && (stopTrigger != true)){
      myPort.write(strLine +carriageReturn +newLine);
      println("Sent: " +strLine);
      delay(waitTime);
    }
    in.close();
  }
  catch(Exception e) {
    println("SYSTEM ERROR:");
    println(e.getMessage());
    System.err.println("Error: " +e.getMessage());
  }
}

void controlEvent(ControlEvent event) {
  if (event.isAssignableFrom(Textfield.class)) {
    if ("waitTimeInput".equals(event.getName())) {
      waitTime = Integer.parseInt(event.getStringValue());
      println("Wait Time Updated: " +waitTime);
    }
    if ("fileNameInput".equals(event.getName())) {
      fileName = event.getStringValue();
      if (fileName.endsWith(".txt")) {
        println("Filename Updated: " +fileName);
      } else {
        fileName = fileName += ".txt";
        println("Filename Updated: " +fileName);
      }
    }
  }
} //End of controlEvent