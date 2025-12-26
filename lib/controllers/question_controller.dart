import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/data_service.dart';

class QuestionController extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = false;

  List<Question> get questions => _questions;
  Question? get currentQuestion => 
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  bool get hasNextQuestion => _currentIndex < _questions.length - 1;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;
  int get totalQuestions => _questions.length;
  int get remainingQuestions => _questions.length - _currentIndex - 1;

  void loadQuestions({int count = 10}) {
    _isLoading = true;
    notifyListeners();

    try {
      _questions = DataService.getRandomQuestions(count: count);
      _currentIndex = 0;
    } catch (e) {
      debugPrint('Error loading questions: $e');
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (hasNextQuestion) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void reset() {
    _questions = [];
    _currentIndex = 0;
    _isLoading = false;
    notifyListeners();
  }

  void shuffleQuestions() {
    _questions.shuffle();
    _currentIndex = 0;
    notifyListeners();
  }

  List<Question> getQuestionsByCategory(String category) {
    return _questions.where((q) => q.category == category).toList();
  }

  List<Question> getQuestionsByDifficulty(int difficulty) {
    return _questions.where((q) => q.difficulty == difficulty).toList();
  }

  Map<String, int> getCategoryStats() {
    Map<String, int> stats = {};
    for (Question question in _questions) {
      stats[question.category] = (stats[question.category] ?? 0) + 1;
    }
    return stats;
  }

  Map<int, int> getDifficultyStats() {
    Map<int, int> stats = {};
    for (Question question in _questions) {
      stats[question.difficulty] = (stats[question.difficulty] ?? 0) + 1;
    }
    return stats;
  }
}