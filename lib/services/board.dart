import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/services/sound.dart';

final soundService = locator<SoundService>();

enum BoardState { Done, Play }
enum GameMode { Solo, Multi }

class BoardService {
  late BehaviorSubject<List<List<String>>> _board$;
  BehaviorSubject<List<List<String>>> get board$ => _board$;

  late BehaviorSubject<String> _player$;
  BehaviorSubject<String> get player$ => _player$;

  late BehaviorSubject<MapEntry<BoardState, String>> _boardState$;
  BehaviorSubject<MapEntry<BoardState, String>> get boardState$ => _boardState$;

  late BehaviorSubject<GameMode> _gameMode$;
  BehaviorSubject<GameMode> get gameMode$ => _gameMode$;

  late BehaviorSubject<MapEntry<int, int>> _score$;
  BehaviorSubject<MapEntry<int, int>> get score$ => _score$;

  late BehaviorSubject<List<List<int>>> _fadingMoves$;
  BehaviorSubject<List<List<int>>> get fadingMoves$ => _fadingMoves$;

  late String _start;
  List<List<int>> _xMoves = [];
  List<List<int>> _oMoves = [];
  final int maxMoves = 3;

  BoardService() {
    _initStreams();
  }

  void _updateFadingMoves() {
    List<List<int>> fading = [];
    if (_xMoves.length == maxMoves) fading.add(_xMoves.first);
    if (_oMoves.length == maxMoves) fading.add(_oMoves.first);
    _fadingMoves$.add(fading);
  }

  void newMove(int i, int j) {
    if (_boardState$.value.key == BoardState.Done) return;
    
    String player = _player$.value;
    List<List<String>> currentBoard = List.from(_board$.value.map((row) => List<String>.from(row)));

    if (currentBoard[i][j] != " ") return;

    // --- منطق الحركات المتلاشية ---
    List<List<int>> playerMoves = (player == 'X') ? _xMoves : _oMoves;

    if (playerMoves.length >= maxMoves) {
      List<int> oldestMove = playerMoves.removeAt(0); 
      currentBoard[oldestMove[0]][oldestMove[1]] = " "; 
    }

    playerMoves.add([i, j]);
    currentBoard[i][j] = player;
    _updateFadingMoves();
    // ----------------------------

    _playMoveSound(player);
    _board$.add(currentBoard);

    if (_checkStatus(i, j, player)) return;

    switchPlayer(player);

    if (_gameMode$.value == GameMode.Solo && _boardState$.value.key == BoardState.Play) {
      botMove();
    }
  }

  bool _checkStatus(int i, int j, String player) {
    if (_checkWinner(i, j)) {
      _updateScore(player);
      _boardState$.add(MapEntry(BoardState.Done, player));
      return true;
    } else if (isBoardFull()) {
      _boardState$.add(MapEntry(BoardState.Done, ""));
      return true;
    }
    return false;
  }

  Future<void> botMove() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_boardState$.value.key == BoardState.Done) return;

    String botPlayer = _player$.value;
    List<List<String>> currentBoard = List.from(_board$.value.map((row) => List<String>.from(row)));
    
    List<List<int>> availableMoves = [];
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (currentBoard[i][j] == " ") availableMoves.add([i, j]);
      }
    }

    if (availableMoves.isNotEmpty) {
      final rnd = math.Random();
      final move = availableMoves[rnd.nextInt(availableMoves.length)];
      int row = move[0];
      int col = move[1];

      if (_oMoves.length >= maxMoves) {
        List<int> oldest = _oMoves.removeAt(0);
        currentBoard[oldest[0]][oldest[1]] = " ";
      }
      _oMoves.add([row, col]);
      _updateFadingMoves();

      currentBoard[row][col] = botPlayer;
      _playMoveSound(botPlayer);
      _board$.add(currentBoard);

      if (!_checkStatus(row, col, botPlayer)) {
        switchPlayer(botPlayer);
      }
    }
  }

  void _updateScore(String winner) {
    var currentScore = _score$.value;
    if (winner == "O") {
      _score$.add(MapEntry(currentScore.key, currentScore.value + 1));
    } else if (winner == "X") {
      _score$.add(MapEntry(currentScore.key + 1, currentScore.value));
    }
  }

  void _playMoveSound(String player) {
    soundService.playSound(player.toLowerCase());
  }

  bool _checkWinner(int x, int y) {
    var currentBoard = _board$.value;
    var player = currentBoard[x][y];
    int n = 3;

    // x
    if (currentBoard[x].every((cell) => cell == player)) return true;
    // y
    if (currentBoard.every((row) => row[y] == player)) return true;
    // z
    if (x == y && List.generate(n, (i) => currentBoard[i][i]).every((cell) => cell == player)) return true;
    if (x + y == n - 1 && List.generate(n, (i) => currentBoard[i][n - 1 - i]).every((cell) => cell == player)) return true;

    return false;
  }

  void setStart(String e) {
    _start = e;
    _player$.add(e);
  }

  void switchPlayer(String player) {
    _player$.add(player == 'X' ? 'O' : 'X');
  }

  bool isBoardFull() {
    return !_board$.value.any((row) => row.any((cell) => cell == " "));
  }

  void resetBoard() {
    _xMoves.clear();
    _oMoves.clear();
    _board$.add(List.generate(3, (_) => List.generate(3, (_) => " ")));
    _updateFadingMoves();
    _player$.add(_start);
    _boardState$.add(MapEntry(BoardState.Play, ""));
    
    if (_gameMode$.value == GameMode.Solo && _start == "O") {
      botMove();
    }
  }

  void newGame() {
    _score$.add(MapEntry(0, 0));
    resetBoard();
  }

  void _initStreams() {
    _board$ = BehaviorSubject<List<List<String>>>.seeded(List.generate(3, (_) => List.generate(3, (_) => " ")));
    _player$ = BehaviorSubject<String>.seeded("X");
    _boardState$ = BehaviorSubject<MapEntry<BoardState, String>>.seeded(MapEntry(BoardState.Play, ""));
    _gameMode$ = BehaviorSubject<GameMode>.seeded(GameMode.Solo);
    _score$ = BehaviorSubject<MapEntry<int, int>>.seeded(MapEntry(0, 0));
    _fadingMoves$ = BehaviorSubject<List<List<int>>>.seeded([]);
    _start = 'X';
  }


}