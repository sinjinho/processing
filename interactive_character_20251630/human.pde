class Human {
  float x, y;
  Human(float tempX, float tempY){
    x = tempX; y = tempY;
  }
  
  void display(){
    strokeWeight(14);
    stroke(48,200,248);
    strokeCap(ROUND);
    //다리
    line(x, y+130, x-20, y+180);
    line(x, y+130, x+20, y+180);
    //팔
    line(x, y+75, x-40, y+105);
    line(x, y+75, x+40, y+105);
    
     //몸통
    strokeWeight(25);
    stroke(0);
    line(x, y+50, x, y + 130);
    //얼굴
    strokeWeight(1);
    stroke(10);
    fill(48,200,248);
    ellipse(x, y+50, 55, 55);
    //눈
    fill(0);
    ellipse(x-13, y+45, 6, 6);
    ellipse(x+13, y+45, 6, 6);
    //코
    strokeWeight(3);
    line(x, y+52, x, y + 57);
    //입
    strokeWeight(1);
    fill(255, 105, 180);
    triangle(x-10, y+63, x+10, y+63,x , y+70);
  }
  
  void jiggle(){ //모든 걸 실패했을 때의 최후대안 
    x = x + random(-1,1); 
    y = y + random(-1,1); 
    x = constrain(x,0,width);
    y = constrain(y,0,height); 
  }
  
  void mouseEscape(){
    float distX = x - mouseX;
    float distY = y + 50 - mouseY; // 몸통을 기준으로 판단하기 위해 50추가
    float distance = dist(x, y+50, mouseX, mouseY);
    
    if (distance < 100) {
      float speed = map(distance, 0, 100, 3, 1); 
      float angle = atan2(distY, distX); // 도망가는 방향 계산

      x += cos(angle) * speed;
      y += sin(angle) * speed;
    }
    
    x = constrain(x,0,width);
    y = constrain(y,0,height); 
  }
}
