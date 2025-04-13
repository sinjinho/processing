class Life {
    int count; // 현재 생명 개수

    Life(int initialCount) {
        count = initialCount;
    }

    int increase() {
        count++; // 생명 증가
        return count;
    }

    int decrease() {
        if (count > 0) {
            count--; // 생명 감소
        }
        return count;
    }

    void display() {
        for (int i = 0; i < count; i++) {
            drawHeart(width - 40 * (i + 1), 30, 30);
        }
    }

    void drawHeart(float x, float y, float size) {
        fill(255, 0, 0); 
        noStroke();
        beginShape();
            vertex(x, y);
            bezierVertex(x - size / 2, y - size / 2, x - size, y + size / 3, x, y + size);
            bezierVertex(x + size, y + size / 3, x + size / 2, y - size / 2, x, y);
        endShape(CLOSE);
    }   
}