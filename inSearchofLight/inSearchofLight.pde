Player player;
Life lifeManager;
Timer timer;
Item item;
Monster[] monsters;
Trap[] traps;
Light[] lights;

boolean gameOver = false;
boolean gameStart = false;

float monsterSpeedUp = 0.5;
int monsterCount = 3;
int trapCount = 3;
int lightCount = 2;

int itemCount = 0;
int itemType = 0; //0은 없음, 1은 얼음, 2는 함정 탐지기, 3은 힐, 4는 신발
boolean itemHad = false;

int life = 3;
int score = 0;
int level = 1;

PFont f;
PImage img;

void setup() {
  size(800, 600);
  player = new Player(width/2, height/2);
  
  lifeManager = new Life(life);

  //levelup구현을 위한 timer(10초마다 levelup)
  timer = new Timer(10000);
  timer.start();

  item = new Item(width, height);
  img = loadImage("shoes.png");

  monsters = new Monster[monsterCount];
  for (int i = 0; i < monsterCount; i++) {
    monsters[i] = new Monster(random(width), random(height));
  }

  traps = new Trap[trapCount];
  for (int i = 0; i < trapCount; i++) {
    traps[i] = new Trap(random(width), random(height));
  }

  lights = new Light[lightCount];
  for (int i = 0; i < lightCount; i++) {
    lights[i] = new Light(random(width), random(height));
  }

  f = createFont("Arial", 12, true);
}

void draw() {
  background(30);
  if (!gameOver && gameStart) {
    //player
    player.moveUpdate();
    player.display();

    lifeManager.display();

    //item 보여주기
    item.inventoryDisplay();
    if (itemType == 1) {
      item.iceDisplay();
    } else if (itemType == 2) {
      item.trapDetectDisplay();
    } else if (itemType == 3) {
      item.healDisplay();
    } else if (itemType == 4) {
      item.shoesDisplay(img);
    }

    //함정 탐지기 효과 발동
    if (item.trapDetectActive) {
      item.updateTrapDetect();
    }


    //monster
    for (int i = 0; i < monsterCount; i++) {
      monsters[i].display(player);
      monsters[i].playerAttack(player);
      if (monsters[i].isCollision(player)) {
        monsters[i].x = random(width);
        monsters[i].y = random(height);
        life = lifeManager.decrease();
      }
    }
    //trap
    for (int i = 0; i < trapCount; i++) {
      traps[i].notDisplay();
      if (traps[i].isCollision(player)) {
        traps[i].x = random(width);
        traps[i].y = random(height);
        life = lifeManager.decrease();
      } 
      if (traps[i].hitFlash(player)) {
        traps[i].display();
      }
    }

    //light + item 종류 결정
    for (int i = 0; i < lightCount; i++) {
      lights[i].display();
      if (lights[i].isCollision(player)) {
        lights[i].x = random(width);
        lights[i].y = random(height);

        // 점수 계산
        if (lights[i].wasRecentlyHit()) {
          score += 10;
        } else {
          score += 5;
        }

        //아이템을 얻기 위한 빛의 개수
        itemCount++;
        //light를 3개 모을 때마다 아이템 획득
        if (itemCount >= 3) {
          itemCount = 0;
          itemType = item.decisionItem();
          itemHad = true;
        }
      }
    }

    //점수와 남은 생명
    textFont(f, 24);
    textAlign(LEFT);
    fill(255);
    text("Score: " + score, 10, 30);
    text("Level: " + level, 10, 60);
    // text("m_speed: " + monsters[1].speed, 10, 120); //몬스터 속도 테스트용

    if (timer.levelUp()) {
      level += 1;
      timer.start();

      //level오를 때 함정탐지기 효과 종료료
      if (item.trapDetectActive) {
        item.deactivateTrapDetect();
      }
      // level이 3이나 5일때 몬스터 추가
      if (level == 2 || level == 4) {
        monsterCount++;
        monsters = new Monster[monsterCount];
      }
      // level이 3이나 5일때 함정 추가
      if (level == 3 || level == 5) {
        trapCount++;
        Trap[] newTraps = new Trap[trapCount];
        //기존 함정 유지
        for (int i = 0; i < trapCount-1; i++) {
            newTraps[i] = traps[i];
        }

        //새로운 함정
        newTraps[trapCount-1] = new Trap(random(width), random(height));
        traps = newTraps;
      }

      // level 오를 때 마다 몬스터 위치 초기화화
      for (int i = 0; i < monsterCount; i++) {
          monsters[i] = new Monster(random(width), random(height));
      }

      //level 6이후로는 몬스터 스피드만 증가.
      if (level >= 6) {
        for (int i = 0; i < monsterCount; i++) {
          monsters[i].speed += monsterSpeedUp; 
        }
        monsterSpeedUp += 0.1;
      }
    }
    
    //생명 없으면 게임 오버버
    if(life <= 0) {
      gameOver = true;
    }
  } else if (gameOver){
    // 게임 오버시 출력
    textFont(f, 48);
    textAlign(CENTER);
    fill(255);
    text("GAME OVER", width/2, height/2);
  } else if(!gameStart) {
    // 시작 화면
    textFont(f, 48);
    textAlign(CENTER);
    fill(255);
    text("in Search of Light", width / 2, height / 2 - 50);
    textSize(24);
    text("Press 'Q' to Start.", width / 2, height / 2 + 20);
  }
}

void keyPressed() {
  // 플레이어 이동 구현을 위한 것들들
  if (key == 'w' || key == 'W') {
    player.up = true;
  }
  if (key == 's' || key == 'S') {
    player.down = true;
  }
  if (key == 'a' || key == 'A') {
    player.left = true;
  }
  if (key == 'd' || key == 'D') {
    player.right = true;
  }
  
  if(key == 'q' || key == 'Q') {
    gameStart = true;
  }

  //아이템 사용키 == e
  if ((key == 'E' || key == 'e') && itemHad == true) {
    item.useItem(itemType);
    itemHad = false;
    itemType = 0;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    player.up = false;
  }
  if (key == 's' || key == 'S') {
    player.down = false;
  }
  if (key == 'a' || key == 'A') {
    player.left = false;
  }
  if (key == 'd' || key == 'D') {
    player.right = false;
  }
}
