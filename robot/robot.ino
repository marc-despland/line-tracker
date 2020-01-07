
#include <ESP8266WiFi.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include "FS.h"
#include "robot.h"

#include "algorithm.h"
#include "algorithmstage1.h"
/*
 * ESP8266 pin usuable for output
0  H       
1  H                        danger
2  H  FAILED BOOT           danger
3                           danger
4     OK  RIGHT_PIN
5     OK  LEFT_PIN
6     UNKNOWN
7     UNKNOWN
8     UNKNOWN
9     FAILED BOOT
10    OK  MUXSIGA_PIN
11    UNKNOWN
12    OK  SER_PIN
13    OK  RCLK_PIN
14    OK  SRCLK_PIN
15  L OK  MUXSIGB_PIN
16    OK  MUXSIGC_PIN       danger
*/
const int RIGHT_PIN = 4;
const int LEFT_PIN = 5;
const int SER_PIN = 12;
const int RCLK_PIN = 13;
const int SRCLK_PIN = 14;
const int MUXENABLE_PIN = -1;
const int MUXSIGA_PIN = 10;
const int MUXSIGB_PIN = 15;
const int MUXSIGC_PIN = 16;
const int MUXSIGNAL_PIN= A0;

const int INTERVAL_TRACKER_MESURE =100;
const int INTERVAL_TICK =100;

const char* ssid     = "Icarus";
const char* password = "Soc1Giad";
Robot * robot;
unsigned long lastTrackerMesure=0;
unsigned long lastTick=0;

enum actionType {donothing, calibration, tests, pilot,modeauto};

actionType action = donothing;

String key="stop";

Algorithm * algorithm = NULL;
 
AsyncWebServer server(80);
 
void setup(){
  Serial.begin(115200);

  if(!SPIFFS.begin()){
    Serial.println("An Error has occurred while mounting SPIFFS");
    return;
  }

  WiFi.softAP(ssid, password);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);
  server.serveStatic("/", SPIFFS, "/")
      .setCacheControl("max-age=600")
      .setDefaultFile("index.html")
      .setLastModified("Sat, 14 Dec 2019 16:38:00 GMT");

  
  server.on("/read", HTTP_GET, [](AsyncWebServerRequest *request){
    int index=0;
    if(request->hasParam("index")) {
      AsyncWebParameter* p = request->getParam("index");
      index=p->value().toInt();
      Serial.print("Read analog ");
      Serial.println(index);
    }
    request->send(200, "text/plain", String(robot->readAnalogMux(index)));
  });
  
  server.on("/action", HTTP_GET, [](AsyncWebServerRequest *request){
    if(request->hasParam("key")) {
      AsyncWebParameter* p = request->getParam("key");
      key=p->value().c_str();
      Serial.print("Received Action request ");
      Serial.println(key);
      if (key=="stop") robot->stop();
      if (key=="top") robot->forward();
      if (key=="topleft") robot->forwardLeft();
      if (key=="topright") robot->forwardRight();
      if (key=="bottom") robot->backward();
      if (key=="bottomleft") robot->backwardLeft();
      if (key=="bottomright") robot->backwardRight();
      if (key=="left") robot->rotateLeft();
      if (key=="right") robot->rotateRight();
    }
    request->send(200, "application/json", "{ \"key\": \""+key+"\" }");
  });

  server.on("/autopilot/run", HTTP_GET, [](AsyncWebServerRequest *request){
    String mode="";
    if(request->hasParam("mode")) {
      AsyncWebParameter* p = request->getParam("mode");
      mode=p->value().c_str();
      Serial.print("Request starting algorithm :");
      Serial.println(mode);
      if (algorithm!=NULL) {
        algorithm->stop();
        delete algorithm;
        algorithm=NULL;
      }
      if (mode=="stage1") {
        algorithm=new AlgorithmStage1(robot);
      }
      if (algorithm!=NULL) algorithm->run();
    }
    request->send(200, "application/json", "{ \"status\": \""+mode+"\" }");
  });  
  server.on("/autopilot/stop", HTTP_GET, [](AsyncWebServerRequest *request){
    Serial.println("Received stopping algorithm ");
    if (algorithm!=NULL) algorithm->stop();
    request->send(200, "application/json", "{ \"status\": \"OK\" }");
  });  
  
  server.on("/mode", HTTP_GET, [](AsyncWebServerRequest *request){
    String set="";
    if(request->hasParam("set")) {
      AsyncWebParameter* p = request->getParam("set");
      set=p->value().c_str();
      Serial.print("Request switch to mode :");
      Serial.println(set);
      action=donothing;
      if (set=="calibration") action=calibration;
      if (set=="pilot") action=pilot;
      if (set=="tests") action=tests;
      if (set=="modeauto") action=modeauto;
    }
    request->send(200, "application/json", "{ \"status\": \""+set+"\" }");
  });  
  
  server.on("/tests/led", HTTP_GET, [](AsyncWebServerRequest *request){
    String id="";
    if(request->hasParam("id")) {
      AsyncWebParameter* p = request->getParam("id");
      id=p->value().c_str();
      Serial.print("Request switch to led :");
      Serial.println(id);
      robot->testLed(id);
    }
    request->send(200, "application/json", "{ \"status\": \""+id+"\" }");
  });  

  server.on("/tests/motors", HTTP_GET, [](AsyncWebServerRequest *request){
    int right=0;
    int left=0;
    Serial.println("motors");
    if(request->hasParam("right") && request->hasParam("left")) {
      AsyncWebParameter* r = request->getParam("right");
      AsyncWebParameter* l = request->getParam("left");
      right=r->value().toInt();
      left=l->value().toInt();
      Serial.print("Send motor left=");
      Serial.print(left);
      Serial.print(" right=");
      Serial.println(right);
      robot->move(left, right);
    }
    request->send(200, "application/json", "{ \"status\": \"OK\" }");
  });  

  
  server.on("/calibrate/black", HTTP_GET, [](AsyncWebServerRequest *request){
    if (action==calibration) {
      robot->calibrateTracker(black);
    }
    request->send(200, "application/json", "{ \"status\": \"OK\" }");
  });  
  server.on("/calibrate/white", HTTP_GET, [](AsyncWebServerRequest *request){
    if (action==calibration) {
      robot->calibrateTracker(white);
    }
    request->send(200, "application/json", "{ \"status\": \"OK\" }");
  });  
 
  server.begin();
  robot=new Robot(RIGHT_PIN, LEFT_PIN, SER_PIN, RCLK_PIN, SRCLK_PIN, MUXENABLE_PIN, MUXSIGA_PIN, MUXSIGB_PIN, MUXSIGC_PIN, MUXSIGNAL_PIN);
  rst_info *resetInfo;
  resetInfo = ESP.getResetInfoPtr();
  Serial.println(resetInfo->reason);
}
 
void loop(){
  /*
  if ((action!=calibration) && (action!=tests)) {
    if (millis()-lastTrackerMesure>INTERVAL_TRACKER_MESURE) {
      robot->readTrackers();
      lastTrackerMesure=millis();
    }
  }
  if ((action==modeauto) && (algorithm!=NULL)) {
    if (millis()-lastTick>INTERVAL_TICK) {
      algorithm->tick();
      lastTick=millis();
    }
  } */

}
