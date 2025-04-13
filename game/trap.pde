class Trap {
    float x, y;
    float size = 20;

    Trap(float startX, float startY) {
        x = startX;
        y = startY;
    }
    
    //함정이 숨겨져 있을 때 함정그리는 함수(test용 + 직관용)
    void notDisplay() {
        // stroke(255); //test용
        noStroke();
        noFill();
        ellipse(x, y, size, size); 
    }

    // 함정이 발견되었을 때 함정 그리는 함수
    void display() {
        stroke(255);
        noStroke();
        fill(255, 0, 0);
        ellipse(x, y, size, size);
    }

    //함정이 손정등 충돌 감지지
    boolean hitFlash(Player player) {
        float d = dist(x, y, player.x, player.y);
        float flashR = 150;
        float flashAngle = atan2(mouseY - player.y, mouseX - player.x);

        float trapSize = size / 2;
        float trapAngle = atan2(y - player.y, x - player.x);
        float angleDiff = abs(flashAngle - trapAngle);

        return d < (flashR/2 + trapSize) && angleDiff < PI / 6; // Check if the trap is within the flash area
    }

    //함정과 플레이어 충돌 감지
    boolean isCollision(Player player) {
        float d = dist(x, y, player.x, player.y);
        if (d < size / 2 + player.size / 2) {
            return true; // Collision detected
        }
        return false; // No collision
    }
}