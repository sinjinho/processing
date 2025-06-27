Table table;
RegionBubble[] regions;
int totalPop = 0;
int blueCount;
PVector[] bluePoints;
PFont font;

int[] regionStartIdx; // 각 지역별 파란 점 시작 인덱스
int[] regionDotCount; // 각 지역별 파란 점 개수
float[] regionStartAngle;  // 각 지역 시작 각
float[] regionEndAngle;    // 각 지역 끝 각

void setup() {
  size(900, 900);
  font = createFont("Dialog", 32);
  textFont(font);

  table = loadTable("region_population.csv", "header"); // orginal_data를 파이썬으로 가공한 region_popilation 데이터 이용 - 코드 남겨놀 걸...
  regions = new RegionBubble[table.getRowCount()];
  totalPop = 0;

  // 임시
  regionStartIdx = new int[table.getRowCount()];
  regionDotCount = new int[table.getRowCount()];

  // 데이터 로드
  int curIdx = 0;
  for (int i = 0; i < table.getRowCount(); i++) {
    String name = table.getString(i, "지역");
    int pop = table.getInt(i, "인구");
    totalPop += pop;
    regions[i] = new RegionBubble(name, pop, i, table.getRowCount());

    // 임시
    regionStartIdx[i] = curIdx;
    regionDotCount[i] = pop / 100000;
    curIdx += regionDotCount[i];
  }
  blueCount = totalPop / 100000;

  // 각도 지정 - 임시
  regionStartAngle = new float[table.getRowCount()];
  regionEndAngle = new float[table.getRowCount()];   

  float currentAngle = -HALF_PI; // 12시 방향부터 시작
  for (int i = 0; i < regions.length; i++) {
    regionStartAngle[i] = currentAngle;
    int dots = regionDotCount[i];
    float sweep = TWO_PI * dots / blueCount;
    regionEndAngle[i] = currentAngle + sweep;
    currentAngle += sweep;
  }

  float minR = 99999;
  float maxR = -99999;
  for (RegionBubble rb : regions) {
    if (rb.r < minR) minR = rb.r;
    if (rb.r > maxR) maxR = rb.r;
  }

  float minDist = 250 + minR/2 + 24;   // 파란 점 분포 반지름 + 작은 회색원 반지름 + 여유
  float maxDist = min(width, height)/2 - maxR/2 - 12;  // 화면 밖으로 안나가게
  for (int i = 0; i < table.getRowCount(); i++) {
    float midA = (regionStartAngle[i] + regionEndAngle[i]) / 2.0;
    // r이 minR이면 minDist, r이 maxR이면 maxDist
    float dist = map(regions[i].r, minR, maxR, minDist, maxDist);
    regions[i].setAngleAndPos(midA, dist);
  }

  relaxGrayBubbles(100);  

  makeBluePoints();
  relaxPoints(14, 10);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(255);

  // 마우스 올린 지역 찾기
  int hoverIdx = -1;
  for (int i = 0; i < regions.length; i++) {
    if (regions[i].isMouseOver(mouseX, mouseY)) {
      hoverIdx = i;
    }
  }

  // 중앙 파란 점(전체 인구)
  for (int i = 0; i < bluePoints.length; i++) {
    if (hoverIdx == -1) {
      fill(95, 110, 255, 210);
    } else {
      // 해당 지역의 점만 강조
      int start = regionStartIdx[hoverIdx];
      int count = regionDotCount[hoverIdx];
      if (i >= start && i < start + count) {
        fill(95, 110, 255, 230); // 밝게
      } else {
        fill(95, 110, 255, 40);  // 흐리게
      }
    }
    noStroke();
    ellipse(bluePoints[i].x, bluePoints[i].y, 11, 11);
  }

  // 회색 원(지역)
  for (int i = 0; i < regions.length; i++) {
    regions[i].draw(i == hoverIdx);
  }

  // 마우스 오버시 중앙에 정보 표시
  if (hoverIdx != -1) {
    RegionBubble r = regions[hoverIdx];
    fill(50, 90, 230);
    textSize(44);
    text(r.name, width/2, height/2 - 24);
    textSize(44);
    text(nf(r.population, 0, 0) + "명", width/2, height/2 + 24);
  }
}



