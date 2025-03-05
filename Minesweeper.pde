private static final int NUM_MINES = 40;
private MSButton[][] buttons; 
private ArrayList<MSButton> mines; 
void setup() {
    size(400, 400);
    textAlign(CENTER, CENTER);
    Interactive.make(this);
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList<MSButton>();
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            buttons[row][col] = new MSButton(row, col);
        }
    }
    setMines();
}
public void draw() {
    background(0);
    if (isWon()) {
        displayWinningMessage();
    }
}
public void setMines() {
    while (mines.size() < NUM_MINES) {
        int row = (int) (Math.random() * NUM_ROWS);
        int col = (int) (Math.random() * NUM_COLS);
        MSButton button = buttons[row][col];
        if (!mines.contains(button)) {
            mines.add(button);
        }
    }
}
public boolean isValid(int r, int c) {
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col) {
    int numMines = 0;
    for (int r = -1; r <= 1; r++) {
        for (int c = -1; c <= 1; c++) {
            if (r == 0 && c == 0) continue;
            if (isValid(row + r, col + c) && mines.contains(buttons[row + r][col + c])) {
                numMines++;
            }
        }
    }
    return numMines;
}
public boolean isWon() {
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            MSButton button = buttons[row][col];
            if (!mines.contains(button) && !button.clicked) {
                return false;
            }
        }
    }
    return true;
}
public void displayWinningMessage() {
    for (MSButton mine : mines) {
        mine.setLabel("✔"); 
    }
}
public void displayLosingMessage() {
    for (MSButton mine : mines) {
        mine.setLabel("💣"); 
    }
}
public class MSButton {
    private int myRow, myCol;
    private float x, y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    public MSButton(int row, int col) {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol * width;
        y = myRow * height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this);
    }
    public void mousePressed() {
        if (mouseButton == RIGHT) {
            flagged = !flagged;
            return;
        }
        if (flagged || clicked) return;
        clicked = true;
        if (mines.contains(this)) {
            displayLosingMessage();
        } else {
            int numMines = countMines(myRow, myCol);
            if (numMines > 0) {
                setLabel(numMines);
            } else {
                for (int r = -1; r <= 1; r++) {
                    for (int c = -1; c <= 1; c++) {
                        if (!(r == 0 && c == 0) && isValid(myRow + r, myCol + c)) {
                            buttons[myRow + r][myCol + c].mousePressed();
                        }
                    }
                }
            }
        }
    }
    public void draw() {    
        if (flagged)
            fill(0);
        else if (clicked && mines.contains(this))
            fill(255, 0, 0);
        else if (clicked)
            fill(200);
        else
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(myLabel, x + width / 2, y + height / 2);
    }
    public void setLabel(String newLabel) {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel) {
        myLabel = "" + newLabel;
    }
}
