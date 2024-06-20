// Game properties
int gesamtpunktzahl = 0;
int anzahlVersuche = 0;
boolean scored = false;

// Ball properties
int mouseYStart;
int mouseYEnd;

int mouseXTemp;
int mouseYTemp;
int ballSize = 24;

// Throw behaviour
float damping = 0.9;
int throwingStrength = 50;
float verticalSpeed;
boolean ballThrown = false;
boolean throwFalsy = false;

// Assets
PFont font;
PImage background;
PImage ball;
PImage goal;

// Circles for the goal

Basket circleTopLeft;
Basket circleTopRight;
Basket circleFiftee;
Basket circleSixtee;
Basket circleThirtee;

ArrayList<Basket> circles = new ArrayList<Basket>();

class Basket {
  int areaSize;
  int areaPositionX;
  int areaPositionY;
  String areaText;
  
  Basket(int x, int y, int size, String text) {
    areaPositionX = x;
    areaPositionY = y;
    areaSize = size;
    areaText = text;
    goal = loadImage("ziel.png");
  }
  
  boolean detectHit(int ballX, int ballY) {
    int circleRadius = areaSize / 2;
    float distance = dist(areaPositionX, areaPositionY, ballX, ballY);
    return distance <= circleRadius;
  }
  
  void display() {
    fill(255);
    image(goal, areaPositionX - areaSize / 2, areaPositionY - areaSize / 2, areaSize, areaSize);
    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);
    textFont(font);
    text(areaText, areaPositionX, areaPositionY - 30);
    textAlign(BASELINE);
  }
}

void setup() {
  size(400, 600);
  font = createFont("Arial", 16);
  background = loadImage("background.png");
  ball = loadImage("Basketball.png");
}

void draw() {

  // Setting the background image
  image(background, 0, 0, 400, 600);

  // Dimming the background
  fill(0, 0, 0, 160);
  rect(0, 0, width, height);

  // zielwurfzonen
  drawCircles();
  
  // beschriftung zielwurfzone
  drawText();

  // wurfline
  stroke(255, 0, 0);
  line(0, height / 2, 1000, 300);
  stroke(0);

  // ball zeichnen
  drawBall();

  // distanz berechnen
  calculateDistance();
}


void drawCircles() {
  
  circleTopLeft = new Basket(100, 50, 50, "100");
  circleTopLeft.display();
  
  circleTopRight = new Basket(300, 50, 50, "100");
  circleTopRight.display();
  
  circleFiftee = new Basket(197, 105, 50, "50");
  circleFiftee.display();
  
  circleSixtee = new Basket(197, 175, 50, "40");
  circleSixtee.display();
  
  circleThirtee = new Basket(197, 245, 50, "30");
  circleThirtee.display();

  circles.add(circleTopLeft);
  circles.add(circleTopRight);
  circles.add(circleFiftee);
  circles.add(circleSixtee);
  circles.add(circleThirtee);
}

void drawText() {
  fill(255);
  
  textSize(14);
  text("Anzahl Versuche: " + anzahlVersuche, 10, 550);
  text("Punktzahl: " + gesamtpunktzahl, 10, 570);
  text("Wurfstärke: " + throwingStrength, 10, 590);
}

void calculateDistance() {
   for (int i = 0; i < circles.size(); i++) {    

    if (circles.get(i).detectHit(mouseXTemp, mouseYTemp) && verticalSpeed < 0.1) {
      if (scored) {
        return;
      }

      println("Hit detected on ball " + circles.get(i).areaText);
      gesamtpunktzahl += int(circles.get(i).areaText);
      scored = true;
     }
   }
}

void keyPressed() {
  if (key == '+' && throwingStrength <= 100) {
    throwingStrength++;
  } else if (key == '-'  && throwingStrength >= 0) {
    throwingStrength--;
  } else if (key == 'n') {
    ballThrown = false;
    scored = false;
    throwingStrength = 50;
  }
}

void mousePressed() {
  if (mouseY < height / 2 + (ballSize / 2)) {
    throwFalsy = true;
    return;
  }
  
  mouseYStart = mouseY;
}

void mouseDragged() {
  mouseYEnd = mouseY;

  if (mouseYEnd < height / 2 + (ballSize / 2)) {
    throwFalsy = true;
    return;
  } if (mouseYStart < mouseY) {
    return;
  } else if (mouseYEnd == mouseYStart || ballThrown) {
    return;
  }

  throwingStrength = mouseYStart - mouseYEnd;
  fill(255);
  text(throwingStrength, mouseX + 10, mouseYEnd - 10);
}

void mouseReleased() {
  if (throwFalsy) {
    gesamtpunktzahl -= 5;
    throwFalsy = false;
    return;
  } else if (ballThrown) {
    return;
  }

  mouseYTemp = mouseY;
  mouseXTemp = mouseX;
  anzahlVersuche++;

  verticalSpeed = throwingStrength * 0.3;
  ballThrown = true;
}

void drawBall() {

  if (mouseY < (height / 2) && !ballThrown) {
    return;
  }

  fill(255, 0, 0);
  
  if (ballThrown && !throwFalsy) {
    throwBall();
  } else {
    image(ball, mouseX - ballSize / 2, mouseY - ballSize / 2, ballSize, ballSize);
  }
}

void throwBall() {
  if (verticalSpeed < 0.5) {
    verticalSpeed = 0;
  } else {
    if (mouseYTemp <= ballSize) {
      verticalSpeed *= damping;
      mouseYTemp += verticalSpeed;
    } else {
      verticalSpeed -= verticalSpeed / abs(verticalSpeed) * damping;
      mouseYTemp -= verticalSpeed;
    }
  }

  image(ball, mouseXTemp  - ballSize / 2, mouseYTemp  - ballSize / 2, ballSize, ballSize);
}
