import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/question.dart';
import 'question_controller.dart';

class GameController extends ChangeNotifier {
  GameState _gameState = GameState();
  final QuestionController _questionController = QuestionController();
  
  GameState get gameState => _gameState;
  QuestionController get questionController => _questionController;
  
  bool get isGameActive => _gameState.status == GameStatus.playing;
  bool get isGameOver => _gameState.status == GameStatus.gameOver;
  Question? get currentQuestion => _questionController.currentQuestion;
  
  void startGame({int questionCount = 15}) {
    _questionController.loadQuestions(count: questionCount);
    _gameState = GameState(
      status: GameStatus.playing,
      score: 0,
      currentQuestionIndex: 0,
      carLane: CarLane.left,
      isAnswering: false,
      totalQuestions: questionCount,
      correctAnswers: 0,
      wrongAnswers: 0,
      startTime: DateTime.now(),
    );
    notifyListeners();
  }
  
  void moveCarToLane(CarLane lane) {
    if (_gameState.carLane != lane && !_gameState.isAnswering && isGameActive) {
      _gameState = _gameState.copyWith(carLane: lane);
      notifyListeners();
    }
  }
  
  void answerQuestion(bool isLeftLane) {
    if (!isGameActive || _gameState.isAnswering || currentQuestion == null) {
      return;
    }
    
    _gameState = _gameState.copyWith(isAnswering: true);
    notifyListeners();
    
    final question = currentQuestion!;
    final isCorrect = (isLeftLane && question.isLeftCorrect) || 
                     (!isLeftLane && !question.isLeftCorrect);
    
    int newScore = _gameState.score;
    int newCorrectAnswers = _gameState.correctAnswers;
    int newWrongAnswers = _gameState.wrongAnswers;
    
    if (isCorrect) {
      newScore += 10;
      newCorrectAnswers++;
    } else {
      newWrongAnswers++;
    }
    
    _gameState = _gameState.copyWith(
      score: newScore,
      correctAnswers: newCorrectAnswers,
      wrongAnswers: newWrongAnswers,
    );
    notifyListeners();
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_questionController.hasNextQuestion) {
        _questionController.nextQuestion();
        _gameState = _gameState.copyWith(
          currentQuestionIndex: _gameState.currentQuestionIndex + 1,
          isAnswering: false,
          carLane: CarLane.left,
        );
        notifyListeners();
      } else {
        endGame();
      }
    });
  }
  
  void endGame() {
    _gameState = _gameState.copyWith(
      status: GameStatus.gameOver,
      endTime: DateTime.now(),
      isAnswering: false,
    );
    notifyListeners();
  }
  
  void restartGame() {
    startGame(questionCount: _gameState.totalQuestions);
  }
  
  void resetGame() {
    _gameState = GameState();
    _questionController.reset();
    notifyListeners();
  }
  
  void pauseGame() {
    if (isGameActive) {
      _gameState = _gameState.copyWith(status: GameStatus.paused);
      notifyListeners();
    }
  }
  
  void resumeGame() {
    if (_gameState.status == GameStatus.paused) {
      _gameState = _gameState.copyWith(status: GameStatus.playing);
      notifyListeners();
    }
  }
  
  Map<String, dynamic> getGameStats() {
    return {
      'score': _gameState.score,
      'totalQuestions': _gameState.totalQuestions,
      'correctAnswers': _gameState.correctAnswers,
      'wrongAnswers': _gameState.wrongAnswers,
      'accuracy': _gameState.accuracy,
      'duration': _gameState.gameDuration,
    };
  }
}