Human[] humans = new Human[200];

void setup(){
  size(800, 800);
  stroke(0);
  for (int i = 0; i<humans.length; i++){
    humans[i] = new Human(random(width),random(height));
  }
}

void draw(){
  background(255);
  for(int i = 0; i < humans.length; i++){
    humans[i].display();
    humans[i].jiggle();
    humans[i].mouseEscape();
  }
  
  
  
  
  // //팔다리
  //strokeWeight(14);
  //stroke(48,200,248);
  //strokeCap(ROUND);
  ////다리
  //line(mouseX, mouseY+130, mouseX-20, pmouseY+180);
  //line(mouseX, mouseY+130, mouseX+20, pmouseY+180);
  ////팔
  //line(mouseX, mouseY+75, mouseX-40, pmouseY+105);
  //line(mouseX, mouseY+75, mouseX+40, pmouseY+105);
  
  // //몸통
  //strokeWeight(25);
  //stroke(0);
  //line(mouseX, mouseY+50, mouseX, mouseY + 130);
  ////얼굴
  //strokeWeight(1);
  //stroke(10);
  //fill(48,200,248);
  //ellipse(mouseX, mouseY+50, 55, 55);
  ////눈
  //fill(0);
  //ellipse(mouseX-13, mouseY+45, 6, 6);
  //ellipse(mouseX+13, mouseY+45, 6, 6);
  ////코
  //strokeWeight(3);
  //line(mouseX, mouseY+52, mouseX, mouseY + 57);
  ////입
  //strokeWeight(1);
  //fill(255, 105, 180);
  //triangle(mouseX-10, mouseY+63, mouseX+10, mouseY+63,mouseX, mouseY+70);
}
