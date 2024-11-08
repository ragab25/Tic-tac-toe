import 'dart:math';
import 'dart:io';
 List<String> board = List.filled(9, ' ');


void main() {
  while (true) {
    board.fillRange(0, 9, ' ');
    print("Hello ,Tic-Tac-Toe Game");
    print("Choose a mode:");
    print("1. Player X vs Player Y");
    print("2. Player X vs Computer (Easy)");
    print("3. Player X vs Computer (Hard)");
    int choice;
    do {
      choice = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
    } while (choice < 1 || choice > 3);

    bool vsComputer = (choice != 1);
    bool hardMode = (choice == 3);

    playGame(vsComputer, hardMode);

    print("Do you want to play again? (y/n)");
    String? again = stdin.readLineSync();
    if (again == null || again.toLowerCase() != 'y') break;
  }
             }


// Function to display the board
void printBoard() {
   stdout.write("\n");
  for (int i = 0; i < 9; i++) {
    // Display numbers for empty cells or the player's mark for occupied cells
    if (board[i] == ' ') {
      stdout.write(' ${i + 1} '); // Show position number
    } else {
      stdout.write(' ${board[i]} '); // Show 'X' or 'O'
    }
    if ((i + 1) % 3 == 0) {
      print(''); // Newline after each row
      if (i < 6) print('---+---+---'); // Row separator
    } else {
      stdout.write('|');
    }
    
  }
   stdout.write("\n");
}


// Function to check for a winner
bool checkWinner(String player) {
  const winningCombinations = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6]             // Diagonals
  ];
  return winningCombinations.any((combo) =>
      combo.every((index) => board[index] == player));
}

// Function to check if the board is full
bool isBoardFull() => board.every((cell) => cell != ' ');

// Player move function with validation

void playerMove(String player) {
  int move;
  while (true) {
    print('Player $player, enter your move (1-9): ');
    String? input = stdin.readLineSync();
    move = int.tryParse(input ?? '') ?? -1;

    // Check if the input is out of range or the spot is taken
    if (move < 1 || move > 9) {
      print("Invalid input! You must enter a number between 1 and 9.");
    } else if (board[move - 1] != ' ') {
      print("This spot is already taken! Choose a different spot.");
    } else {
      // Valid move, so place it on the board
      board[move - 1] = player;
      break; // Exit the loop
    }
  }
}


// Computer move (easy mode - random)
void computerMoveEasy(String player) {
  Random random = Random();
  int move;
  do {
    move = random.nextInt(9);
  } while (board[move] != ' ');
  board[move] = player;
}

// Minimax algorithm for hard mode
int minimax(String player, String opponent, bool isMaximizing) {
  if (checkWinner(player)) return 1;
  if (checkWinner(opponent)) return -1;
  if (isBoardFull()) return 0;

  if (isMaximizing) {
    int bestScore = -999;
    for (int i = 0; i < 9; i++) {
      if (board[i] == ' ') {
        board[i] = player;
        int score = minimax(player, opponent, false);
        board[i] = ' ';
        bestScore = max(score, bestScore);
      }
    }
    return bestScore;
  } else {
    int bestScore = 999;
    for (int i = 0; i < 9; i++) {
      if (board[i] == ' ') {
        board[i] = opponent;
        int score = minimax(player, opponent, true);
        board[i] = ' ';
        bestScore = min(score, bestScore);
      }
    }
    return bestScore;
  }
}

// Computer move (hard mode - using minimax)
void computerMoveHard(String player, String opponent) {
  int bestScore = -999;
  int bestMove = -1;
  for (int i = 0; i < 9; i++) {
    if (board[i] == ' ') {
      board[i] = player;
      int score = minimax(player, opponent, false);
      board[i] = ' ';
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }
  board[bestMove] = player;
}

// Game loop
void playGame(bool vsComputer, bool hardMode) {
  String currentPlayer = 'X';
  bool gameOver = false;

  while (!gameOver) {
    printBoard();
    
    if (currentPlayer == 'X' || !vsComputer) {
      playerMove(currentPlayer);
    } else {
      if (hardMode) {
        computerMoveHard('O', 'X');
      } else {
        computerMoveEasy('O');
      }
    }

    gameOver = checkWinner(currentPlayer) || isBoardFull();

    if (checkWinner(currentPlayer)) {
      printBoard();
      print('Player $currentPlayer wins!');
    } else if (isBoardFull()) {
      printBoard();
      print("It's a draw!");
    }

    currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
  }
}
