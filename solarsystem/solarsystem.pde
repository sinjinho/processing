PVector[] stars;
int numStars = 500;
// 필요한 색상과 크기 상수는 constants.pde에서 
Planet sun;
Planet mercury;
Planet venus;
Planet earth;
Planet moon;
Planet mars;
Planet jupiter;
Planet saturn;
Planet uranus;

void setup() {
  size(1200, 850, P3D);
  noStroke();

  // 별의 위치 초기화
  stars = new PVector[numStars];
  for (int i = 0; i < numStars; i++) {
    float x = random(-width * 2, width * 2);
    float y = random(-height * 2, height * 2);
    float z = random(-1000, 1000);
    stars[i] = new PVector(x, y, z);
  }

  sun = new Planet(SUN_DISTANCE); // 태양은 중간에
  mercury = new Planet(MERCURY_DISTANCE); 
  venus = new Planet(VENUS_DISTANCE);   
  earth = new Planet(EARTH_DISTANCE);   
  moon = new Planet(MOON_DISTANCE);
  mars = new Planet(MARS_DISTANCE);    
  jupiter = new Planet(JUPITER_DISTANCE); 
  saturn = new Planet(SATURN_DISTANCE);  
  uranus = new Planet(URANUS_DISTANCE);  
}

void draw() {
  background(0);

  // 별
  pushMatrix();
  translate(width / 2, height / 2, 0);
  fill(255); 
  noStroke();
  for (int i = 0; i < stars.length; i++) {
    PVector star = stars[i];

    star.z += 1;

    // 별이 화면 경계를 벗어나면 다시 초기 위치로 설정
    if (star.z > 1000) {
      star.z = -1000; 
      star.x = random(-width * 2, width * 2); 
      star.y = random(-height * 2, height * 2); 
    }

    pushMatrix();
    translate(star.x, star.y, star.z);
    sphere(2); 
    popMatrix();
  }
  popMatrix();

  translate(width / 2, height / 2 - 200, -200);

  rotateX(PI / 3);

  // 태양
  sun.center(SUN_SIZE, SUN_COLOR);

  // 수성
  mercury.orbit(1); 
  mercury.show(MERCURY_SIZE, frameCount * speed * MERCURY_SPEED, MERCURY_COLOR); 

  // 금성
  venus.orbit(1); 
  venus.show(VENUS_SIZE, frameCount * speed * VENUS_SPEED, VENUS_COLOR); 

  // 지구
  earth.orbit(1); 
  earth.show(EARTH_SIZE, frameCount * speed * EARTH_SPEED, EARTH_COLOR); 
  // 달
  pushMatrix();
    float earthX = EARTH_DISTANCE * cos(frameCount * speed * EARTH_SPEED);
    float earthY = EARTH_DISTANCE * sin(frameCount * speed * EARTH_SPEED);
    translate(earthX, earthY, 0);
    rotateY(PI / 5);
    moon.orbit(1);
    moon.show(MOON_SIZE, frameCount * speed * MOON_SPEED, MOON_COLOR);
  popMatrix();

  // 화성
  mars.orbit(1); 
  mars.show(MARS_SIZE, frameCount * speed * MARS_SPEED, MARS_COLOR); 

  // 목성
  jupiter.orbit(1); 
  jupiter.show(JUPITER_SIZE, frameCount * speed * JUPITER_SPEED, JUPITER_COLOR); 

  // 토성
  saturn.orbit(1); 
  saturn.show(SATURN_SIZE, frameCount * speed * SATURN_SPEED, SATURN_COLOR); 

  // 고리
  pushMatrix();
    float saturnX = SATURN_DISTANCE * cos(frameCount * speed * SATURN_SPEED);
    float saturnY = SATURN_DISTANCE * sin(frameCount * speed * SATURN_SPEED);
    translate(saturnX, saturnY, 0); 
    rotateX(PI / 3); 
    rotateY(frameCount * speed * ringSpeed);
    noStroke();
    fill(ringColor); 
    beginShape(TRIANGLE_STRIP);
      for (float angle = 0; angle <= TWO_PI; angle += TWO_PI / 100) {
        float innerX = (SATURN_SIZE * 1.5) * cos(angle);
        float innerY = (SATURN_SIZE * 1.5) * sin(angle);
        float outerX = (SATURN_SIZE * 2) * cos(angle);
        float outerY = (SATURN_SIZE * 2) * sin(angle);
        vertex(innerX, innerY, 0); // 내부
        vertex(outerX, outerY, 0); // 외부
      }
    endShape(CLOSE);
  popMatrix();

  // 천왕성
  uranus.orbit(1); 
  uranus.show(URANUS_SIZE, frameCount * speed * URANUS_SPEED, URANUS_COLOR); 
}