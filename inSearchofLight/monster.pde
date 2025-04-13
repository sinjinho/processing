class Monster {
    float x, y; // Position of the monster
    float speed = 1.0; // Speed of the monster
    float size = 30; // Size of the monster

    Monster(float startX, float startY) {
        x = startX;
        y = startY;
    }

    void playerAttack(Player player) {
        // 손전등에 충돌 시 멈춤춤
        if (hitFlash(player)) {
            return;
        }

        float d = dist(x, y, player.x, player.y);
        
        // 플레이어 감지 범위 : 200
        if (d < 200) {
            float angle = atan2(player.y - y, player.x - x);

            x += cos(angle) * speed; 
            y += sin(angle) * speed; 
        }
    }

    void display(Player player) {
        float d = dist(x, y, player.x, player.y);

        noStroke();
        //플레이어 감지에 따라 색 변화
        if (d < 200 ) {
            fill(255, 0, 0); // Red color when attacking the player
        } else {
            fill(150); // gray color when not attacking
        }

        // 손전등 충돌에 따라 색 변화화
        if (hitFlash(player)) {
            fill(255, 255, 0); 
        }
        ellipse(x, y, size, size);
    }

    //손전등 충돌 감지
    boolean hitFlash(Player player) {
        float d = dist(x, y, player.x, player.y);
        float flashR = 150;
        float flashAngle = atan2(mouseY - player.y, mouseX - player.x);

        float monsterSize = size / 2;
        float monsterAngle = atan2(y - player.y, x - player.x);
        float angleDiff = abs(flashAngle - monsterAngle);

        return d < (flashR/2 + monsterSize) && angleDiff < PI / 6; 
    }

    boolean isCollision(Player player) {
        float d = dist(x, y, player.x, player.y);
        if (d < size / 2 + player.size / 2) {
            return true; 
        }
        return false; 
    }
}