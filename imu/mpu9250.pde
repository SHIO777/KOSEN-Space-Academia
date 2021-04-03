import hypermedia.net.*;

UDP udp;
String msg = "";

final String IP = "192.168.1.36";
final int PORT = 5000;
/*user input###################################################*/
final float yMin = -180;//-0.001;    //min value
final float yMax = 180;//0.001;      // max value
final float magnification = 1F;    //1/1000F
final int frequency = 10;  // Hz          ************************
final int tMin = -10;

final int yStepValue = 6;  //number of steps
final int tStepValue = 10;


/*user input###################################################*/

final int dataValue = (-tMin+1) * frequency;
float[] plotData = new float[dataValue];
float[] plotData2 = new float[dataValue];
float[] plotData3 = new float[dataValue];


void setup() {
  size(1000, 600, P3D);
  size(displayWidth, displayHeight, P3D);
  //udp = new UDP(this, PORT);
  udp = new UDP(this, PORT);
  udp.listen(true);
  frameRate(frequency);  //frame rate
  for (int i=0; i<dataValue; i++) {
    plotData[i] = 0;
  }
  for (int i=0; i<dataValue; i++) {
    plotData2[i] = 0;
  }
  for (int i=0; i<dataValue; i++) {
    plotData3[i] = 0;
  }
}


void draw() {
  background(0);
  String[] datas = msg.split(",");
  if (datas.length == 3) {
    //rotateMPU(width/2, height/2, datas);
    TimeHistory(width/4, height/4, "pitch", degrees(float(datas[0])), degrees(float(datas[1])), degrees(float(datas[2])));
    println(degrees(float(datas[0])), degrees(float(datas[1])), degrees(float(datas[2])));
    //TimeHistory(-width/2, -height/2+height/2/5, "pitch", -float(datas[0]));
  }
}

void receive(byte[] data) {
  msg = new String(data);
  //println(msg);
  
}

void rotateMPU(int positionX, int positionY, String[] datas) {
  translate(positionX, positionY);
  fill(255);
  stroke(0);    //stroke color
  strokeWeight(2);
  rotateX(float(datas[0]));     // pitch  andles -> radians
  rotateY(float(datas[1]));      // yaw
  rotateZ(float(datas[2]));      // roll
  box(200, 50, 280);
}

void TimeHistory(int positionX, int positionY, String name, float data1, float data2, float data3) {
  float Width = width/2;    //flame width
  float Height = height/2;    // flame height

  pushMatrix();    //preserve coordinate system
  noFill();
  stroke(255);     //flame line color
  strokeWeight(3);  //flame line width
  //translate(positionX, positionY);
  translate(Width/2, Height/2);
  rect(0, 0, Width, Height);    //draw flame

  // draw scale
  stroke(255);    // scale line color
  strokeWeight(1);    //scale line weight

  //scale value on the horizontal line///////////////////////////
  textSize(Height*0.06);
  textAlign(RIGHT);
  fill(255, 0, 0);    // scale line color
  text("pitch", Width/2, Height*0);
  fill(255, 255, 0);    // scale line color
  text("yaw", Width/2+100, Height*0);
  fill(0, 128, 0);    // scale line color
  text("roll", Width/2+ 200, Height*0);
  fill(255);    // scale line color
  final float yStep = (yMax-yMin) / yStepValue;
  float y = yMin;
  for (float i=yStepValue; i>=0; i--) {
    text(y, -Width/3*0.02, Height/yStepValue*i);
    line(0, Height/yStepValue*i, Width, Height/yStepValue*i);  //horizontal line
    y = y + yStep;
  }
  pushMatrix();
  rotate(radians(-90));
  textAlign(CENTER);
  String mag= String.valueOf(magnification);
  text(name+" (X 1/"+ mag +")", -Height/2, -Width/3*0.5);
  popMatrix();

  //scale value on the vertical line///////////////////////////
  textAlign(CENTER);
  text("now", Width, Height*1.08);
  final int tStep = -tMin / tStepValue;
  int t = tMin;
  for (int i=0; i<=tStepValue-1; i++) {
    text(t, Width/tStepValue*i, Height*1.08);
    line(Width/tStepValue*i, 0, Width/tStepValue*i, Height);  //vertical line
    t = t + tStep;
  }
  text("time [s]", Width/2, Height*1.2);

  pushMatrix();
  translate(0, Height/2, 0);

//pitch
  for (int i=0; i<dataValue-1; i++) {
    plotData[i] = plotData[i+1];
  }
  plotData[dataValue-1] = data1*magnification;

  for (int i=0; i<dataValue-1; i++) {
    stroke(255, 0, 0);
    line(Width/(dataValue-1)*i, Height/yStepValue*plotData[i]/yStep, Width/(dataValue-1)*(i+1), Height/yStepValue*plotData[i+1]/yStep);
  }
  
  //yaw
  for (int i=0; i<dataValue-1; i++) {
    plotData2[i] = plotData2[i+1];
  }
  plotData2[dataValue-1] = data2*magnification;

  for (int i=0; i<dataValue-1; i++) {
    stroke(255, 255, 0);
    line(Width/(dataValue-1)*i, Height/yStepValue*plotData2[i]/yStep, Width/(dataValue-1)*(i+1), Height/yStepValue*plotData2[i+1]/yStep);
  }
  
  //roll
 for (int i=0; i<dataValue-1; i++) {
    plotData3[i] = plotData3[i+1];
  }
  plotData3[dataValue-1] = data3*magnification;

  for (int i=0; i<dataValue-1; i++) {
    stroke(0, 128, 0);
    line(Width/(dataValue-1)*i, Height/yStepValue*plotData3[i]/yStep, Width/(dataValue-1)*(i+1), Height/yStepValue*plotData3[i+1]/yStep);
  }
  popMatrix();
  //stroke(255, 0, 0);

  popMatrix();
}
