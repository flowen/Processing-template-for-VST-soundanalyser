import oscP5.*;
import netP5.*;
OscP5 oscP5;

int height = 60;
float avgi = 0;
float[] oscValues = new float[14];
float[] oscPrev = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
float[] oscAverages = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
float[] oscMax = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
String[] oscNames = { "mel", "mel1", "mel2", "mel3", "mel4", "mel5", "peak", "pitch", "rms", "centroid", "crest", "diff", "flat", "zcr" };

void settings() {
  size(1200, height * oscValues.length, P3D);
}

void setup() {  
  oscP5 = new OscP5(this,8000);
}

void draw() {
  background(0);

  // calculate max
  for (int i = 0; i < oscValues.length; ++i) {
    if (oscValues[i] > oscMax[i]) oscMax[i] = oscValues[i];
  }
  
  avgi++;
  // calculate avg
  for (int i = 0; i < oscValues.length; ++i) {
    int sum = (int)(oscValues[i] + oscPrev[i]);
    oscPrev[i] = sum;
    oscAverages[i] = sum / avgi;
  }


  for (int i = 0; i < oscValues.length; ++i) {
    fill(255);
    rect(0, height*i, oscValues[i], height);
    fill(255,0,0);
    text(oscNames[i] + " cur: " + (int)oscValues[i], width-200, height*i+30);
    text(oscNames[i] + " avg: " + (int)oscAverages[i], width-400, height*i+30);
    text(oscNames[i] + " max: " + (int)oscMax[i], width-600, height*i+30);
    stroke(0,125,125);
    line(0, height*i, width, height*i);
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  // print(" addrpattern: "+theOscMessage.addrPattern());
  // println(" typetag: "+theOscMessage.typetag());
  // println(" get: "+theOscMessage);

  if (theOscMessage.addrPattern().equals("/1/melSpectrum")) {
    oscValues[0] = theOscMessage.get(0).floatValue();
    oscValues[1] = theOscMessage.get(1).floatValue();
    oscValues[2] = theOscMessage.get(2).floatValue();
    oscValues[3] = theOscMessage.get(3).floatValue();
    oscValues[4] = theOscMessage.get(4).floatValue();
    oscValues[5] = theOscMessage.get(5).floatValue();
  }

  if (theOscMessage.addrPattern().equals("/1/peakEnergy")) {
    oscValues[6] = map(theOscMessage.get(0).floatValue(), 0, 1, 0, width);
  }
  
  if (theOscMessage.addrPattern().equals("/1/pitch")) {
    oscValues[7] = theOscMessage.get(0).floatValue();
  }

  if (theOscMessage.addrPattern().equals("/1/rms")) {
    oscValues[8] = theOscMessage.get(0).floatValue();
  }

  if (theOscMessage.addrPattern().equals("/1/spectralCentroid")) {
    oscValues[9] = theOscMessage.get(0).floatValue();
  }

  if (theOscMessage.addrPattern().equals("/1/spectralCrest")) {
    oscValues[10] = theOscMessage.get(0).floatValue();
  }

  if (theOscMessage.addrPattern().equals("/1/spectralDifference")) {
    oscValues[11] = theOscMessage.get(0).floatValue();
  }

  if (theOscMessage.addrPattern().equals("/1/spectralFlatness")) {
    oscValues[12] = theOscMessage.get(0).floatValue();
  }
   
  if (theOscMessage.addrPattern().equals("/1/zcr")) {
    oscValues[13] = theOscMessage.get(0).floatValue();
  } 
}