// 파란 점 중앙에 원형 격자로 뿌리기 (단순화)
void makeBluePoints() {
  bluePoints = new PVector[blueCount];
  float cx = width / 2;
  float cy = height / 2;
  float Rmax = 250;
  int idx = 0;
  for (int region = 0; region < regions.length; region++) {
    int dotN = regionDotCount[region];
    if (dotN <= 0) continue;
    float startA = regionStartAngle[region];
    float endA = regionEndAngle[region];
    for (int i = 0; i < dotN; i++) {
      // 각 지역의 부채꼴 각도 내에서만 무작위
      float angle = lerp(startA, endA, random(0.12, 0.88)); // 무작위 분포(가운데로 치우치게)
      float r = Rmax * sqrt(random(1));
      float x = cx + r * cos(angle);
      float y = cy + r * sin(angle);
      bluePoints[idx++] = new PVector(x, y);
    }
  }

  while (idx < blueCount) {
    bluePoints[idx] = new PVector(cx, cy); idx++;
  }
}

void relaxPoints(float minDist, int iter) {
  for (int k = 0; k < iter; k++) {
    for (int i = 0; i < blueCount; i++) {
      for (int j = i+1; j < blueCount; j++) {
        float d = dist(bluePoints[i].x, bluePoints[i].y, bluePoints[j].x, bluePoints[j].y);
        if (d < minDist && d > 0.01) {
          float dx = bluePoints[i].x - bluePoints[j].x;
          float dy = bluePoints[i].y - bluePoints[j].y;
          float dd = (minDist-d)/2.0;
          dx /= d;
          dy /= d;
          bluePoints[i].x += dx * dd;
          bluePoints[i].y += dy * dd;
          bluePoints[j].x -= dx * dd;
          bluePoints[j].y -= dy * dd;
        }
      }
    }
  }
}

void relaxGrayBubbles(int iter) {
  for (int k = 0; k < iter; k++) {
    for (int i = 0; i < regions.length; i++) {
      for (int j = i+1; j < regions.length; j++) {
        float dx = regions[i].x - regions[j].x;
        float dy = regions[i].y - regions[j].y;
        float dist0 = sqrt(dx*dx + dy*dy);
        float minDist = regions[i].r/2 + regions[j].r/2 + 8; // 여유값(8) 조정 가능
        if (dist0 < minDist && dist0 > 0.01) {
          // 겹쳤으니 서로 밀어냄
          float dd = (minDist - dist0) / 2.0;
          dx /= dist0;
          dy /= dist0;
          regions[i].x += dx * dd;
          regions[i].y += dy * dd;
          regions[j].x -= dx * dd;
          regions[j].y -= dy * dd;
        }
      }
    }
  }
}

class RegionBubble {
  String name;
  int population;
  float angle;
  float x, y;
  float r; // radius


  RegionBubble(String name, int population, int idx, int total) {
    this.name = name;
    this.population = population;
    // 원 크기: 거의 비슷하게 맞추기 (minR~maxR)
    float minR = 60;
    float maxR = 128;
    float minPop = 300000;
    float maxPop = 14000000;
    r = map(population, minPop, maxPop, minR, maxR);
  }

  // 임시
  void setAngleAndPos(float angle, float dist) {
    this.angle = angle;
    float cx = width/2;
    float cy = height/2;
    x = cx + cos(angle) * dist;
    y = cy + sin(angle) * dist;
  }

  void draw(boolean highlight) {
    if (highlight) {
      stroke(255, 160, 25);
      strokeWeight(5);
      fill(95, 110, 255, 230);
    } else {
      stroke(180);
      strokeWeight(1);
      fill(200, 200, 200, 230);
    }
    ellipse(x, y, r, r);

    // 이름
    fill(30);
    noStroke();

    // 글자 줄 나누기
    if (name.length() > 4) {
    String line1, line2;
    if (name.length() == 5) {
      line1 = name.substring(0, 2);
      line2 = name.substring(2, 5);
    } else if (name.length() == 7) {
      line1 = name.substring(0, 4);
      line2 = name.substring(4, 7);
    } else {
      int mid = name.length() / 2;
      line1 = name.substring(0, mid);
      line2 = name.substring(mid);
    }

    float fitSize1 = getFitTextSize(line1, r);
    float fitSize2 = getFitTextSize(line2, r);
    float fitSize = min(fitSize1, fitSize2);

    textSize(fitSize);
    text(line1, x, y - fitSize * 0.5);
    text(line2, x, y + fitSize * 0.5);
  } else {
    float fitSize = getFitTextSize(name, r);
    textSize(fitSize);
    text(name, x, y);
  }
  }

  boolean isMouseOver(float mx, float my) {
    return dist(mx, my, x, y) < r/2;
  }

  // 글자 크기 조정
  float getFitTextSize(String label, float targetDiameter) {
    float ts = targetDiameter * 0.45; // 일단 반지름 크기의 절반 정도로 시작
    textSize(ts);
    // 여유 있게 85% 정도만 활용(글자와 원 사이 공간)
    while ((textWidth(label) > targetDiameter * 0.85) && ts > 5) {
      ts -= 1;
      textSize(ts);
    }
    return ts;
  }
}
