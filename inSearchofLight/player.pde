class Player {
  float x, y;
  float speed = 2.5;
  float size = 20;
  boolean up, down, left, right;
  
  Player(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }
  
  void moveUpdate() {
    if (up) y -= speed;
    if (down) y += speed;
    if (left) x -= speed;
    if (right) x += speed;
    
    x = constrain(x, 0, width);
    y = constrain(y, 0, height);
  }
  
  void display() {
    float flashAngle = atan2(mouseY - y, mouseX - x);
    float flashR = 150; // 손전등 반지름

    //손전등
    noStroke();
    fill(255, 255, 100, 80);
    arc(x, y, flashR, flashR, flashAngle - PI/6, flashAngle + PI/6);
    
    //몸통
    fill(0, 100, 255);
    ellipse(x, y, size, size);
  }

}
