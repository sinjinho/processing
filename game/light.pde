class Light {
    float x, y;
    float size = 20; // Size of the light
    int lastHitTime = 0;
    
    Light (float startX, float startY) {
        x = startX;
        y = startY;
    }
    
    void display() {
        //손전등 접촉 시 색 밝아짐
        if (hitFlash(player)) {
            fill(255, 255, 0); 
        } else {
            fill(255, 255, 100, 80); 
        }
        noStroke();
        ellipse(x, y, size, size); 
    }

    boolean isCollision(Player player) {
        float d = dist(x, y, player.x, player.y);
        if (d < size / 2 + player.size / 2) {
            return true; // Collision detected
        }
        return false; // No collision
    }

    boolean hitFlash(Player player) {
        float d = dist(x, y, player.x, player.y); 
        float flashR = 150; //손전등 반지름름
        float lightAngle = atan2(y - player.y, x - player.x); // 빛과 플레이어 사이의 각도
        float flashAngle = atan2(mouseY - player.y, mouseX - player.x); // 손전등 중심 각도
        float angleDiff = abs(flashAngle - lightAngle); // 각도 차이 계산

        // 손전등 범위 안에 있는지 확인
        boolean inFlash = (d <= (flashR/2 + size/2) && angleDiff < PI / 6);

        if (inFlash) {
            lastHitTime = millis();
        }

        return inFlash;
    }

    //점수 인식 문제 해결을 위한 함수수
    boolean wasRecentlyHit() {
        // 100밀리초 안에 hitFlash가 참이었다면 true 반환
        return millis() - lastHitTime <= 100;
    }
}