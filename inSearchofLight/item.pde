class Item {
    float x, y;
    float inventorySize = 60;
    boolean trapDetectActive = false;
    int trapDetectStartTime = -1;

    Item (float startX, float startY) {
        x = startX - 50;
        y = startY - 50;
    }

    //인벤토리 그리기
    void inventoryDisplay() { 
        fill(150); 
        noStroke();
        ellipse(x, y, inventorySize, inventorySize);
    }

    //아이템 종류 결정 함수
    int decisionItem() { 
        float decision = random(4);
        if (decision < 1) return 1; 
        else if (decision < 2) return 2; 
        else if (decision < 3) return 3; 
        else return 4; 
    }

    void useItem(int itemType) {
        switch (itemType) {
            case 1: //얼음
                ice();
                break;
            case 2: //함정 탐지기
                trapDetect();
                break;
            case 3: //힐
                heal();
                break;
            case 4: //신발
                shoes(player);
                break;
        }
    }

    void ice() {
        // 얼음 효과 구현
        for (int i = 0; i < monsterCount; i++) {
            monsters[i].speed = 0; // 몬스터 멈춤
        }
    }

    void iceDisplay() {
        float iceSize = 30;

        fill(180, 220, 255, 150);
        stroke(100, 150, 255);
        x -= 5;
        beginShape();
            vertex(x - 10, y - 10);
            vertex(x + 10, y - 10);
            vertex(x + 10, y + 10);
            vertex(x - 10, y + 10);
            vertex(x - 10, y - 10);

            vertex(x, y - 15);
            vertex(x + 20, y - 15);
            vertex(x + 10, y - 10);

            vertex(x + 20, y - 15);
            vertex(x + 20, y + 5);
            vertex(x + 10, y + 10);
        endShape();
        x += 5;
    }

    void trapDetect() {
        // 함정 탐지기 효과 구현
        trapDetectActive = true;
        trapDetectStartTime = millis();
    }

    void updateTrapDetect() {
        if (trapDetectActive) {
            // 모든 함정을 표시
            for (int i = 0; i < trapCount; i++) {
                traps[i].display();
            }
        }
    }

    void deactivateTrapDetect() {
        // 함정 탐지기 효과 비활성화
        trapDetectActive = false;
        trapDetectStartTime = -1;
    }

    void trapDetectDisplay() {
        float trapSize = 30;
        rectMode(CENTER);
        fill(80);
        stroke(0);
        strokeWeight(1);

        rect(x, y, 30, 50, 8);
        fill(30, 120, 180);
        noStroke();
        rect(x, y-12, 20, 10, 2);
        fill(255, 80, 80);
        ellipse(x, y + 15, 6, 6);
    }

    void heal(){
        life = lifeManager.increase();
    }

    void healDisplay() {
        noStroke();
        fill(0, 255, 0);
        rectMode(CENTER);

        rect(x, y, 40, 10);
        rect(x, y, 10, 40);
    }

    void shoes(Player player) {
        player.speed += 0.5;
    }

    void shoesDisplay(PImage img) {
        imageMode(CENTER);
        image(img, x, y, 40, 40);
    }
}