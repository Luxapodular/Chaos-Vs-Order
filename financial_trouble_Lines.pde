ArrayList<Circle> circleList = new ArrayList<Circle>();

Stock stockValue;


void setup() {
  size(800,300);
  background(100);
  stockValue = new Stock();
  ellipseMode(CENTER);
}


void draw() {
  background(255);
  drawTicker();
  makeStock();
  makeLines();
  updateStock();  
  //drawStock(); 
}

void drawTicker() {
  strokeWeight(2);
  stroke(color(map(stockValue.average, height/2, height, 0, 155)+100, 0,0));
  line(0,stockValue.average, int(width), stockValue.average);
}

void makeLines() { 
  for (int i = 0; i < circleList.size(); i++) {
    if (i > 0) { 
      Circle left = circleList.get(i-1);
      Circle right = circleList.get(i);
      Line currLine = new Line(left.x,left.y,right.x, right.y,right.fillColor);
      currLine.drawMe();
    }
  }
}

  
void makeStock() {
  circleList.add(new Circle(stockValue.x,stockValue.y));
}

void updateStock() {
  int total = 0;
  for (Circle circ: circleList) {
    circ.move(circ.velX, circ.velY);
    total += circ.y;
    circ.update();
  }
  
  for (int i =0; i < circleList.size(); i++) {
    if (!(circleList.get(i).alive)) {
      circleList.remove(i);
    }
  }
  stockValue.update();
  stockValue.average = total /circleList.size();
}

void drawStock() {
  for (Circle circ: circleList) {
    circ.drawMe();
  }
}


class Stock {
  int change;
  int x;
  int y;
  float average;
 
  Stock() {
    this.x = int(width * .9);
    this.y = int(height * .5);
    this.change = 0;
  
  }
 
  void update() {
    this.change = this.checkChange();
    this.y += change;  
  }
  
  int checkChange() {
    float changeConstant = 1; //Value between 1 and 0, higher numbers = rapid changes
    float upperBound = height * changeConstant ;
    int ratio = int(map(mouseX, 0,width,0,upperBound));
    
    int sign;
    int check;

    float a1 = height * .1;
    float a2 = height * .2;
    float b2 = height * .8;
    float b1 = height * .9;
    
    if (stockValue.y < 0) {
      check = 0;
    } else if (stockValue.y < a1) {
      check = 1;
    } else if (stockValue.y < a2) {
      check = 3;
    } else if (stockValue.y > height) {
      check = 10;
    } else if (stockValue.y > b2) { 
      check = 9;
    } else if (stockValue.y > b1) {
      check = 7;
    } else {
      check = 5;
    }
    
    float randomNum = random(0,10);
    if (randomNum < check) {
      sign = -1;
    } else {
      sign = 1;
    }
    
    float smallestChange = random(ratio/5.0);
    int largestChange = ratio;
    
    return sign * int(random(smallestChange,largestChange));
  }
}

class Shape {
  int x;
  int y;
  color fillColor = color(0);
  int sWeight = 1;
  boolean alive = true;
  int diameter;
  int velX;
  int velY;
  
  Shape(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void move(int xVel,int yVel) {
    this.x = this.x + xVel;
    this.y = this.y + yVel;
  }
  
  void check() {
    if ((this.x + this.diameter) < 0) {
      this.alive = false;
    }
  }
      
  void update() {
    this.check();
  }
}
  
class Circle extends Shape {
  int size;
  int velY;
  int velX;
  int diameter;
  
  Circle(int x, int y) {
    super(x,y);
    this.size = 5;
    this.velY = 0;
    this.velX = -1;
    this.diameter = this.size;
    this.fillColor = this.chooseColor();
  }
  
  void drawMe() {
    fill(this.fillColor);
    noStroke();  
    ellipse(this.x, this.y, this.size, this.size);
  }
  
  color chooseColor() {
    return color(map(this.y, height/2, height, 0, 155)+100, 0,0);
  }
}

class Line extends Shape {
  int x1;
  int y1;
  int x2;
  int y2;
  color strokeColor;
  
  Line(int x1, int y1, int x2, int y2, color strokeColor) {
    super(x1,y1);
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.strokeColor = strokeColor;
  }
  
  void drawMe() {
    stroke(this.strokeColor);
    line(this.x1, this.y1, this.x2, this.y2);
  }
}

  
