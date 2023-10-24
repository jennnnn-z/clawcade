// Clawcade
// This is the big brains of the claw machine that powers everything

import gifAnimation.*;

// claw movement source: 
// https://forum.processing.org/two/discussion/16594/can-multiple-keys-be-pressed-on-the-keyboard

import processing.serial.*;

Gif win;
Gif block;
Gif block2;
Gif bear;
PImage claw;
Animation prize;
PImage prizeidle;
PImage prizeleft;
PImage prizeright;

Serial myPort;  // Create object from Serial class
static String val;    // Data received from the serial port
int valint;
//int sensorVal = 0;

float x=width/2;
float y=height/2;
float clawWidth, clawHeight;
float xvel=0;
float yvel=0;
float frict = .9;
float vel = 0.6;

boolean isLeft, isRight, isUp, isDown; 
boolean prizeLeft, prizeRight, prizeUp, prizeDown;

int prizeX, prizeY, prizeWidth, prizeHeight;
int prizeInitX;
boolean hasCaughtPrize = false;
int moveSpeed = 10;
boolean blockScreen = false; // blocks the screen
int timeout = 500;
boolean clawCanMove = false;
float keyPressedTime = 0;
int collisionTime = 0;
int winTime = 2000;
int blockScreenTime = 3000;
boolean bearbool;
//int startTime;
ArrayList<Projectile> projectiles;  // ArrayList to store projectiles


void setup() {
  //size(360, 640);
  size(1900, 3300);
  //startTime = millis();
  // x = 360, y = 640 for small screen
  // x = 1900, y = 3300 for big screen
  frameRate(24);
  x = 10;
  y = 0;
  clawWidth = 40 * 4;
  clawHeight = 60 * 4;

  prizeWidth = 100 * 4;
  prizeHeight = 100 * 4;
  prizeX = int(random(width - prizeWidth));
  prizeY = height - prizeHeight - 10;

  win = new Gif(this, "giphy.gif");
  win.play();
  block = new Gif(this, "angrybear.gif");
  block.play();
  block2 = new Gif(this, "angrybear2.gif");
  block2.play();
  bearbool = false;
  
  claw = loadImage("Claw Game Machine.png");
  // claw image from https://cdn0.iconfinder.com/data/icons/amusement-park-30/512/claw-game-machine-amusement-park-512.png 
  prizeleft = loadImage("prizeleft(2).png");
  prizeright = loadImage("prizeright(1).png");
  prize = new Animation("prizeidle", 24);
  
  // projectiles
  projectiles = new ArrayList<Projectile>();

  
  String portName = Serial.list()[2];
  println("Connected on: " + portName);
  myPort = new Serial(this, portName, 9600);
}

