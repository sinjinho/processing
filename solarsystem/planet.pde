class Planet {
  int diam = 200; // diameter
  float x, y, z;
  float th = 0;

  Planet(int diam_) {
    this(diam_, 0.0, 0.0, 0.0);
  }

  Planet(int diam_, float x_, float y_, float z_) {
    diam = diam_;
    x = x_;
    y = y_;
    z = z_;
  }

  void center(float size, color planetColor) {
    pushMatrix();
      translate(x, y, z);
      fill(planetColor);
      sphere(size);
    popMatrix();
  }

  void orbit(int weight) {
    float cx, cy;
    for (th = 0; th < TWO_PI; th += TWO_PI / 720) {
      cx = diam * cos(th);
      cy = diam * sin(th);
      pushMatrix();
        translate(x, y, z);
        pushStyle();
          strokeWeight(weight);
          stroke(220); // 궤도 흰색
          point(cx, cy, 0);
        popStyle();
      popMatrix();
    }
  }

  void show(float size, float angle, color planetColor) {
    float tx = diam * cos(angle);
    float ty = diam * sin(angle);
    pushMatrix();
      translate(tx + x, ty + y, z);
      pushStyle();
        noStroke();
        fill(planetColor); // 행성의 색상 설정
        sphere(size);
      popStyle();
    popMatrix();
  }
}