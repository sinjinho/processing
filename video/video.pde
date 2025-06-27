// 움직이면 모자이크 효과

import processing.video.*;

Capture cam;
PImage prevFrame, maskImg, outputImg;

// 움직임 민감도 & 기본 모자이크 크기
int thresh = 20;
int baseMosaicSize = 10;

// persistence: 모자이크를 유지할 프레임 수
int persistFrames = 5;

int blocksX, blocksY;
int[][] blockTimer;

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height);
  cam.start();

  prevFrame = null;
  maskImg = createImage(width, height, ALPHA);
  outputImg = createImage(width, height, RGB);

  // 블록 개수 및 타이머 초기화
  blocksX = ceil(width  / (float)baseMosaicSize);
  blocksY = ceil(height / (float)baseMosaicSize);
  blockTimer = new int[blocksX][blocksY];
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  if (cam.pixels == null) return;
  cam.loadPixels();

  if (prevFrame == null) {
    prevFrame = cam.get();
  }

  maskImg.loadPixels();
  for (int i = 0; i < cam.pixels.length; i++) {
    float d = (
      abs(red(cam.pixels[i]) - red(prevFrame.pixels[i])) +
      abs(green(cam.pixels[i]) - green(prevFrame.pixels[i])) +
      abs(blue(cam.pixels[i]) - blue(prevFrame.pixels[i]))
    ) / 3;
    maskImg.pixels[i] = (d > thresh) ? color(255) : color(0);
  }
  maskImg.updatePixels();

  for (int by = 0; by < blocksY; by++) {
    for (int bx = 0; bx < blocksX; bx++) {
      boolean hasMovement = false;
      for (int yy = 0; yy < baseMosaicSize && !hasMovement; yy++) {
        for (int xx = 0; xx < baseMosaicSize; xx++) {
          int x = bx*baseMosaicSize + xx;
          int y = by*baseMosaicSize + yy;
          if (x < width && y < height) {
            if (maskImg.pixels[x + y*width] == color(255)) {
              hasMovement = true;
              break;
            }
          }
        }
      }
      if (hasMovement) {
        blockTimer[bx][by] = persistFrames;
      } else if (blockTimer[bx][by] > 0) {
        blockTimer[bx][by]--;
      }
    }
  }

  outputImg.loadPixels();
  for (int by = 0; by < blocksY; by++) {
    for (int bx = 0; bx < blocksX; bx++) {
      int timer = blockTimer[bx][by];
      int x0 = bx * baseMosaicSize;
      int y0 = by * baseMosaicSize;
      if (timer > 0) {
        int sumR=0, sumG=0, sumB=0, cnt=0;
        for (int yy = 0; yy < baseMosaicSize; yy++) {
          for (int xx = 0; xx < baseMosaicSize; xx++) {
            int x = x0 + xx, y = y0 + yy;
            if (x < width && y < height) {
              color c = cam.pixels[x + y*width];
              sumR += (int)red(c);
              sumG += (int)green(c);
              sumB += (int)blue(c);
              cnt++;
            }
          }
        }
        color avg = color(sumR/cnt, sumG/cnt, sumB/cnt);
        for (int yy = 0; yy < baseMosaicSize; yy++) {
          for (int xx = 0; xx < baseMosaicSize; xx++) {
            int x = x0 + xx, y = y0 + yy;
            if (x < width && y < height) {
              outputImg.pixels[x + y*width] = avg;
            }
          }
        }
      } else {
        for (int yy = 0; yy < baseMosaicSize; yy++) {
          for (int xx = 0; xx < baseMosaicSize; xx++) {
            int x = x0 + xx, y = y0 + yy;
            if (x < width && y < height) {
              outputImg.pixels[x + y*width] = cam.pixels[x + y*width];
            }
          }
        }
      }
    }
  }
  outputImg.updatePixels();

  image(outputImg, 0, 0);

  prevFrame = cam.get();
}