void draw() {

  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n'); 
  }
  if(val != null) {
    valint = int(val.trim());
    println(valint);
  }

  background(255,198,217);

  // Draw claw
  image(claw, x, y, clawWidth, clawHeight);

  // Movement
  x=x+xvel; 
  y=y+yvel;
  //if ((isLeft ^ isRight) && (isUp ^ isDown)) {
  if(clawCanMove){
    if (isLeft)xvel=xvel-frict;
    if (isRight)xvel=xvel+frict;
  }
    //if (isLeft)xvel=xvel-frict;
    //if (isRight)xvel=xvel+frict;
    if (isDown)yvel=yvel+frict;
    if (isUp)yvel=yvel-frict;
  //}
  yvel=yvel*frict;
  xvel=xvel*frict;

  //setting movement bools
  if(val != null && valint != 0){
    if(valint == 1 || valint == 2){
      if(valint == 1) isLeft = true;
      if(valint == 2) isRight = true;
      if (keyPressedTime == 0) {
        keyPressedTime = millis();
      } else {
        float elapsedTime = millis() - keyPressedTime;
        if (elapsedTime >= timeout) {
          blockScreen(bearbool);
          print("AHHHHH\n");
        }
      }
    }
    if(valint == 3){
      isDown = true;
      isUp = false;
      clawCanMove = false;
    }
    if(valint == 4) prizeLeft = true;
    if(valint == 5) prizeRight = true;
  } else {
    keyPressedTime = 0;
    isLeft = false;
    isRight = false;
    isUp = true;
    isDown = false;
    bearbool = !bearbool;
    //blockScreen = false;
    //prizeLeft = false;
    //prizeRight = false;
  }

  x = constrain(x, 0, width - clawWidth);
  y = constrain(y, 0, height - clawHeight);

  // Prize Movement
  if (prizeRight){
    prizeX = (prizeX + moveSpeed) % width;
    image(prizeright, prizeX, prizeY, prizeWidth, prizeHeight);
  }
  else if (prizeLeft){
    prizeX = (prizeX + width - moveSpeed) % width;
    image(prizeleft, prizeX, prizeY, prizeWidth, prizeHeight);

  }
  else prize.display(prizeX, prizeY);

  if (prizeUp) prizeY = prizeY - moveSpeed / 2;
  if (prizeDown) prizeY = prizeY + moveSpeed / 2;

  prizeY = constrain(prizeY, 0, height - prizeHeight);

  if(y == 0){
    clawCanMove = true;
  }
  
  // From ChatGPT
  // Create new projectiles at random y intervals
  if (frameCount % 60 == 0) {
    projectiles.add(new Projectile());
  }

  // From ChatGPT
  // Update and display projectiles
  for (int i = projectiles.size() - 1; i >= 0; i--) {
    Projectile p = projectiles.get(i);
    p.move();
    p.display();
    
    // Check for collision with the claw
    if (p.collide(x, y, clawWidth, clawHeight)) {
      resetSketch();
      projectiles.remove(i);
    }
    
    // Remove projectiles that are off-screen
    if (p.x > width) {
      projectiles.remove(i);
    }
  }

  // Win Condition
  if (
    x < prizeX + prizeWidth &&
    x + clawWidth > prizeX &&
    y < prizeY + prizeHeight &&
    y + clawHeight > prizeY
    ) {
    hasCaughtPrize = true;
    collisionTime = millis();
  }
  if (hasCaughtPrize) {
    println("YUHHH WINNN");
    image(win, width/2 - win.width, height/2 - win.height, win.width * 2, win.height * 2);
    
    x = 0;
    y = 0;
    if(millis() - collisionTime >= winTime){
      resetSketch();
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    setMove(keyCode, true);
    if (keyPressedTime == 0) {
      keyPressedTime = millis();
    } else {
      float elapsedTime = millis() - keyPressedTime;
      if (elapsedTime >= timeout) {
        blockScreen(bearbool);
        print("AHHHHH\n");
      }
    }
  } else {
    if (key == 'a') prizeLeft = true;
    if (key == 'd') prizeRight = true;
    if (key == ' '){
      isDown = true;
      isUp = false;
      clawCanMove = false;
    }
    //if (key == 'w') prizeUp = true;
    //if (key == 's') prizeDown = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    setMove(keyCode, false);
    keyPressedTime = 0;
  } else {
    if (key == 'a') prizeLeft = false;
    if (key == 'd') prizeRight = false;
    if (key == ' '){
      isDown = false;
      isUp = true;
    }
    //if (key == 'w') prizeUp = false;
    //if (key == 's') prizeDown = false;
  }
  blockScreen = false;
  //bearbool = !bearbool;
}

boolean setMove(int k, boolean b) {
  switch (k) {
  case UP:
    return isUp = b;

  case DOWN:
    return isDown = b;

  case LEFT:
    return isLeft = b;

  case RIGHT:
    return isRight = b;

  default:
    return b;
  }
}

void blockScreen(boolean bearbool) {
    if(bearbool) bear = block;
    else bear = block2;
    
    xvel = 0;
    yvel = 0;
    fill(0, 0, 0, 100);
    rect(0, 0, width, height);
    image(bear, width/2 - win.width, height/2 - win.height, win.width * 2, win.height * 2);
    timeout = round(random(500, 2000));
}

void resetSketch() { 
  //prizeX = prizeInitX;
  prizeX = round(random(width - prizeWidth));
  prizeY = height - prizeHeight - 10;
  hasCaughtPrize = false;
  x = 10;
  y = 10;
  xvel = 0; 
  yvel = 0;
  isDown = false;
}

// from ChatGPT
class Projectile {
  float x;
  float y;
  float speed;
  PImage fireball;
  
  Projectile() {
    x = 0;
    y = random(clawHeight + 10, height - 200);
    speed = random(1, 5);
    fireball = loadImage("FIREBALL.png");
  }
  
  void move() {
    x += speed;
  }
  
  void display() {
    image(fireball, x, y, fireball.width * 4, fireball.height * 4);
  }
  
  boolean collide(float cx, float cy, float cw, float ch) {
    // Check for collision with a rectangle (claw)
    float testX = constrain(x, cx, cx + cw);
    float testY = constrain(y, cy, cy + ch);
    
    float d = dist(x, y, testX, testY);
    
    return d < 10; // Adjust this value for more accurate collision detection
  }
}
