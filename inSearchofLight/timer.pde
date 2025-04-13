class Timer {
    int savedTime;
    int totalTime;

    Timer(int tempTotalTime) {
        totalTime = tempTotalTime;
    }

    void setTime(int time) {
        totalTime = time;
    }

    void start() {
        savedTime = millis();
    }

    boolean levelUp() {
        int passedTime = millis() - savedTime;
        if (passedTime > totalTime) {
            return true;
        } else {
            return false;
        }
    }
}