enum GameStatus {
  initial,
  playing,
  paused,
  gameOver,
}

enum CarLane {
  left,
  right,
}

class GameState {
  final GameStatus status;
  final int score;
  final int currentQuestionIndex;
  final CarLane carLane;
  final bool isAnswering;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final DateTime? startTime;
  final DateTime? endTime;

  GameState({
    this.status = GameStatus.initial,
    this.score = 0,
    this.currentQuestionIndex = 0,
    this.carLane = CarLane.left,
    this.isAnswering = false,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.startTime,
    this.endTime,
  });

  GameState copyWith({
    GameStatus? status,
    int? score,
    int? currentQuestionIndex,
    CarLane? carLane,
    bool? isAnswering,
    int? totalQuestions,
    int? correctAnswers,
    int? wrongAnswers,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      carLane: carLane ?? this.carLane,
      isAnswering: isAnswering ?? this.isAnswering,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions) * 100;
  }

  Duration? get gameDuration {
    if (startTime == null || endTime == null) return null;
    return endTime!.difference(startTime!);
  }
}