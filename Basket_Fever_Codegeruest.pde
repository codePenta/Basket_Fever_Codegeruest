// Game properties
int gesamtpunktzahl = 0;
int anzahlVersuche = 0;


// Ball properties
int mouseYStart;
int mouseYEnd;
int mouseXTemp;
int mouseYTemp;
int ballSize = 24;

// Throw behaviour
float damping = 0.9;
int throwingStrength = 50;
float movementSpeed;
boolean ballThrown = false;
boolean throwFalsy = false;

PImage background;
PImage ball;
PImage goal;

// Circles for the goal
Circle circleTopLeft;
Circle circleTopRight;
Circle circleFiftee;
Circle circleSixtee;
Circle circleThirtee;

ArrayList<Circle> circles = new ArrayList<Circle>();

class Circle {
  int areaSize;
  int areaPositionX;
  int areaPositionY;
  String areaText;
  
  Circle(int x, int y, int size, String text) {
    areaPositionX = x;
    areaPositionY = y;
    areaSize = size;
    areaText = text;
    goal = loadImage("ziel.png");
  }
  
  boolean detectHit(int ballX, int ballY) {
    int circleRadius = areaSize / 2;
    return dist(areaPositionX, areaPositionY, ballX, ballY) <= circleRadius;
  }
  
  void display() {
    fill(255);
    image(goal, areaPositionX - areaSize / 2, areaPositionY - areaSize / 2, areaSize, areaSize);
    fill(0,0,0);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(areaText, areaPositionX, areaPositionY);
    textAlign(BASELINE);
  }
}

void setup() {
  size(400, 600);
  background = loadImage("background.png");
  ball = loadImage("Basketball.png");
}

void draw() {
  image(background, 0, 0, 400, 600);

  // zielwurfzonen
  drawCircles();
  
  // beschriftung zielwurfzone
  drawText();

  // wurfline
  line(0, height / 2, 1000, 300);

  // ball zeichnen
  drawBall();

  // distanz berechnen
  calculateDistance();
}


void drawCircles() {
  
  circleTopLeft = new Circle(100, 50, 50, "100");
  circleTopLeft.display();
  
  circleTopRight = new Circle(300, 50, 50, "100");
  circleTopRight.display();
  
  circleFiftee = new Circle(197, 105, 50, "50");
  circleFiftee.display();
  
  circleSixtee = new Circle(197, 175, 50, "40");
  circleSixtee.display();
  
  circleThirtee = new Circle(197, 245, 50, "30");
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
     if (circles.get(i).detectHit(mouseXTemp, mouseYTemp) && ballThrown && movementSpeed < 0.1) {
        println("Hit detected on ball " + circles.get(i).areaText);
        gesamtpunktzahl += int(circles.get(i).areaText);
        ballThrown = false;
        return;
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
    throwingStrength = 50;
  }
}

void mousePressed() {
  if (mouseY < height / 2 + (ballSize / 2)) {
    return;
  }
  mouseYStart = mouseY;
}

void mouseDragged() {
  mouseYEnd = mouseY;

  if (mouseYEnd < height / 2 + (ballSize / 2)) {
    throwFalsy = true;
    return;
  } else if (mouseYEnd == mouseYStart) {
    return;
  }

  throwingStrength = mouseYStart - mouseYEnd;

  strokeCap(ROUND);
  line(mouseX, mouseYStart, mouseX, mouseYEnd);
  strokeCap(PROJECT);
}

void mouseReleased() {
  if (throwFalsy) {
    gesamtpunktzahl -= 5;
    throwFalsy = false;
    return;
  }// else if (ballThrown) {
  //   return;
  // }

  mouseYTemp = mouseY;
  mouseXTemp = mouseX;
  anzahlVersuche++;

  movementSpeed = throwingStrength * 0.4;
  ballThrown = true;
}

void drawBall() {

  if (mouseY < (height / 2 + (ballSize / 2)) && !mousePressed && !ballThrown) {
    noCursor();
    return;
  }

  cursor();
  
  fill(255, 0, 0);
  
  if (ballThrown) {
    throwBall();
  } else {
    image(ball, mouseX - ballSize / 2, mouseY - ballSize / 2, ballSize, ballSize);
  }
}

void throwBall() {
  if (movementSpeed < 0.5) {
    movementSpeed = 0;
  } else {
    if (mouseYTemp < 0) {
      movementSpeed = -abs(movementSpeed);
    }

    movementSpeed -= movementSpeed / abs(movementSpeed) * damping;
    mouseYTemp -= movementSpeed;
  }
  
  image(ball, mouseXTemp  - ballSize / 2, mouseYTemp  - ballSize / 2, ballSize, ballSize);
}
